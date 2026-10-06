`timescale 1ns/1ps

module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 4
) (
    input  logic             clk,
    input  logic             reset,

    input  logic             wr_en,
    input  logic [WIDTH-1:0] wr_data,

    input  logic             rd_en,
    output logic [WIDTH-1:0] rd_data,

    output logic             full,
    output logic             empty
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam CNT_WIDTH = $clog2(DEPTH + 1);
    localparam logic [PTR_WIDTH-1:0] LAST_IDX = PTR_WIDTH'(DEPTH - 1);
    localparam logic [CNT_WIDTH-1:0] MAX_CNT  = CNT_WIDTH'(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];

    logic [PTR_WIDTH-1:0] wr_ptr;
    logic [PTR_WIDTH-1:0] rd_ptr;

    // Occupancy Count
    logic [CNT_WIDTH-1:0] count;

    logic do_write;
    logic do_read;

    assign do_write = wr_en && !full;
    assign do_read  = rd_en && !empty;

    assign empty = (count == '0);
    assign full  = (count == MAX_CNT);

    always_ff @(posedge clk) begin
        if (reset) begin
            wr_ptr  <= '0;
            rd_ptr  <= '0;
            count   <= '0;
            rd_data <= '0;
        end
        else begin
            // Memory write and write pointer update
            if (do_write) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr      <= (wr_ptr == LAST_IDX) ? '0 : wr_ptr + 1'b1;
            end

            // Registered read and read pointer update
            if (do_read) begin
                rd_data <= mem[rd_ptr];
                rd_ptr  <= (rd_ptr == LAST_IDX) ? '0 : rd_ptr + 1'b1;
            end

            // Occupancy counter update
            case ({do_write, do_read})
                2'b10: count <= count + 1'b1; // Write only: increment count
                2'b01: count <= count - 1'b1; // Read only: decrement count
                default: ;                    // No-op or simultaneous read/write: no change
            endcase
        end
    end

endmodule
