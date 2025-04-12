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
        instruccion = 32'b00000000000000010010000000100000;
        #20;
        instruccion = 32'b00000000001000100010100000100010;
        #20;
        instruccion = 32'b00000000010000110011000000101010;
        #20;
        $stop;
    end

endmodule
