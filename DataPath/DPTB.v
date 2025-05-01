`timescale 1ns/1ps

module DataPathTB;

    reg [31:0] instruccion;
    reg Clk;
    wire [31:0] dataOut;

    DataPath DP(
        .instruction(instruccion),
        .CLK(Clk),
        .DS(dataOut)
    );

    always #5 Clk = ~Clk;

    initial begin
        Clk = 0;
        #20;
        instruccion = 32'b00000001111010011010000000100010;
        #20;
        instruccion = 32'b00000000000000000000000000000000; //NOP
        #20;
        instruccion = 32'b00000010100010011010000000100010;
        #20;
        instruccion = 32'b00000000000000000000000000000000; //NOP
        #20;
        instruccion = 32'b00000000101011110111100000100000;
        #20;
        instruccion = 32'b00000000000000000000000000000000; //NOP
        #20;
        instruccion = 32'b00000001001011110111100000100000;
        #20;
        instruccion = 32'b00000000000000000000000000000000; //NOP
        #20;
        instruccion = 32'b00000010100011111010100000101010;
        #20;
        instruccion = 32'b00000000000000000000000000000000; //NOP
        #20;
        $stop;
    end

endmodule
