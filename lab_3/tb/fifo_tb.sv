
`timescale 1ns/1ps
 
module fifo_tb;
 
    localparam WIDTH = 8;
    localparam DEPTH = 4;
    localparam ORDER_N = (DEPTH < 3) ? DEPTH : 3;
 
    logic             clk;
    logic             reset;
    logic             wr_en;
    logic [WIDTH-1:0] wr_data;
    logic             rd_en;
    logic [WIDTH-1:0] rd_data;
    logic             full;
    logic             empty;
 
    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );
 
    // Reference model and statistics
    logic [WIDTH-1:0] expected_queue [$];
    int n_writes        = 0;
    int n_reads         = 0;
    int n_simul         = 0;
    int n_wr_rejected   = 0;
    int n_rd_rejected   = 0;
    int n_full_cycles   = 0;
 
    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
 
    // Watchdog
    initial begin
        #100us;
        $fatal(1, "Simulation timed out");
    end
 
    // Helper tasks
    // Drive inputs on the falling edge, let the rising edge happen,
    // then wait 1 ns so outputs have settled before any check.
    task automatic cycle(
        input logic             wr,
        input logic [WIDTH-1:0] wdata,
        input logic             rd
    );
        begin
            @(negedge clk);
            wr_en   = wr;
            wr_data = wdata;
            rd_en   = rd;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;
        end
    endtask
 
    task automatic push(input logic [WIDTH-1:0] value);
        cycle(1'b1, value, 1'b0);
    endtask
 
    // Read one entry and check the value that came out
    task automatic pop_check(input logic [WIDTH-1:0] expected);
        begin
            cycle(1'b0, '0, 1'b1);
            if (rd_data !== expected)
                $fatal(1, "Read mismatch: expected 0x%0h, got 0x%0h", expected, rd_data);
        end
    endtask
 
    task automatic check_flags(
        input logic       exp_empty,
        input logic       exp_full,
        input string      where
    );
        begin
            if (empty !== exp_empty)
                $fatal(1, "[%s] empty: expected %0b, got %0b", where, exp_empty, empty);
            if (full !== exp_full)
                $fatal(1, "[%s] full: expected %0b, got %0b", where, exp_full, full);
        end
    endtask
 
    task automatic do_reset;
        begin
            @(negedge clk);
            reset   = 1;
            wr_en   = 0;
            rd_en   = 0;
            wr_data = '0;
            @(posedge clk);
            #1;
            reset = 0;
        end
    endtask
 
    // Randomized testing

 
    task automatic random_cycle(input int wr_pct, input int rd_pct);
        logic             do_write;
        logic             do_read;
        logic [WIDTH-1:0] expected;
        logic [WIDTH-1:0] prev_rd;
        begin
            expected = '0;
 
            @(negedge clk);
            wr_en   = ($urandom_range(99, 0) < wr_pct);
            rd_en   = ($urandom_range(99, 0) < rd_pct);
            wr_data = WIDTH'($urandom_range(255, 0));
            prev_rd = rd_data;
 
            // Before the rising edge: which operations should be accepted
            do_write = wr_en && !full;
            do_read  = rd_en && !empty;
 
            // Update the reference queue (read first, so a simultaneous
            // read/write returns the oldest entry, not the new one)
            if (do_read)  expected = expected_queue.pop_front();
            if (do_write) expected_queue.push_back(wr_data);
 
            if (do_write)             n_writes++;
            if (do_read)              n_reads++;
            if (do_write && do_read)  n_simul++;
            if (wr_en && !do_write)   n_wr_rejected++;
            if (rd_en && !do_read)    n_rd_rejected++;
 
            @(posedge clk);
            #1;
 
            // After the edge: data check
            if (do_read) begin
                if (rd_data !== expected)
                    $fatal(1, "[random] read mismatch: expected 0x%0h, got 0x%0h", expected, rd_data);
            end
            else if (rd_data !== prev_rd) begin
                $fatal(1, "[random] rd_data changed without an accepted read: 0x%0h -> 0x%0h", prev_rd, rd_data);
            end
 
            // After the edge: flag checks against the model
            if (empty !== (expected_queue.size() == 0))
                $fatal(1, "[random] Incorrect empty flag (model size %0d, empty=%0b)", expected_queue.size(), empty);
            if (full !== (expected_queue.size() == DEPTH))
                $fatal(1, "[random] Incorrect full flag (model size %0d, full=%0b)", expected_queue.size(), full);
 
            if (full) n_full_cycles++;
        end
    endtask
 
    task automatic random_phase(
        input int    cycles,
        input int    wr_pct,
        input int    rd_pct,
        input string name
    );
        begin
            repeat (cycles) random_cycle(wr_pct, rd_pct);
            wr_en = 0;
            rd_en = 0;
            $display("PASS random phase: %s (%0d cycles)", name, cycles);
        end
    endtask
 
    //directed tests, then randomized tests
 
    logic [WIDTH-1:0] held;
 
    initial begin
        reset   = 0;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = '0;

 
        // 1. Reset produces empty = 1 (and full = 0, rd_data = 0)
        do_reset();
        check_flags(1'b1, 1'b0, "after reset");
        if (rd_data !== '0)
            $fatal(1, "[after reset] rd_data: expected 0, got 0x%0h", rd_data);
 
        // 2. One write makes the FIFO non-empty
        push(8'hA1);
        check_flags(1'b0, 1'b0, "after one write");
 
        // 3. Write then read returns the correct data
        pop_check(8'hA1);
        check_flags(1'b1, 1'b0, "after write/read");
 
        // 4. Multiple values preserve order
        for (int i = 0; i < ORDER_N; i++)
            push(WIDTH'(10 * (i + 1)));
        for (int i = 0; i < ORDER_N; i++)
            pop_check(WIDTH'(10 * (i + 1)));
        check_flags(1'b1, 1'b0, "after ordered drain");
 
        // 5. Filling the FIFO asserts full
        do_reset();
        for (int i = 0; i < DEPTH; i++) begin
            check_flags(i == 0, 1'b0, "while filling");
            push(WIDTH'(8'h50 + WIDTH'(i)));
        end
        check_flags(1'b0, 1'b1, "after fill");
 
        // 6. A write while full is rejected
        push(8'hFF);
        check_flags(1'b0, 1'b1, "after write while full");
 
        // 7. Draining the FIFO asserts empty
        //    Also confirms 0xFF from test 6 never got stored
        for (int i = 0; i < DEPTH; i++) begin
            check_flags(1'b0, i == 0, "while draining");
            pop_check(WIDTH'(8'h50 + WIDTH'(i)));
        end
        check_flags(1'b1, 1'b0, "after drain");
 
        // 8. A read while empty is rejected
        held = rd_data;
        cycle(1'b0, '0, 1'b1);
        check_flags(1'b1, 1'b0, "after read while empty");
        if (rd_data !== held)
            $fatal(1, "[read while empty] rd_data changed: was 0x%0h, now 0x%0h", held, rd_data);
        push(8'h77);
        pop_check(8'h77);
        check_flags(1'b1, 1'b0, "after recovery");
 
        // 9. Pointer wraparound
        //    a) Partial fill, partial drain, refill across the boundary
        do_reset();
        for (int i = 0; i < DEPTH - 1; i++)
            push(WIDTH'(8'h01 + WIDTH'(i)));
        for (int i = 0; i < DEPTH - 2; i++)
            pop_check(WIDTH'(8'h01 + WIDTH'(i)));
        for (int i = DEPTH - 1; i < 2 * DEPTH - 2; i++)
            push(WIDTH'(8'h01 + WIDTH'(i)));
        check_flags(1'b0, 1'b1, "wrap: full across boundary");
        for (int i = DEPTH - 2; i < 2 * DEPTH - 2; i++)
            pop_check(WIDTH'(8'h01 + WIDTH'(i)));
        check_flags(1'b1, 1'b0, "wrap: drained");
 
        //    b) Single write/read pairs for several laps of the buffer
        for (int i = 0; i < 3 * DEPTH; i++) begin
            push(WIDTH'(8'hC0 + WIDTH'(i)));
            pop_check(WIDTH'(8'hC0 + WIDTH'(i)));
        end
        check_flags(1'b1, 1'b0, "wrap: multiple laps");
 
        // 10. Simultaneous read/write
        //     a) Partially full: both accepted
        do_reset();
        push(8'h11);
        cycle(1'b1, 8'h22, 1'b1);
        if (rd_data !== 8'h11)
            $fatal(1, "[simul r/w] expected 0x11, got 0x%0h", rd_data);
        check_flags(1'b0, 1'b0, "simul r/w partial");
        cycle(1'b1, 8'h33, 1'b1);
        if (rd_data !== 8'h22)
            $fatal(1, "[simul r/w] expected 0x22, got 0x%0h", rd_data);
        check_flags(1'b0, 1'b0, "simul r/w partial");
        pop_check(8'h33);
        check_flags(1'b1, 1'b0, "simul r/w partial drained");
 
        //     b) Starting empty: read rejected, write accepted
        held = rd_data;
        cycle(1'b1, 8'h55, 1'b1);
        check_flags(1'b0, 1'b0, "simul r/w from empty");
        if (rd_data !== held)
            $fatal(1, "[simul r/w from empty] read should be rejected, rd_data changed to 0x%0h", rd_data);
        pop_check(8'h55);
        check_flags(1'b1, 1'b0, "simul r/w from empty drained");
 
        //     c) Starting full: write rejected, read accepted
        for (int i = 0; i < DEPTH; i++)
            push(WIDTH'(8'h90 + WIDTH'(i)));
        check_flags(1'b0, 1'b1, "simul r/w pre-full");
        cycle(1'b1, 8'hEE, 1'b1);
        if (rd_data !== 8'h90)
            $fatal(1, "[simul r/w from full] expected 0x90, got 0x%0h", rd_data);
        check_flags(1'b0, 1'b0, "simul r/w from full");
        for (int i = 1; i < DEPTH; i++)
            pop_check(WIDTH'(8'h90 + WIDTH'(i)));
        check_flags(1'b1, 1'b0, "simul r/w from full drained"); // 0xEE was dropped
 
        $display("PASS directed tests");
 
        // ---------------- Randomized tests ----------------
 
        // Start from a known state so the DUT and the model agree
        do_reset();
        expected_queue.delete();
        check_flags(1'b1, 1'b0, "before random tests");
 
        // 50/50 is equivalent to wr_en/rd_en = $urandom_range(1, 0)
        random_phase(500, 50, 50, "balanced 50/50");
        // Write-heavy: spends time full, exercises rejected writes
        random_phase(500, 90, 20, "write-heavy");
        // Read-heavy: spends time empty, exercises rejected reads
        random_phase(500, 20, 90, "read-heavy");
        // Both busy: many simultaneous read/write cycles
        random_phase(500, 90, 90, "both busy");
 
        $display("Stats: writes=%0d reads=%0d simul=%0d wr_rej=%0d rd_rej=%0d full_cycles=%0d",
                 n_writes, n_reads, n_simul, n_wr_rejected, n_rd_rejected, n_full_cycles);
 
        // Make sure the random test actually hit the corner cases
        if (n_writes == 0 || n_reads == 0 || n_simul == 0 ||
            n_wr_rejected == 0 || n_rd_rejected == 0 || n_full_cycles == 0)
            $fatal(1, "Random testing did not cover all corner cases");
 
        // Only reached if every directed and random check passed
        $display("All FIFO tests passed!");
        $finish;
    end
 
endmodule