module alu_control (
    input logic [1:0] alu_op,
    input logic [2:0] funct3,
    input logic funct7_5,
    input logic opcode_5,
    output logic [3:0] alu_ctrl
);

  localparam logic [3:0] ADD = 4'b0000;
  localparam logic [3:0] SUB = 4'b0001;
  localparam logic [3:0] AND = 4'b0010;
  localparam logic [3:0] OR = 4'b0011;
  localparam logic [3:0] XOR = 4'b0100;
  localparam logic [3:0] SLT = 4'b0101;
  localparam logic [3:0] SLTU = 4'b1001;
  localparam logic [3:0] SRA = 4'b0110;
  localparam logic [3:0] SRL = 4'b0111;
  localparam logic [3:0] SLL = 4'b1000;

  always_comb begin
    case (alu_op)

      /* load, store */
      2'b00: alu_ctrl = ADD;

      /* branch */
      2'b01: begin
        unique case (funct3)
          3'b000, 3'b001: alu_ctrl = SUB;  /* beq, bne */
          3'b100, 3'b101: alu_ctrl = SLT;  /* blt, bge */
          3'b110, 3'b111: alu_ctrl = SLTU;  /* bltu, bgeu */
          default:        alu_ctrl = SUB;
        endcase
      end


      /* add, sub, slt, sltu, or, and, xor, sra, srl, sll */
      2'b10: begin
        casez ({
          funct3, opcode_5, funct7_5
        })
          5'b00011: alu_ctrl = SUB;
          5'b000??: alu_ctrl = ADD;
          5'b010??: alu_ctrl = SLT;
          5'b011??: alu_ctrl = SLTU;
          5'b110??: alu_ctrl = OR;
          5'b111??: alu_ctrl = AND;
          5'b?100?: alu_ctrl = XOR;
          5'b101?1: alu_ctrl = SRA;
          5'b101?0: alu_ctrl = SRL;
          5'b001?0: alu_ctrl = SLL;
          default:  alu_ctrl = 4'b1111;
        endcase
      end

      default: alu_ctrl = 4'b1111;
    endcase
  end

endmodule
