module d_ff #(
    parameter WIDTH = 7  // Default width is 8 bits
)(
    input  wire                 clk,  // Clock input
    input  wire                 rst,  // Asynchronous reset (active high)
    input  wire [WIDTH-1:0]     d,    // Data input
    output reg  [WIDTH-1:0]     q     // Output
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            q <= {WIDTH{1'b0}}; // Reset all bits to 0
        else
            q <= d;             // Latch input data
    end

endmodule

