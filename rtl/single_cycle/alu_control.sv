`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SUB 4'b0110

module alu_control (
    input  logic [1:0] ALUop,
    input  logic [2:0] funct3,
    input  logic       funct7_30,  /* instruction[30] */
    output logic [3:0] ALUcontrol
);

  always_comb begin
    case (ALUop)
      /* load / store */
      2'b00: ALUcontrol = `ADD;

      /* branch (beq) */
      2'b01: ALUcontrol = `SUB;

      /* R-type */
      2'b10: begin
        case (funct3)
          3'b000: begin
            /* ADD or SUB depends on funct7[30] */
            if (funct7_30) ALUcontrol = `SUB;
            else ALUcontrol = `ADD;
          end

          3'b111: ALUcontrol = `AND;
          3'b110: ALUcontrol = `OR;

          default: ALUcontrol = 4'd0;
        endcase
      end
      default: ALUcontrol = 4'd0;
    endcase
  end

endmodule
