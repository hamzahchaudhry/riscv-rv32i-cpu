module alu (
    input logic [3:0] alu_ctrl,
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] alu_out,
    output logic zero
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

  assign zero = (alu_out == 32'b0);

  always_comb begin
    unique case (alu_ctrl)
      ADD:  alu_out = A + B;
      SUB:  alu_out = A - B;
      AND:  alu_out = A & B;
      OR:   alu_out = A | B;
      XOR:  alu_out = A ^ B;
      SLT:  alu_out = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
      SLTU: alu_out = (A < B) ? 32'd1 : 32'd0;
      SRA:  alu_out = $signed(A) >>> B[4:0];
      SRL:  alu_out = A >> B[4:0];
      SLL:  alu_out = A << B[4:0];

      default: alu_out = 32'd0;
    endcase
  end

endmodule
