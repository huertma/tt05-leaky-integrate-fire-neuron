`default_nettype none

module lif ( //registers
    input wire [3:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [6:0] state
);

reg [7:0] next_state, threshold; %how many bits can we store these in

always @(posedge clk) begin //define what goes in register
    if (!rst_n) begin //define what happens if u reset ckt
        state <= 0;
        threshold <= 127; //stored like a register
    end else begin
        state <= next_state;
    end

// next_state logic 
assign next_state = current + (state >> 1)   

// spiking logic
assign spike = (state >= threshold);

end

endmodule

