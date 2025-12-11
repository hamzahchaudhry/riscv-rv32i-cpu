/* types */
`define ITYPE 7'b0010011
`define ITYPE_LOAD 7'b0000011
`define ITYPE_JALR 7'b1100111
`define STYPE 7'b0100011
`define BTYPE 7'b1100011
`define JTYPE 7'b1101111
`define UTYPE 7'b0110111
`define UTYPE_AUIPC 7'b0010111

module imm_gen (
    input logic [31:0] instruction,

    output logic [31:0] imm_out
);

  always_comb begin
    unique case (instruction[6:0])
      /* I-type */
      `ITYPE, `ITYPE_LOAD, `ITYPE_JALR: begin
        imm_out = {
          {20{instruction[31]}},  /* sign extension */
          instruction[31:20]  /* imm[11:0] */
        };
      end

      /* S-type */
      `STYPE: begin
        imm_out = {
          {20{instruction[31]}},  /* sign extension */
          instruction[31:25],  /* imm[11:5] */
          instruction[11:7]  /* imm[4:0] */
        };
      end

      /* B-type */
      `BTYPE: begin
        imm_out = {
          {19{instruction[31]}},  /* sign extension */
          instruction[31],  /* imm[12] */
          instruction[7],  /* imm[11] */
          instruction[30:25],  /* imm[10:5] */
          instruction[11:8],  /* imm[4:1] */
          1'b0  /* imm[0] = 0 */
        };
      end

      /* J-type */
      `JTYPE: begin
        imm_out = {
          {11{instruction[31]}},  /* sign extension */
          instruction[31],  /* imm[20] */
          instruction[19:12],  /* imm[19:12] */
          instruction[20],  /* imm[11] */
          instruction[30:21],  /* imm[10:1] */
          1'b0  /* imm[0] = 0 */
        };
      end

      /* U-type */
      `UTYPE, `UTYPE_AUIPC: begin
        imm_out = {
          instruction[31:12],  /* imm[31:12] */
          12'b0  /* shifted left by 12 bits */
        };
      end

      default: imm_out = 'x;
    endcase
  end

endmodule
