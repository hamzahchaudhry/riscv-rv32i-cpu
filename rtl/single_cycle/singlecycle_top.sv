module singlecycle_top #(
    parameter string IMEM_INIT = "imem.hex",
    parameter string DMEM_INIT = "dmem.hex"
) (
    input logic clk,
    input logic reset
);

  logic [31:0] pc_next, pc, instr;
  logic [31:0] addr, wd, rd;
  logic [31:0] imm_out;
  logic [31:0] pc_plus4, pc_target;
  logic pc_src, reg_we, alu_src, mem_we, zero;
  logic [1:0] result_src;
  logic [1:0] alu_op;
  logic [2:0] alu_ctrl;

  /* simple instruction memory */
  imem #(
      .IMEM_INIT(IMEM_INIT)
  ) imem (
      .pc(pc),
      .instr(instr)
  );

  /* simple data memory */
  dmem #(
      .DMEM_INIT(DMEM_INIT)
  ) dmem (
      .clk (clk),
      .we  (mem_we),
      .addr(addr),
      .wd  (wd),
      .rd  (rd)
  );

  /* main control unit */
  control_unit cu (
      .opcode(instr[6:0]),
      .zero(zero),
      .pc_src(pc_src),
      .result_src(result_src),
      .mem_we(mem_we),
      .alu_src(alu_src),
      .reg_we(reg_we),
      .alu_op(alu_op)
  );

  /* alu control unit */
  alu_control ac (
      .alu_op  (alu_op),
      .funct3  (instr[14:12]),
      .funct7_5(instr[30]),
      .opcode_5(instr[5]),
      .alu_ctrl(alu_ctrl)
  );

  /* PC */
  dff #(
      .WIDTH(32)
  ) pc_reg (
      .clk(clk),
      .reset(reset),
      .d(pc_next),
      .q(pc)
  );

  /* next PC adder */
  adder pc_plus4_adder (
      .a  (pc),
      .b  (32'd4),
      .out(pc_plus4)
  );

  /* branch target PC adder */
  adder pc_target_adder (
      .a  (pc),
      .b  (imm_out),
      .out(pc_target)
  );

  assign pc_next = pc_src ? pc_target : pc_plus4;

  imm_gen ig (
      .instr  (instr),
      .imm_out(imm_out)
  );

  datapath dp (
      .clk(clk),
      .instr(instr),
      .next_pc(pc_plus4),

      .imm(imm_out),
      .mem_rd(rd),

      .we(reg_we),
      .alu_src(alu_src),
      .result_src(result_src),
      .alu_ctrl(alu_ctrl),

      .mem_addr(addr),
      .mem_wd(wd),
      .zero(zero)
  );

endmodule
