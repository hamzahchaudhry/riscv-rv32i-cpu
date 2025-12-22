module alu (
    input logic [ 2:0] alu_ctrl,
    input logic [31:0] A,
    input logic [31:0] B,

    output logic [31:0] alu_out,
    output logic zero
);

  localparam logic [2:0] ADD = 3'b000;
  localparam logic [2:0] SUB = 3'b001;
  localparam logic [2:0] AND = 3'b011;
  localparam logic [2:0] OR = 3'b100;
  localparam logic [2:0] XOR = 3'b101;
  localparam logic [2:0] SLT = 3'b110;

  assign zero = (alu_out == 32'b0);

  always_comb begin
    unique case (alu_ctrl)
      ADD: alu_out = A + B;
      SUB: alu_out = A - B;
      AND: alu_out = A & B;
      OR: alu_out = A | B;
      XOR: alu_out = A ^ B;
      default: alu_out = 32'd0;
    endcase
  end

endmodule
