module regfile(input  logic        clk,
               input  logic        we3,
               input  logic [4:0]  a1, a2, a3,
               input  logic [31:0] wd3,
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[31:0];

  // x0 is hardwired to zero and must never be written.
  always_ff @(posedge clk)
    if (we3 && (a3 != 5'd0))
      rf[a3] <= wd3;

  // Asynchronous reads; x0 always returns zero.
  assign rd1 = (a1 == 5'd0) ? 32'b0 : rf[a1];
  assign rd2 = (a2 == 5'd0) ? 32'b0 : rf[a2];
endmodule
