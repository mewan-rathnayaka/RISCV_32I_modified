//
// Design unit  : Controller
//              :
// File name    : controller.sv
//              :
// Module name  : Controller
//              :
// Description  : Microcontroller type controller for RISC 32I processor
//              : Start from version2
//
// Version      : 4.0 Adding LS_extender
//

//Inputs    : instr                 | 32 bit instruction 
//          : zero                  | From branching
//          : reset                 | hard reset (asynchronous)
//          : clk                   | clock signal

//Outputs   : imm_src               | To extender
//          : reg_write_en          | To register write
//          : data_write_en         | To data write
//          : alu_src_1             | Mux choosing for src_a
//          : alu_src_2             | Mux choosing for src_b
//          : result_src            | Mux choosing the write_reg source
//          : pc_src                | Mux choosing the bnext pc source 
//          : alu_control           | Control signals for ALU
//          : ls_src                | Control signals for LS_extender
//      

module Controller #(parameter WIDTH = 32) (
    input logic clk, rst, zero, 
    input logic [WIDTH - 1 : 0] instr,
    output logic alu_src_2, alu_src_1, data_write_en, reg_write_en,
    output logic [1:0] pc_src, result_src, imm_src,
    output logic [2:0] ls_src,
    output logic [3:0] alu_control
    
);
    //Initating a ROM with appropriate depth 47 instructions
    logic [16:0] store [0 : 47];

    //           |   31:25       |  24:20   |  19:15  | 14:12      |  11:7     |  6:0
    //Size       |      7        |    5     |   5     |    3       |    5      |    7
    //R type     |   funct7      |  rs2     |  rs1    | funct3     |  rd       |  opcode
    //Setting the order of instructions
    logic [$clog2(47) - 1:0] index;
    //Retriving data from ROM

    //Setting index for instructions
    always_ff @(posedge clk) begin
        casex ({instr[31:25], instr[14:12], instr[6:0]})

            17'bxxxxxxx_xxx_0110111 : index = 6'd0;        //LUI
            17'bxxxxxxx_xxx_0010111 : index = 6'd1;        //AUIPC
            //!17'bxxxxxxx_xxx_1101111 : index = 6'd2;        //JAL
            17'bxxxxxxx_000_1100111 : index = 6'd3;        //JALR

            //To do the branching
            17'bxxxxxxx_000_1100011 : begin
                index = (zero) ? 6'd4 : 6'd39;              //BEQ
            end 
            17'bxxxxxxx_001_1100011 : begin
                index = (zero) ? 6'd5 : 6'd40;              //BNE
            end 
            17'bxxxxxxx_100_1100011 : begin
                index = (zero) ? 6'd6 : 6'd41;              //BLT
            end 
            17'bxxxxxxx_101_1100011 : begin
                index = (zero) ? 6'd7 : 6'd42;              //BGE
            end 
            17'bxxxxxxx_110_1100011 : begin
                index = (zero) ? 6'd8 : 6'd43;              //BLTU
            end 
            17'bxxxxxxx_111_1100011 : begin
                index = (zero) ? 6'd9 : 6'd44;              //BGEU
            end 

            17'bxxxxxxx_000_0000011 : index = 6'd10;        //LB
            17'bxxxxxxx_001_0000011 : index = 6'd11;        //LH
            17'bxxxxxxx_010_0000011 : index = 6'd12;        //LW
            17'bxxxxxxx_100_0000011 : index = 6'd13;        //LBU
            17'bxxxxxxx_101_0000011 : index = 6'd14;        //LHU
            17'bxxxxxxx_000_0100011 : index = 6'd15;        //SB
            17'bxxxxxxx_001_0100011 : index = 6'd16;        //SH
            17'bxxxxxxx_010_0100011 : index = 6'd17;        //SW

            17'bxxxxxxx_000_0010011 : index = 6'd18;        //ADDI
            17'bxxxxxxx_010_0010011 : index = 6'd19;        //SLTI
            17'bxxxxxxx_011_0010011 : index = 6'd20;        //SLTIU
            17'bxxxxxxx_100_0010011 : index = 6'd21;        //XORI
            17'bxxxxxxx_110_0010011 : index = 6'd22;        //ORI
            17'bxxxxxxx_111_0010011 : index = 6'd23;        //ANDI

            17'b000000x_001_0010011 : index = 6'd24;        //SLLI
            17'b000000x_101_0010011 : index = 6'd25;        //SRLI
            17'b010000x_101_0010011 : index = 6'd26;        //SRAI

            17'b0000000_000_0110011 : index = 6'd27;        //ADD
            17'b0100000_000_0110011 : index = 6'd28;        //SUB
            17'b0000000_001_0110011 : index = 6'd29;        //SLL
            17'b0000000_010_0110011 : index = 6'd30;        //SLT
            17'b0000000_011_0110011 : index = 6'd31;        //SLTU
            17'b0000000_100_0110011 : index = 6'd32;        //XOR
            17'b0000000_101_0110011 : index = 6'd33;        //SRL
            17'b0100000_101_0110011 : index = 6'd34;        //SRA
            17'b0000000_110_0110011 : index = 6'd35;        //OR
            17'b0000000_111_0110011 : index = 6'd36;        //AND

            //! Need to add UMUL and array copy

            17'b0000001_000_0110011 : index = 6'd37;        //UMUL   

        default: index = {6{1'bx}};
        endcase
    end

    //Setting output signals
    //Control signal format
    //  15:14  |      13      |     12    |     11    |      10:7     |      6        |     5:4    |  3:2   |  1:0
    //  ls_src | reg_write_en | alu_src_1 | alu_src_2 |  alu_control  | data_write_en | result_src | pc_src |imm_src

    always_ff @(posedge clk) begin
        ls_src          <= store[index][15:14];   
        reg_write_en    <= store[index][13];
        alu_src_1       <= store[index][12];
        alu_src_2       <= store[index][11];
        alu_control     <= store[index][10:7];
        data_write_en   <= store[index][6];
        result_src      <= store[index][5:4];
        pc_src          <= store[index][3:2];
        imm_src         <= store[index][1:0];  
    end
    
    //Setting control signals

    
    assign store[0] = 17'b000_100_0010_011_00_11;                  //LUI 
    assign store[1] = 17'b000_111_0010_000_00_11;                  //AUIPC
    //!assign store[2] = 13'b1x_xxxx_0101_100;                 //JAL
    //*Control transfer - I type
    assign store[3]  = 17'b000_110_0010_010_10_00;                  //JALR

    //*SB type
    assign store[4]  = 17'b000_000_0110_0xx_01_10;                 //BEQ
    assign store[5]  = 17'b000_000_0111_0xx_01_10;                 //BNE
    assign store[6]  = 17'b000_000_0100_0xx_01_10;                 //BLT
    assign store[7]  = 17'b000_000_0101_0xx_01_10;                 //BGE
    assign store[8]  = 17'b000_000_1100_0xx_01_10;                 //BLTU
    assign store[9]  = 17'b000_000_1101_0xx_01_10;                 //BGEU

    //*S type
    assign store[10] = 17'b011_110_0010_001_00_00;                  //LB
    assign store[11] = 17'b001_110_0010_001_00_00;                  //LH
    assign store[12] = 17'b000_110_0010_001_00_00;                  //LW  
    assign store[13] = 17'b100_110_0010_001_00_00;                  //LBU
    assign store[14] = 17'b011_110_0010_001_00_00;                  //LHU
    assign store[15] = 17'b011_010_0010_1xx_00_01;                  //SB
    assign store[16] = 17'b001_010_0010_1xx_00_01;                  //SH
    assign store[17] = 17'b000_010_0010_1xx_00_01;                  //SW  


    //*I type
    assign store[18] = 17'b000_110_0010_000_00_00;                  //ADDI
    assign store[19] = 17'b000_110_1000_000_00_00;                  //SLLI
    assign store[20] = 17'b000_110_1111_000_00_00;                  //SLTI
    assign store[21] = 17'b000_110_1110_000_00_00;                  //SLTIU
    assign store[22] = 17'b000_110_0011_000_00_00;                  //XORI
    assign store[23] = 17'b000_110_1001_000_00_00;                  //SRLI
    assign store[24] = 17'b000_110_1011_000_00_00;                  //SRAI
    assign store[25] = 17'b000_110_0001_000_00_00;                  //ORI
    assign store[26] = 17'b000_110_0000_000_00_00;                  //ANDI


    //*R type
    assign store[27] = 17'b000_100_0010_000_00_xx;                  //ADD
    assign store[28] = 17'b000_100_0110_000_00_xx;                  //SUB
    assign store[29] = 17'b000_100_1000_000_00_xx;                  //SLL
    assign store[30] = 17'b000_100_1111_000_00_xx;                  //SLT
    assign store[31] = 17'b000_100_1110_000_00_xx;                  //SLTU
    assign store[32] = 17'b000_100_0011_000_00_xx;                  //XOR
    assign store[33] = 17'b000_100_1001_000_00_xx;                  //SRL
    assign store[34] = 17'b000_100_1011_000_00_xx;                  //SRA
    assign store[35] = 17'b000_100_0001_000_00_xx;                  //OR
    assign store[36] = 17'b000_100_0000_000_00_xx;                  //AND

    //*New
    assign store[37] = 17'b000_100_1010_000_00_xx;                  //UMUL


    //*SB type - condition not satisfied
    assign store[39]  = 17'b000_000_0110_0xx_00_10;                 //BEQ
    assign store[40]  = 17'b000_000_0111_0xx_00_10;                 //BNE
    assign store[41]  = 17'b000_000_0100_0xx_00_10;                 //BLT
    assign store[42]  = 17'b000_000_0101_0xx_00_10;                 //BGE
    assign store[43]  = 17'b000_000_1100_0xx_00_10;                 //BLTU
    assign store[44]  = 17'b000_000_1101_0xx_00_10;                 //BGEU


    
endmodule