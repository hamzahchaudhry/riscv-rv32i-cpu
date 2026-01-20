module datapath (
    input logic clk,
    input logic [31:0] instr,
    input logic [31:0] pc,
    input logic [31:0] next_pc,

    input logic [31:0] imm,
    input logic [31:0] mem_rd,

    input logic we,
    input logic alu_a_src,
    input logic alu_src,
    input logic [1:0] result_src,
    input logic [3:0] alu_ctrl,

    output logic [31:0] mem_addr,
    output logic [31:0] mem_wd,
    output logic zero
);

  logic [31:0] rd1, rd2, wd;
  logic [31:0] alu_out;
  logic alu_zero;
  logic [7:0] byte_sel;
  logic [15:0] half_sel;
  logic [31:0] load_data;
  logic branch_cond;

  assign mem_addr = alu_out;
  assign mem_wd   = rd2;

  assign byte_sel = mem_rd >> (8 * alu_out[1:0]);
  assign half_sel = mem_rd >> (16 * alu_out[1]);

  always_comb begin
    case (instr[14:12])
      3'b000:  load_data = {{24{byte_sel[7]}}, byte_sel};  /* lb */
      3'b001:  load_data = {{16{half_sel[15]}}, half_sel};  /* lh */
      3'b010:  load_data = mem_rd;  /* lw */
      3'b100:  load_data = {24'd0, byte_sel};  /* lbu */
      3'b101:  load_data = {16'd0, half_sel};  /* lhu */
      default: load_data = mem_rd;
    endcase
  end

  always_comb begin
    case (result_src)
      2'b01:  wd = load_data;
      2'b10:  wd = next_pc;
      2'b11:  wd = imm;
      default: wd = alu_out;
    endcase
  end

  always_comb begin
    case (instr[14:12])
      3'b000:  branch_cond = alu_zero;  /* beq */
      3'b001:  branch_cond = ~alu_zero;  /* bne */
      3'b100:  branch_cond = alu_out[0];  /* blt */
      3'b101:  branch_cond = ~alu_out[0];  /* bge */
      3'b110:  branch_cond = alu_out[0];  /* bltu */
      3'b111:  branch_cond = ~alu_out[0];  /* bgeu */
      default: branch_cond = alu_zero;
    endcase
  end

  assign zero = branch_cond;

  regfile rf (
      .clk(clk),
      .rs1(instr[19:15]),
      .rs2(instr[24:20]),
      .rd (instr[11:7]),
      .wd (wd),
      .we (we),
      .rd1(rd1),
      .rd2(rd2)
  );

  alu alu (
      .alu_ctrl(alu_ctrl),
      .A(alu_a_src ? pc : rd1),
      .B(alu_src ? imm : rd2),
      .alu_out(alu_out),
      .zero(alu_zero)
  );

endmodule
