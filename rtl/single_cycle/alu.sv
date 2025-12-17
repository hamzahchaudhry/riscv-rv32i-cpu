`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SUB 4'b0110

module alu (
    input logic [ 3:0] ALUcontrol,
    input logic [31:0] Ain,
    input logic [31:0] Bin,

    output logic [31:0] alu_out,
    output logic zero
);

  assign zero = (alu_out == 32'b0);
  always_comb begin
    unique case (ALUcontrol)
      `AND: alu_out = Ain & Bin;
      `OR: alu_out = Ain | Bin;
      `ADD: alu_out = Ain + Bin;
      `SUB: alu_out = Ain - Bin;
      default: alu_out = 'x;
    endcase
  end

endmodule
