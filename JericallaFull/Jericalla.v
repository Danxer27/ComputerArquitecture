
module Jericalla(
    input [16:0] instruction,
    output [31:0] DS,
    output zf
);

wire [31:0] c1,c2,c3,c4;

ROM romu(.dir1(instruction[4:1]), .dir2(instruction[8:5]), .data1Out(c1), .data2Out(c2));
ALU alx(.A(c1), .B(c2), .ALU_Sel(instruction[12:9]), .R(c3), .Zero_Flag(zf));
RAM ramu(.WEn(instruction[0]), .dataIn(c3), .dir(instruction[16:13]), .dataOut(DS));

endmodule

module ROM( 
    input [3:0] dir1, dir2,
    output reg [31:0] data1Out, data2Out
);

initial begin
    $readmemb("data", mem);
end

reg [31:0] mem [0:15];

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

reg [31:0] mem [0:15];

always @ * begin
    if(WEn) begin
        mem[dir] = dataIn;
    end
    begin
        dataOut = mem[dir];
    end
end
endmodule

module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_Sel,
    output reg [31:0] R,
    output reg Zero_Flag
);

    always @(*) begin
        case (ALU_Sel)
            4'b0000: R = A & B;        
            4'b0001: R = A | B;        
            4'b0010: R = A + B;       
            4'b0110: R = A - B;        
            4'b0111: R = (A < B) ? 32'd1 : 32'd0;
            4'b1100: R = ~(A | B);        

            default: R = 32'd0;      
        endcase
        
        Zero_Flag = (R == 32'd0) ? 1'b1 : 1'b0;
    end
    
endmodule