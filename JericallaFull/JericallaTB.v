`timescale 1ns/1ns
module JericTB();

reg [16:0] TBin;
wire [31:0] resOutput;
wire ZFtb;

Jericalla JericTB(.instruction(TBin), .DS(resOutput), .zf(ZFtb));

initial begin
    TBin = 17'b00110010010001101;
    #100;
    TBin = 17'b00110000010001101;
    #100;
    TBin = 17'b00110001010001101;
    #100;
    TBin = 17'b00110110010001101;
    #100;
    TBin = 17'b00110111010001101;
    #100;
    TBin = 17'b0011100010001101;
    #100;
end

endmodule