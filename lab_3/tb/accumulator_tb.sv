`timescale 1ns/1ps

module accumulator_tb;

    logic clk;
    logic reset;
    logic enable;
    logic [7:0] data_in;
    logic [7:0] sum;

    logic [7:0] expected_sum;

    accumulator #(
        .WIDTH(8)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .data_in(data_in),
        .sum(sum)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #100us;
        $fatal(1, "Simulation timed out");
    end
    initial begin
        // Reset the DUT and initialize expected_sum
        reset        = 1;
        enable       = 0;
        data_in      = 8'd0;
        expected_sum = 8'd0;

        @(posedge clk);
        @(posedge clk);
        #1;

        if (sum !== expected_sum) begin
            $fatal(1, "Reset check failed: Expected %0d, got %0d", expected_sum, sum);
        end

        reset = 0;

        //Run 100 randomized cycles
        for (int i = 0; i < 100; i++) begin
            // Randomly choose enable and data_in
            data_in = 8'($urandom_range(255, 0));
            enable  = 1'($urandom_range(1, 0));
            @(posedge clk);

            if (enable) begin
                expected_sum = expected_sum + data_in; 
            end

            #1;

            if (sum !== expected_sum) begin
                $fatal(1, "Expected %0d, got %0d", expected_sum, sum);
            end
        end

        $display("All tests passed");
        $finish;
    end
/*
    // Write your tests here.
    initial begin
    reset = 1;
    enable = 0;
    data_in = 8'd0;

    @(posedge clk);
    @(posedge clk);
    #1;
    //checking if reset clears sum
    if(sum !== 8'd0) begin
        $fatal(1, "Reset failed: expected 0, got %0d", sum);
    end

    reset = 0;
    //checking additions
    enable = 1;
    data_in = 8'd10;
    @(posedge clk);
    #1;
    if(sum !== 8'd10) begin
        $fatal(1, "Addition failed: expected 10, got %0d", sum);
    end

    data_in = 8'd5;
    @(posedge clk);
    #1;
    if(sum !== 8'd15) begin
        $fatal(1, "Addition faild: expected 15, got %0d", sum);
    end
    // checking if enable = 0 holds
    enable = 0;
    data_in = 8'd10;
    @(posedge clk);
    @(posedge clk);
    #1;
    if(sum !== 8'd15) begin
        $fatal(1, "Hold value failed enable set to 0: expected 20, got %0d", sum);
    end

    enable = 1;
    //check if counting starts again
    data_in = 8'd5;
    @(posedge clk);
    #1;
    if(sum !== 8'd20) begin
        $fatal(1, "Resuming Addition Failed: Expected 20, got %0d", sum);
    end

    //checking 8-bit overflow
    data_in = 8'd250;
    @(posedge clk);
    #1;
    if(sum !== 8'd14) begin
        $fatal(1, "overflow failed: expected 14, got %0d", sum);
    end

    $display("All tests passed");
    $finish;
    end
*/

endmodule
