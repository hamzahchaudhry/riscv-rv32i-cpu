module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic zero,
    output logic pc_src,
    output logic [1:0] result_src,
    output logic mem_we,
    output logic alu_a_src,
    output logic alu_src,
    output logic reg_we,
    output logic [1:0] alu_op,
    output logic jalr
);

  logic jump, branch;
  assign pc_src = branch || jump;

  always_comb begin
    unique case (opcode)
      /* load */
      7'b0000011: begin
        result_src = 2'b01;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* store */
      7'b0100011: begin
        result_src = 2'b00;
        mem_we     = 1'b1;
        alu_a_src  = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b0;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* R-type */
      7'b0110011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b1;
        alu_op     = 2'b10;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* branch */
      7'b1100011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b0;
        alu_op     = 2'b01;
        jump       = 1'd0;
        branch     = zero;
        jalr       = 1'd0;
      end

      /* I-type ALU */
      7'b0010011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b10;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* jalr */
      7'b1100111: begin
        result_src = 2'b10;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd1;
        jalr       = 1'd1;
      end

      /* lui */
      7'b0110111: begin
        result_src = 2'b11;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* auipc */
      7'b0010111: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_a_src  = 1'b1;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end

      /* jal */
      7'b1101111: begin
        result_src = 2'b10;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd1;
        jalr       = 1'd0;
      end

      default: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_a_src  = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b0;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
        jalr       = 1'd0;
      end
    endcase
  end

endmodule
