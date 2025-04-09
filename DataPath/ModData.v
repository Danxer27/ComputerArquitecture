module Alu_Control(
    input [5:0] funct,
    input [1:0] ALUop,
    output reg [2:0] sel
);

always @(*) begin
    case (ALUop)
        2'b00:
            sel = 4'b0010;
        2'b01:
            sel = 4'b0110;
        2'b10:
            case (funct)
            5'b10000: sel = 4'b0010;
            5'b10010: sel = 4'b0110;
            5'b10100: sel = 4'b0000;
            5'b10101: sel = 4'b0001;
            5'b10101: sel = 4'b0111;
            endcase
    endcase
end
endmodule