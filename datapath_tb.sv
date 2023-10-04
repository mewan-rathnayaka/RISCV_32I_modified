//
// Design unit  : Datapath testbench
//              :
// File name    : datapath_tb.sv
//              :
// Module name  : Datapath_tb
//              :
// Description  : Testbench for the checking of datapath in the processor 
//
// Version      : 4.0 Completing instructions running
//              : Multi_cycle
//

module Datapath_tb; 
    localparam WIDTH = 32;

    logic clk, rst;
    logic alu_src_2, alu_src_1, reg_write_en, pc_en;
    logic [1:0] result_src, pc_src, imm_src;
    logic [2:0] ls_src;
    logic [3:0] alu_control;
    logic zero;
    logic [WIDTH - 1 : 7] instr;
    logic [WIDTH - 1 : 0] data_in;
    logic [WIDTH - 1 : 0] pc_out, alu_out, write_data_mod;
    
    Datapath dut(.*);
    
    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk; 
    end

    initial begin
        {clk, rst, pc_src,alu_src_1, alu_src_2, result_src, reg_write_en, ls_src,
         imm_src, alu_control, instr, data_in, pc_en} = 0;
        //Since ls_src will not be used other than type S, it will be not be written explicitly
        //in other places 

        rst = 1;
        #(PERIOD)
        rst <= 0; pc_en <= 1;
        
        //*I type -Load

        //LUI x[23] = sext(562 << 12)
        @(posedge clk)
        #1
        instr <= 25'h4657; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b11; reg_write_en <= 1;
        imm_src <= 2'b11; alu_control <= 4'b0010; alu_src_1 <= 0;

        //Using ADDI to check rd[0] = rs[23] + 0
        @(posedge clk)
        #1
        instr <= 25'h1700; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010; data_in <= 32'h0; 
        #5 
        $display("alu_out = %b",alu_out);
        

        //AUIPC x[24] = pc + sext(562 << 12)
        @(posedge clk)
        #1
        instr <= 25'h4658; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0; reg_write_en <= 1;
        imm_src <= 2'b11; alu_control <= 4'b0010; alu_src_1 <= 1;

        //Using ADDI to check rd[0] = rs[24] + 0
        @(posedge clk)
        #1
        instr <= 25'h1800; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010; data_in <= 32'h0; alu_src_1 <= 0;

        //Reseting r0 using ADDI r0 = r9 + 0
        @(posedge clk)
        #1
        instr <= 25'h900; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010; data_in <= 32'h0; alu_src_1 <= 0;


        @(posedge clk)
        alu_src_1 <= 0;
        #(PERIOD)

        //*Control T- I type instructions
        //JALR  x[12]=pc+4; pc=(x[8]]+sext(16)) 
        @(posedge clk)
        #1
        instr <= 25'h1080C; pc_src <= 2'b10; alu_src_2 <= 1; result_src <= 2'b10; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010;

        //Using ADDI to check rd[0] = rs[12] + 0
        @(posedge clk)
        #1
        instr <= 25'hC00; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010;

        
        @(posedge clk)
        #(PERIOD)
    

        //*SB type instructions
        //BEQ r3 == r4? pc += {8,0} (becaouse SLL 1)
        @(posedge clk)
        #1
        instr <= 25'h8308; pc_src <= 2'b1; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b10; alu_control <= 4'b0010;

        //BNE r3 == r4? pc += {8,0} (becaouse SLL 1)
        @(posedge clk)
        #1
        instr <= 25'h8328; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b10; alu_control <= 4'b0111;

        @(posedge clk)
        pc_src <= 2'b0;

        #(PERIOD)

        //*S type instructions
        //LW r11 = M[r4+12]
        @(posedge clk)
        #1
        instr <= 25'h01844B; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010; data_in <= 32'h778B5;
        
        //sw M[r2 + 16] = r11
        @(posedge clk)
        #1
        instr <= 25'h16250; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0; reg_write_en <= 0;
        imm_src <= 2'b1; alu_control <= 4'b0010;

        //LH r17 =sext(M[x[1] + sext(16)][15:0])
        @(posedge clk)
        #1
        instr <= 25'h20131; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010; data_in <= 32'h9BDFC000; ls_src <= 1;

        //SH M[x[3] + sext(21)] = x[r15][15:0]
        @(posedge clk)
        #1
        instr <= 25'h1E335; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0; reg_write_en <= 0;
        imm_src <= 2'b1; alu_control <= 4'b0010; data_in <= 32'h0; ls_src <= 3'b10;
        

        //LHU x[r18] = M[x[r1] + sext(16)][15:0]
        @(posedge clk)
        #1
        instr <= 25'h201B2; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010; data_in <= 32'h809BDFC0; ls_src <= 3'b11;
        

        //Using ADDI to check rd[0] = rs[18] + 0
        @(posedge clk)
        #1
        instr <= 25'h1200; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010; data_in <= 32'h0; ls_src <= 0;

        //LBU x[19] = M[x[r4] + sext(21)][7:0]
        @(posedge clk)
        #1
        instr <= 25'h2A493; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b1; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010; data_in <= 32'h809BDF40; ls_src <= 3'b100;
        

        //Using ADDI to check rd[0] = rs[18] + 0
        @(posedge clk)
        #1
        instr <= 25'h1300; pc_src <= 2'b00; alu_src_2 <= 1; result_src <= 2'b00; reg_write_en <= 1;
        imm_src <= 2'b00; alu_control <= 4'b0010; data_in <= 32'h0; ls_src <= 0;




        @(posedge clk)
        ls_src <= 3'b0; data_in <= 0;
        #(PERIOD)

        //*I type instructions
        //addi r4 = r1 + 20
        @(posedge clk)
        #1
        instr <= 25'h28104; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010;

        //slli r5 = r4 << 3
        @(posedge clk)
        #1
        instr <= 25'h36425; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b1000;

        //srai r9 = r5 >> 4
        @(posedge clk)
        #1
        instr <= 25'h85A9; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b1011;

        //addi r10 = r9 + 20
        @(posedge clk)
        #1
        instr <= 25'h2890A; pc_src <= 2'b0; alu_src_2 <= 1; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'b0; alu_control <= 4'b0010;

        #(PERIOD)

        //*R type instructions
        //add r3 = r1 + r2
        @(posedge clk)
        #1
        instr <= 25'h4103; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'bx; alu_control <= 4'b0010;

        //sub r6 = r5 - r1
        @(posedge clk)
        #1
        instr <= 25'h802506; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'bx; alu_control <= 4'b0110;
    
        //SLT r8, r6 < r2
        @(posedge clk)
        #1
        instr <= 25'h4648; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'bx; alu_control <= 4'b1111;
        
        //or r1 = r8 | r0
        @(posedge clk)
        #1
        instr <= 25'h8C1; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'bx; alu_control <= 4'b0001;

        //SLTU r8, r6 < r2 
        @(posedge clk)
        #1
        instr <= 25'h4648; pc_src <= 2'b0; alu_src_2 <= 0; result_src <= 2'b0 ; reg_write_en <= 1;
        imm_src <= 2'bx; alu_control <= 4'b1110;
        


        #(PERIOD*2)
        $finish();
    end  


    
endmodule