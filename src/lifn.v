`default_nettype none

module lifn ( 
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n, // active low, RESET happens when rst_n is 0
    output wire      spike,
    output reg [7:0] state
);
    reg [7:0] threshold;
    wire [7:0] next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 230;
        end else begin
            state <= next_state;
        end
    end

    // next_state logic and spiking logic
    assign spike = (state >= threshold);
    // assign next_state = current + (spike ? 0 : state >> 1)
    // if there is a spike, next state is current + 0; if no spike, next state is current + half of state

    assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));
    // first term: if there is a spike, dont add current. if no spike, add current
    // second term: if yes spike, add zero; if no spike, add 0.875 times state (this implicitly sets Beta decay rate)
    // combine the two terms: if yes spike, HARD RESET (both terms eval to zero)

endmodule
