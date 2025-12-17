module top_level (
    input logic clk,
    input logic reset
);

  logic [31:0] pc, instruction;
  logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
  logic [31:0] imm_out;
  logic zero;

  instruction_memory instruction_memory (
      .ce     (1'b1),
      .read_en(1'b1),
      .pc     (pc),
      .instr  (instruction)
  );

  always_ff @(posedge clk) begin
    if (reset) pc <= 32'b0;
    else if (Branch && zero) pc <= pc + imm_out;
    else pc <= pc + 4;
  end

  logic [1:0] ALUOp;
  control_unit control_unit (
      .opcode(instruction[6:0]),
      .ALUSrc(ALUSrc),
      .MemtoReg(MemtoReg),
      .RegWrite(RegWrite),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
      .Branch(Branch),
      .ALUOp(ALUOp)
  );

  datapath datapath (
      .clk(clk),
      .reset(reset),
      .instruction(instruction),
      .ALUsrc(ALUSrc),
      .regwrite(RegWrite),
      .ALUop(ALUOp),
      .memwrite(MemWrite),
      .memread(MemRead),
      .memtoreg(MemtoReg),

      .imm_out(imm_out),
      .zero(zero)
  );

endmodule
