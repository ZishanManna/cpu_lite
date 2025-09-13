module mux_2_1 #(parameter WIDTH = 7) (i0, i1, sel, mux_out); 
 //this module implements the parametraized 2:1 mux
  input sel;
  input [WIDTH-1:0] i0;
  input [WIDTH-1:0] i1;
  output [WIDTH-1:0] mux_out;

  assign mux_out = sel ? i1 : i0;  //using ternary operator to implement mux

endmodule
