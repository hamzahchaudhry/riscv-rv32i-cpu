module instruction_decoder (
    input logic [31:0] instruction,

    output logic [4:0] rs2,
    output logic [4:0] rs1,
    output logic [4:0] rd,
    output logic [6:0] opcode
);

  assign rs2 = instruction[24:20];
  assign rs1 = instruction[19:15];
  assign rd = instruction[11:7];
  assign opcode = instruction[6:0];

endmodule
