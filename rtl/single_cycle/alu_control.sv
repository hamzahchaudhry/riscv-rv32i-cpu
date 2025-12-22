module alu_control (
    input logic [1:0] alu_op,
    input logic [2:0] funct3,
    input logic funct7_5,
    output logic [2:0] alu_ctrl
);

  localparam logic [2:0] ADD = 3'b000;
  localparam logic [2:0] SUB = 3'b001;
  localparam logic [2:0] AND = 3'b011;
  localparam logic [2:0] OR = 3'b100;
  localparam logic [2:0] XOR = 3'b101;
  localparam logic [2:0] SLT = 3'b110;
  always_comb begin
    case (alu_op)

      /* R-type */
      2'b00: alu_ctrl = funct7_5 ? SUB : ADD;

      /* load + store */
      2'b01: alu_ctrl = ADD;

      /* I-type */
      2'b10:
      casez (funct3)
        3'b000:  alu_ctrl = ADD;
        3'b01x:  alu_ctrl = SLT;
        3'b100:  alu_ctrl = XOR;
        3'b110:  alu_ctrl = OR;
        3'b111:  alu_ctrl = AND;
        default: alu_ctrl = 3'b111;
      endcase

      2'b11: alu_ctrl = SUB;

      default: alu_ctrl = 3'b111;
    endcase
  end

endmodule
