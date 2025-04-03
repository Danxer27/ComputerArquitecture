

module FetchCicle(
    input [31:0] instruction,
    input CLK,
    output [31:0] insOut
);

wire clock;
wire [31:0] pcIn, pcOut, sumOut;

PC pc(.clk(CLK), .dirIn(sumOut), .dirOut(pcOut));
Alud sum(.dir(pcOut), .dirOut(sumOut));
Memory mem(.dir(pcOut), .instructionOut(insOut));

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

//Sumador de direcciones
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
    output reg [31:0] instructionOut
);

reg [7:0] mem [0:1023];

initial begin
    $readmemb("data", mem);
end

always @ (*) begin
    instructionOut = {mem[dir], mem[dir+1], mem[dir+2], mem[dir+3]};
end


endmodule