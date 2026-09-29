module sequence_detector (
    input  logic clk,
    input  logic reset,
    input  logic x,
    output logic detect
);

    // Your FSM here
    typedef enum logic [2:0] {
        S0,  // Nothing useful matched
        S1,  // Matched "1"
        S2,  // Matched "10"
        S3,  // Matched "101"
        S4   // Matched "1011"
    } state_t;
    state_t state;
    state_t next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
    next_state = state;
    detect = 1'b0;

    case (state)

        S0: begin
            if (x) next_state = S0;
            else next_state = S2;
        end

        S2: begin 
            if (x) next_state = S3;
            else next_state = S0;
        end

        S3: begin
            if (x) next_state = S4;
            else next_state = S2;
        end

        S4: begin
            detect = 1'b1;
            if (x) next_state = S1;
            else next_state = S2;
        end

        default: begin
            next_state = S0;
            detect = 1'b0;
        end

    endcase
end

endmodule