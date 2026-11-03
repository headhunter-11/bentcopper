module dmem(input  logic        clk, we,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);

  logic [31:0] RAM[0:63];

  // 64 words, addressed by byte address (word index = address / 4).
  assign rd = RAM[a[7:2]];

  always_ff @(posedge clk)
    if (we)
      RAM[a[7:2]] <= wd;
endmodule
