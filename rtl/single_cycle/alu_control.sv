module alu_control (
    input logic [1:0] alu_op,
    input logic [2:0] funct3,
    input logic funct7_5,
    input logic opcode_5,
    output logic [2:0] alu_ctrl
);

  localparam logic [2:0] ADD = 3'b000;
  localparam logic [2:0] SUB = 3'b001;
  localparam logic [2:0] AND = 3'b010;
  localparam logic [2:0] OR = 3'b011;
  localparam logic [2:0] SLT = 3'b101;

  always_comb begin
    case (alu_op)

      /* lw, sw */
      2'b00: alu_ctrl = ADD;

      /* beq */
      2'b01: alu_ctrl = SUB;

      /* add, sub, slt, or, and */
      2'b10: begin
        casez ({
          funct3, opcode_5, funct7_5
        })
          5'b00011: alu_ctrl = SUB;
          5'b000??: alu_ctrl = ADD;
          5'b010??: alu_ctrl = SLT;
          5'b110??: alu_ctrl = OR;
          5'b111??: alu_ctrl = AND;
          default:  alu_ctrl = 3'b111;
        endcase
      end

      default: alu_ctrl = 3'b111;
    endcase
  end

endmodule
