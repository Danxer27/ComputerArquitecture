module instrucciones_memoria;
    reg [31:0] memoria [0:0];
    initial begin
        memoria[0] = 32'b00000000010000110011000000101010; // SLT $6, $2, $3
    end
endmodule
