
//Daniel Joel Corona Espinoza
//Yahir Efren Borboa Quintero
module DataPath(
    input [31:0] instruction,
    input CLK,
    output [31:0] DS
);

wire cDemux, cWe, cRe, cZf, cBRWe;
wire [3:0] cALU_op;
wire cData_Out;
wire [2:0] C4_Sel;
wire [31:0] C1_RD1, C2_RD2, C3_AluRes, cDW, CS;

Controller Control(//Inputs
    .Op(instruction[31:26]), 
    //Ouputs
    .Demuxo(cDemux), 
    .WeMD(cWe), 
    .ReMD(cRe),
    .BRWe(cBRWe),
    .ALU_op(cALU_op)
);

Alu_Control AluController(
    .funct(instruction[5:0]),
    .ALUop(cALU_op),
    //Output:
    .sel(C4_Sel)
);

BancRegister Banco( //Inputs
    .RA1(instruction[25:21]), 
    .RA2(instruction[20:16]), 
    .WA(instruction[15:11]),
    .DW(cDW),
    .WE(cBRWe),
    //Outputs
    .data1Out(C2_RD2), 
    .data2Out(C1_RD1)
);

ALU Alulu(
    .A(C2_RD2),
    .B(C1_RD1),
    .ALU_op(C4_Sel),
    //Ouputs 
    .R(C3_AluRes),
    .Zero_Flag(cZf)
);

MemoryData MemData(
    .WEn(cWe),
    .REn(cRe),
    .dataIn(C1_RD1),
    .addres(C3_AluRes),
    //Output
    .dataOut(CS)
);

Demuxo Demux(
    .dmx(cDemux),
    .dataAluIn(C3_AluRes),
    .dataMemIn(CS),
    //OutPut:
    .dataOut(cDW)
);
//Falta agregar la salida al DS del CS

// always @(posedge CLK) begin
//     DS <= cData_Out;
// end

endmodule

//Controlador
module Controller(
    input [5:0] Op,
    output reg Demuxo, WeMD, ReMD, BRWe,
    output reg [3:0] ALU_op
);

always @(*) begin
    case (Op)
        6'b100000: begin       
            ALU_op = 4'b0010;
            Demuxo = 1'b0;
            BRWe = 1'b1;   
            WeMD = 1'b0;   
            ReMD = 1'b0;
        end

        6'b100010: begin       
            ALU_op = 4'b0110;
            Demuxo = 1'b0;
            BRWe = 1'b1;   
            WeMD = 1'b0;   
            ReMD = 1'b0;
        end

        6'b100100: begin       
            ALU_op = 4'b0000;
            Demuxo = 1'b0;
            BRWe = 1'b1;   
            WeMD = 1'b0;   
            ReMD = 1'b0;
        end

        6'b100101: begin       
            ALU_op = 4'b0001;
            Demuxo = 1'b0;
            BRWe = 1'b1;   
            WeMD = 1'b0;   
            ReMD = 1'b0;
        end

        6'b101010: begin       
            ALU_op = 4'b0111;
            Demuxo = 1'b0;
            BRWe = 1'b1;   
            WeMD = 1'b0;   
            ReMD = 1'b0;
        end

        //Aqui van tipo I y J cuando se necesitan
    endcase
end
endmodule

//### ALU CONTROL
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

//Banco de Registros
module BancRegister( 
    input [4:0] RA1, RA2, WA,
    input [31:0] DW,
    input WE,
    output reg [31:0] data1Out, data2Out
);

reg [31:0] mem [0:31];

initial begin
    $readmemb("data", mem);
end

always @ * begin
    if(WE) begin
        mem[WA] = DW;
    end
    data1Out = mem[RA1];
    data2Out = mem[RA2];
end
endmodule

//Demultiplexor Mem / Alu => Registers
module Demuxo(
    input dmx,
    input [31:0] dataAluIn, dataMemIn,
    output reg [31:0] dataOut //outAlu, outMem    
);

always @(*) begin
    case (dmx)
        1'b0: dataOut = dataMemIn;               
        1'b1: dataOut = dataAluIn;        
    endcase
end
endmodule

//Memoria de Datos
module MemoryData(
    input WEn, REn,
    input [31:0] dataIn, 
    input [31:0] addres,
    output reg [31:0] dataOut
);

reg [31:0] mem [0:127];

always @ (*) begin
    if(WEn) begin
        mem[addres] = dataIn;
    end
    if(REn) begin
        dataOut = mem[addres];
    end
end
endmodule

//Alu
module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_op,
    output reg [31:0] R,
    output reg Zero_Flag
);

always @(*) begin
    case (ALU_op)
        4'b0000: R = A & B;        
        4'b0001: R = A | B;        
        4'b0010: R = A + B;       
        4'b0110: R = A - B;        
        4'b0111: R = (A < B) ? 32'd1 : 32'd0;
        4'b1100: R = ~(A | B);        
        default: R = A;      
    endcase
    
    Zero_Flag = (R == 32'd0) ? 1'b1 : 1'b0;
end

endmodule