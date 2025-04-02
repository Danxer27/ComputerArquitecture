`timescale 1ns/1ps

module FetcTB;

    reg [16:0] instruccion;
    reg Clk;
    wire [31:0] dataOut;

    FetchCicle FetchCic(
        .instruction(instruccion),
        .CLK(Clk),
        .insOut(dataOut)
    );

    always #5 Clk = ~Clk;

    initial begin
        Clk = 0;
        #20;
        #20;
        #20;
        #20;
        $stop;
    end

endmodule
