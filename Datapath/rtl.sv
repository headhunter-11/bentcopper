module datapath(input  logic        clk, reset,
                input  logic [1:0]  ResultSrc,
                input  logic        PCSrc, ALUSrc,
                input  logic        RegWrite,
                input  logic [1:0]  ImmSrc,
                input  logic [2:0]  ALUControl,
                output logic        Zero,
                output logic [31:0] PC,
                input  logic [31:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input  logic [31:0] ReadData);

  logic [31:0] PCNext, PCPlus4, PCTarget;
  logic [31:0] ImmExt, ImmExtShifted;
  logic [31:0] SrcA, SrcB;
  logic [31:0] Result;

  // PC update and PC-relative branch/jump target.
  flopr #(32) pcreg(.d(PCNext), .clk(clk), .reset(reset), .q(PC));
  adder       pcadd4(PC, 32'd4, PCPlus4);
  extend      ext(Instr[31:7], ImmSrc, ImmExt);
  assign ImmExtShifted = ImmExt << 1;
  adder       pcaddbranch(PC, ImmExtShifted, PCTarget);
  mux2 #(32)  pcmux(PCPlus4, PCTarget, PCSrc, PCNext);

  // Register file and operand selection.
  regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],
             Instr[11:7], Result, SrcA, WriteData);
  mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);

  // ALU and write-back selection.
  alu        alu_unit(SrcA, SrcB, ALUControl, ALUResult);
  assign Zero = (ALUResult == 32'b0);
  mux3 #(32) resultmux(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
endmodule
