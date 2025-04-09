
//Daniel Joel Corona Espinoza
//Yahir Efren Borboa Quintero
module Jericalla_Evolution(
    input [31:0] instruction,
    input CLK,
    output reg [31:0] DS
);

wire cDemux, cWe, cRe, cZf, cBRWe;
wire [3:0] cALU_op;
wire cData_Out;


Controller Control(//Inputs
    .Op(instruction[31:26]), 
    //Ouputs
    .Demuxo(cDemux), 
    .WeMD(cWe), 
    .ReMD(cRe),
    .BRWe(cBRWe),
    .ALU_op(cALU_op)
);
BancRegister Banco( //Inputs
    .RA1(instruction[9:5]), 
    .RA2(instruction[4:0]), 
    .WA(instruction[14:10]),
    .DW(buffer2_D1_Out),
    .WE(B2_BRWe_OUT),
    //Outputs
    .data1Out(buffer1_D1_In), 
    .data2Out(buffer1_D2_In)
);

Demuxo Demux( //Inputs
    .dmx(cDemux),
    .dataIn(buffer1_D1_Out),
    //Outputs 
    .outAlu(cDemuxDataAlu),
    .outMem(cDemuxDataMem)
);
ALU Alulu(
    .A(cDemuxDataAlu),
    .B(buffer1_D2_Out),
    .ALU_ALU_op(cALU_op),
    //Ouputs 
    .R(buffer2_D2_In),
    .Zero_Flag(cZf)
);

MemoryData MemData(
    .WEn(B2_WE_OUT),
    .REn(B2_RE_OUT),
    .dataIn(buffer2_D2_Out),
    .dir(buffer2_DD_Out),
    .dataOut(cData_Out)
);

always @(posedge CLK) begin
    DS <= cData_Out;
end

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

        //agregar tipo j y tipo i


      
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
    input [31:0] dir,
    output reg [31:0] dataOut
);

reg [31:0] mem [0:127];

always @ (*) begin
    if(WEn) begin
        mem[dir] = dataIn;
    end
    if(REn) begin
        dataOut = mem[dir];
    end
end
endmodule

//Alu
module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_ALU_op,
    output reg [31:0] R,
    output reg Zero_Flag
);

always @(*) begin
    case (ALU_ALU_op)
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