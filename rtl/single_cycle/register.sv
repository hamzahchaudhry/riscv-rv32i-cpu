module register #(
    parameter int WIDTH = 1
) (
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] in,
    input logic load,

  output logic [WIDTH-1:0] out
);

  logic [WIDTH-1:0] next_out;
  assign next_out = load ? in : out;

  flop #(
      .WIDTH(WIDTH)
  ) flop (
      .clk(clk),
      .reset(reset),
      .d(next_out),
      .q(out)
  );

endmodule
