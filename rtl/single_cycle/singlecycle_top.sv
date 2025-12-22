module singlecycle_top (
    input logic clk,
    input logic reset
);

  logic [31:0] pc_next, pc, instr;
  logic [31:0] addr, wd, rd;
  logic [31:0] imm_out;
  logic pc_src, reg_we, alu_src, mem_we, result_src;
  logic [1:0] alu_op;
  logic [2:0] alu_ctrl;

  imem imem (
      .pc(pc),
      .instr(instr)
  );

  dmem dmem (
      .clk (clk),
      .we  (mem_we),
      .addr(addr),
      .wd  (wd),
      .rd  (rd)
  );

  control_unit cu (
      .opcode(instr[6:0]),
      .pc_src(pc_src),
      .reg_we(reg_we),
      .alu_src(alu_src),
      .mem_we(mem_we),
      .result_src(result_src),
      .alu_op(alu_op)
  );

  alu_control ac (
      .alu_op  (alu_op),
      .funct3  (instr[14:12]),
      .funct7_5(instr[30]),
      .alu_ctrl(alu_ctrl)
  );

  dff #(
      .WIDTH(32)
  ) pc_reg (
      .clk(clk),
      .reset(reset),
      .d(pc_next),
      .q(pc)
  );

  adder pc_adder (
      .a  (pc),
      .b  (pc_src ? imm_out : 32'd4),
      .out(pc_next)
  );

  imm_gen ig (
      .instr  (instr),
      .imm_out(imm_out)
  );

  datapath dp (
      .clk  (clk),
      .instr(instr),

      .imm(imm_out),
      .mem_rd(rd),

      .we(reg_we),
      .alu_src(alu_src),
      .result_src(result_src),
      .alu_ctrl(alu_ctrl),

      .mem_addr(addr),
      .mem_wd(wd),
      .zero()
  );


endmodule
