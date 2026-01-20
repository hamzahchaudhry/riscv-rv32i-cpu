module control_unit (
    input logic [6:0] opcode,
    input logic zero,
    output logic pc_src,
    output logic [1:0] result_src,
    output logic mem_we,
    output logic alu_src,
    output logic reg_we,
    output logic [1:0] alu_op
);

  logic jump, branch;
  assign pc_src = (branch && zero) || jump;

  always_comb begin
    result_src = 2'b00;
    mem_we     = 1'b0;
    alu_src    = 1'b0;
    reg_we     = 1'b0;
    alu_op     = 2'b00;
    branch     = 1'd0;
    jump       = 1'd0;

    unique case (opcode)
      /* lw */
      7'b0000011: begin
        result_src = 2'b01;
        mem_we     = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
      end

      /* sw */
      7'b0100011: begin
        result_src = 2'b00;
        mem_we     = 1'b1;
        alu_src    = 1'b1;
        reg_we     = 1'b0;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
      end

      /* R-type */
      7'b0110011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b1;
        alu_op     = 2'b10;
        branch     = 1'd0;
        jump       = 1'd0;
      end

      /* beq */
      7'b1100011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b0;
        alu_op     = 2'b01;
        branch     = 1'd1;
        jump       = 1'd0;
      end

      /* I-type ALU */
      7'b0010011: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_src    = 1'b1;
        reg_we     = 1'b1;
        alu_op     = 2'b10;
        branch     = 1'd0;
        jump       = 1'd0;
      end

      /* jal */
      7'b1101111: begin
        result_src = 2'b10;
        mem_we     = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b1;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd1;
      end

      default: begin
        result_src = 2'b00;
        mem_we     = 1'b0;
        alu_src    = 1'b0;
        reg_we     = 1'b0;
        alu_op     = 2'b00;
        branch     = 1'd0;
        jump       = 1'd0;
      end
    endcase
  end

endmodule
