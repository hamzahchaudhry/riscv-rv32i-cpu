module datapath (
    input logic clk,
    input logic reset,
    input logic [31:0] instruction,

    /* control signals */
    input logic ALUsrc,
    input logic regwrite,
    input logic [1:0] ALUop,
    input logic memwrite,
    input logic memread,
    input logic memtoreg,

    output logic [31:0] imm_out,
    output logic zero
);

  logic [4:0] rs2;
  logic [4:0] rs1;
  logic [4:0] rd;
  logic [6:0] opcode;

  instruction_decoder instruction_decoder (
      .instruction(instruction),
      .rs2(rs2),
      .rs1(rs1),
      .rd(rd),
      .opcode(opcode)
  );

  logic [31:0] write_data;
  logic [31:0] read_data1;
  logic [31:0] read_data2;

  logic [31:0] read_data_mem;

  regfile regfile (
      .clk(clk),
      .reset(reset),
      .read_reg1(rs1),
      .read_reg2(rs2),
      .write_reg(rd),
      .write_data(write_data),
      .regwrite(regwrite),

      .read_data1(read_data1),
      .read_data2(read_data2)
  );

  imm_gen imm_gen (
      .instruction(instruction),

      .imm_out(imm_out)
  );

  logic [3:0] ALUcontrol;
  alu_control alu_control (
      .ALUop(ALUop),
      .funct3(instruction[14:12]),
      .funct7_30(instruction[30]),

      .ALUcontrol(ALUcontrol)
  );

  logic [31:0] Bin, alu_result;
  assign Bin = ALUsrc ? imm_out : read_data2;
  alu alu (
      .ALUcontrol(ALUcontrol),
      .Ain(read_data1),
      .Bin(Bin),

      .alu_out(alu_result),
      .zero(zero)
  );

  data_memory data_memory (
      .clk       (clk),
      .memread   (memread),
      .memwrite  (memwrite),
      .address   (alu_result),
      .write_data(read_data2),

      .read_data(read_data_mem)
  );

  assign write_data = memtoreg ? read_data_mem : alu_result;

endmodule
