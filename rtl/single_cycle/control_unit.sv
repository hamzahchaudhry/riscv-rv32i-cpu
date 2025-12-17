module control_unit (
    input logic [6:0] opcode,

    output logic       ALUSrc,
    output logic       MemtoReg,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       Branch,
    output logic [1:0] ALUOp
);

  always_comb begin
    // defaults (safe)
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    RegWrite = 1'b0;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    Branch   = 1'b0;
    ALUOp    = 2'b00;

    case (opcode)

      // R-format (0110011)
      7'b0110011: begin
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b1;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b10;
      end

      // ld / lw (0000011)
      7'b0000011: begin
        ALUSrc   = 1'b1;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        MemRead  = 1'b1;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;
      end

      // sd / sw (0100011)
      7'b0100011: begin
        ALUSrc   = 1'b1;
        // MemtoReg = X (don’t care) -> leave default 0
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b1;
        Branch   = 1'b0;
        ALUOp    = 2'b00;
      end

      // beq (1100011)
      7'b1100011: begin
        ALUSrc   = 1'b0;
        // MemtoReg = X (don’t care) -> leave default 0
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b1;
        ALUOp    = 2'b01;
      end

      default: begin
        // keep defaults (NOP-ish)
      end

    endcase
  end

endmodule
