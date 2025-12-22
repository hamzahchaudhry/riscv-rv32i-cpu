module imm_gen (
    input  logic [31:0] instr,
    output logic [31:0] imm_out
);

  always_comb begin
    unique case (instr[6:0])

      /* I-type: OP-IMM, LOAD, JALR */
      7'b0010011, 7'b0000011, 7'b1100111: begin
        imm_out = {
          {20{instr[31]}},  /* sign extension */
          instr[31:20]  /* imm[11:0] */
        };
      end

      /* S-type: STORE */
      7'b0100011: begin
        imm_out = {
          {20{instr[31]}},  /* sign extension */
          instr[31:25],  /* imm[11:5] */
          instr[11:7]  /* imm[4:0] */
        };
      end

      /* B-type: BRANCH */
      7'b1100011: begin
        imm_out = {
          {19{instr[31]}},  /* sign extension */
          instr[31],  /* imm[12] */
          instr[7],  /* imm[11] */
          instr[30:25],  /* imm[10:5] */
          instr[11:8],  /* imm[4:1] */
          1'b0  /* imm[0] = 0 */
        };
      end

      /* U-type: LUI, AUIPC */
      7'b0110111, 7'b0010111: begin
        imm_out = {
          instr[31:12],  /* imm[31:12] */
          12'b0  /* shifted left by 12 bits */
        };
      end

      /* J-type: JAL */
      7'b1101111: begin
        imm_out = {
          {11{instr[31]}},  /* sign extension */
          instr[31],  /* imm[20] */
          instr[19:12],  /* imm[19:12] */
          instr[20],  /* imm[11] */
          instr[30:21],  /* imm[10:1] */
          1'b0  /* imm[0] = 0 */
        };
      end

      default: imm_out = 32'd0;
    endcase
  end

endmodule
