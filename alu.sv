`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR 3'b011
`define XOR 3'b100

module alu (
    input logic [31:0] Ain,
    input logic [31:0] Bin,
    input logic [ 2:0] alu_op,

    output logic [31:0] out
);

  always_comb begin
    unique case (alu_op)
      `ADD: out = Ain + Bin;
      `SUB: out = Ain - Bin;
      `AND: out = Ain & Bin;
      `OR: out = Ain | Bin;
      `XOR: out = Ain ^ Bin;
      default: out = 'x;
    endcase
  end

endmodule
