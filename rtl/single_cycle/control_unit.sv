module control_unit (
    input logic [6:0] opcode,

    output logic pc_src,
    output logic reg_we,
    output logic alu_src,
    output logic mem_we,
    output logic result_src,

    output logic [1:0] alu_op
);

  always_comb begin
    // defaults
    pc_src     = 1'b0;
    reg_we     = 1'b0;
    alu_src    = 1'b0;
    mem_we     = 1'b0;
    result_src = 1'b0;
    alu_op     = 2'b00;

    unique case (opcode)
      // R-type: OP
      7'b0110011: begin
        reg_we     = 1'b1;
        alu_src    = 1'b0;
        alu_op     = 2'b00;  // "use funct" (common encoding)
        mem_we     = 1'b0;
        result_src = 1'b1;  // ALU result
      end

      // I-type arithmetic: OP-IMM
      7'b0010011: begin
        reg_we     = 1'b1;
        alu_src    = 1'b1;  // immediate
        alu_op     = 2'b10;  // use funct3/funct7_5 (for shifts etc later)
        mem_we     = 1'b0;
        result_src = 1'b1;  // ALU result
      end

      // Load
      7'b0000011: begin
        reg_we     = 1'b1;
        alu_src    = 1'b1;  // base + imm
        alu_op     = 2'b01;  // ADD
        mem_we     = 1'b0;
        result_src = 1'b0;  // MEM data
      end

      // Store
      7'b0100011: begin
        reg_we     = 1'b0;
        alu_src    = 1'b1;  // base + imm
        alu_op     = 2'b01;  // ADD
        mem_we     = 1'b1;
        result_src = 1'b0;
      end

      // Branch (very simplified; pc_src needs real branch condition logic elsewhere)
      7'b1100011: begin
        reg_we     = 1'b0;
        alu_src    = 1'b0;
        alu_op     = 2'b11;  // SUB/compare (you can define this)
        mem_we     = 1'b0;
        result_src = 1'b0;
      end

      // AUIPC (writes rd = PC + imm)
      7'b0010111: begin
        reg_we     = 1'b1;
        alu_src    = 1'b1;  // imm
        alu_op     = 2'b01;  // ADD (PC + imm done in datapath via selecting PC as A)
        mem_we     = 1'b0;
        result_src = 1'b0;
      end

      default: begin
        // keep defaults
      end
    endcase
  end

endmodule
