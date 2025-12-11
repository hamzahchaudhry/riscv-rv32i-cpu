module datapath (
    input logic clk,
    input logic [31:0] data_in,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic write_en
);

  regfile regfile (
      .clk(clk),
      .data_in(data_in),
      .read_reg1(rs1),
      .read_reg2(rs2),
      .write_reg(rd),
      .write_en(write_en),

      .data_out1(),
      .data_out2()
  );

  imm_gen imm_gen (
      .instruction(instruction),

      .imm_out()
  );

  alu_control alu_control (
      .funct3(instruction[14:12]),
      .funct7(instruction[30]),
      .alu_op(alu_op)
  );

  logic [31:0] Ain, Bin;
  assign Ain = data_out1;
  assign Bin = bsel ? imm_out : data_out2;

  alu alu (
      .Ain(Ain),
      .Bin(Bin),
      .alu_op(alu_op),

      .out()
  );

endmodule
