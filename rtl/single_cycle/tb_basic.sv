`timescale 1ns / 1ps

module tb_basic;
  logic clk = 0;
  logic reset = 1;

  top_level dut (
      .clk  (clk),
      .reset(reset)
  );

  /* clock generator */
  always #5 clk = ~clk;

  initial begin
    /* release reset after a couple of cycles */
    repeat (2) @(posedge clk);
    reset <= 0;

    /* run enough cycles for lw/lw/add/sw and then sit in the beq loop */
    repeat (12) @(posedge clk);

    $display("mem[0]=0x%08h mem[1]=0x%08h mem[2]=0x%08h", dut.datapath.data_memory.mem[0],
             dut.datapath.data_memory.mem[1], dut.datapath.data_memory.mem[2]);

    if (dut.datapath.data_memory.mem[2] === 32'd12) begin
      $display("PASS: stored sum 12 at mem[2]");
    end else begin
      $display("FAIL: expected mem[2]=12");
      $fatal;
    end

    $finish;
  end

endmodule
