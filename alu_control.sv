`define ADD 3'b000
`define SUB 3'b001
`define XOR 3'b100
`define OR 3'b011
`define AND 3'b010

module alu_control (
    input  logic [2:0] funct3,
    input  logic       funct7,
    output logic [2:0] alu_op
);

  always_comb begin
    unique casez ({
      funct7, funct3
    })
      4'b0_000: alu_op = `ADD;
      4'b1_000: alu_op = `SUB;
      4'b?_100: alu_op = `XOR;
      4'b?_110: alu_op = `OR;
      4'b?_111: alu_op = `AND;
      default:  alu_op = 'x;
    endcase
  end

endmodule
