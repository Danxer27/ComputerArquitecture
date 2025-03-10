//Daniel Joel Corona Espinoza
module Jericalla(
    input op, 
    input [3:0] dirRes, dirFirst, dirSec,
    output reg [31:0] DS
);

ROM romu(.dir1(dirFirst), .dir2(dirSec));

endmodule

module ROM( 
    input [3:0] dir1, dir2,
    output reg [31:0] data1Out, data2Out
);

initial begin
    $readmemb("datos", mem);
end

reg [3:0] mem [0:15];

always @ * begin
    begin
        data1Out = mem[dir1];
        data2Out = mem[dir2];
    end
end
endmodule


module RAM(
    input WEn, //Write Enable ~ Read enable
    input [31:0] dataIn, 
    input [3:0] dir,
    output reg [31:0] dataOut
);

reg [3:0] mem [0:15];

always @ * begin
    if(WEn) begin
        mem[dir] = dataIn;
    end
    else begin
        dataOut = mem[dir];
    end
end
endmodule

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [2:0] ALU_Sel,
    output reg [31:0] R,
    output reg Zero_Flag
);

    always @(*) begin
        case (ALU_Sel)
            3'b000: R = A + B;        
            3'b001: R = A - B;        
            3'b010: R = A & B;       
            3'b011: R = A | B;        
            3'b100: R = (A < B) ? 32'd1 : 32'd0; 
            default: R = 32'd0;      
        endcase
        
        Zero_Flag = (R == 32'd0) ? 1'b1 : 1'b0;
    end
    
endmodule