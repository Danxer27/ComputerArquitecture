

module FetchCicle(
    input [31:0] instruction,
    input CLK,
    output insOut
);

wire clock;
wire [31:0] pcIn, pcOut, sumOut;

PC pc(.clk(CLK), .dirIn(sumOut), .dirOut(pcOut));
Alud sum(.dir(pcOut), .dirOut(sumOut));
Memory mem(.dir(pcOut), .dataOut(insOut));

endmodule


//Direccionaor
module PC (
    input clk,
    input [31:0] dirIn,
    output reg [31:0] dirOut
);
initial begin
    dirOut = 32'b0;
end
always @(posedge clk) begin
    dirOut <= dirIn;
end
endmodule

module Alud(
    input [31:0] dir,
    output reg [31:0] dirOut 
);

always @(*) begin
    dirOut = dir + 4;
end
endmodule

//Memoria
module Memory(
    input [31:0] dir,
    output reg [31:0] dataOut
);

reg [7:0] mem [0:1023];

initial begin
    $readmemb("data", mem);
end

always @ (*) begin
    dataOut = mem[dir];
end
endmodule