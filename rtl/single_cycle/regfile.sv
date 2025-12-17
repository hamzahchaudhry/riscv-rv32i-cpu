module regfile (
    input logic clk,
    input logic reset,
    input logic [4:0] read_reg1,
    input logic [4:0] read_reg2,
    input logic [4:0] write_reg,
    input logic [31:0] write_data,
    input logic regwrite,  /* control signal */

    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

  /* one-hot outputs from decoders */
  logic [31:0] read_reg1_onehot, read_reg2_onehot, write_onehot;

  /* array of 32 32-bit registers */
  logic [31:0] x[31:0];

  /* read 5:32 decoders */
  decoder #(
      .N(5),
      .M(32)
  ) read_decoder1 (
      .a(read_reg1),
      .b(read_reg1_onehot)
  );
  decoder #(
      .N(5),
      .M(32)
  ) read_decoder2 (
      .a(read_reg2),
      .b(read_reg2_onehot)
  );

  /* write 5:32 decoder */
  decoder #(
      .N(5),
      .M(32)
  ) write_decoder (
      .a(write_reg),
      .b(write_onehot)
  );

  /* AND the write decoder outputs with the write enable */
  logic [31:0] write_regs;
  assign write_regs = write_onehot & {32{regwrite}};

  /* instantiate 32 registers with a generate-for loop */
  genvar i;
  generate
    for (i = 0; i < 32; i++) begin : gen_regs
      if (i == 0) begin
        /* x0 is hardwired to zero; ignore writes */
        register #(
            .WIDTH(32)
        ) reg_zero (
            .clk(clk),
            .reset(reset),
            .in(32'b0),
            .load(1'b0),
            .out(x[i])
        );
      end else begin
        register #(
            .WIDTH(32)
        ) reg_i (
            .clk(clk),
            .reset(reset),
            .in(write_data),
            .load(write_regs[i]),
            .out(x[i])
        );
      end
    end
  endgenerate

  /* read mux: use the one-hot read signals to select one of x[i] each */
  always_comb begin
    read_data1 = 'x;
    read_data2 = 'x;
    for (int j = 0; j < 32; j++) begin
      if (read_reg1_onehot[j]) read_data1 = x[j];
      if (read_reg2_onehot[j]) read_data2 = x[j];
    end
  end

endmodule
