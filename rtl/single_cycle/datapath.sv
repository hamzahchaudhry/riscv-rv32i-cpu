module datapath (
    input logic clk,
    input logic [31:0] instr,

    input logic [31:0] imm,
    input logic [31:0] mem_rd,

    input logic we,
    input logic alu_src,
    input logic result_src,
    input logic [2:0] alu_ctrl,

    output logic [31:0] mem_addr,
    output logic [31:0] mem_wd,
    output logic zero
);

  logic [31:0] rd1, rd2, wd;
  logic [31:0] alu_out;

  assign mem_addr = alu_out;
  assign mem_wd   = rd2;

  regfile rf (
      .clk(clk),
      .rs1(instr[19:15]),
      .rs2(instr[24:20]),
      .rd (instr[11:7]),
      .wd (result_src ? alu_out : mem_rd),
      .we (we),
      .rd1(rd1),
      .rd2(rd2)
  );

  alu alu (
      .alu_ctrl(alu_ctrl),
      .A(rd1),
      .B(alu_src ? imm : rd2),
      .alu_out(alu_out),
      .zero(zero)
  );

endmodule
