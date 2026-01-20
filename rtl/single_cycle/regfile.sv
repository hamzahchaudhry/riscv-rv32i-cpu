module regfile (
    input logic clk,

    input logic [ 4:0] rs1,
    input logic [ 4:0] rs2,
    input logic [ 4:0] rd,
    input logic [31:0] wd,
    input logic        we,

    output logic [31:0] rd1,
    output logic [31:0] rd2
);

  logic [31:0] x[32];

  /* synchronous write port */
  always_ff @(posedge clk) begin
    if (we && (rd != 5'd0)) begin
      x[rd] <= wd;
    end
    x[0] <= 32'b0;  /* harden x0 even if something goes wrong */
  end


  /* asynchronous read ports */
  always_comb begin
    rd1 = (rs1 == 5'd0) ? 32'b0 : x[rs1];
    rd2 = (rs2 == 5'd0) ? 32'b0 : x[rs2];

    /* write-through bypass */
    if (we && (rd != 5'd0) && (rd == rs1)) rd1 = wd;
    if (we && (rd != 5'd0) && (rd == rs2)) rd2 = wd;
  end

endmodule
