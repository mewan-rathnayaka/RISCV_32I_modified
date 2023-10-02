//
// Design unit  : Internal registry testbench
//              :
// File name    : registry_tb.sv
//              :
// Module name  : Registry_tb
//              :
// Description  : Internal registry testbench for RISC 32I processor
//              : 32 * 32 bit
//

module Registry_tb;
    timeunit 10ns ; timeprecision 1ns;
    localparam WIDTH = 32,
               DEPTH = 32;

    logic clk, write_en;
    logic [$clog2(DEPTH) -1:0] rs1;
    logic [$clog2(DEPTH) -1:0] rs2;
    logic [$clog2(DEPTH) -1:0] rd; 
    logic [WIDTH - 1 : 0] write_data;
    logic [WIDTH - 1 : 0] data_1, data_2;

    Registry dut(.*);

    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    initial begin
        {clk, write_en, rs1, rs2, rd, write_data} = 0;
        //Concatanate an instruction and read the data outputs
        //rs1 = 2, rs2 = 3, rd = 0
        @(posedge clk) #1
        rs1 = 5'd2; rs2 = 5'd3; 
        #(PERIOD)
        $display("data_1 = %d", data_1);
        $display("data_2 = %d", data_2);
        
        
        //Concatanate and instrution and write a data value in
        //then again check the data output
        @(posedge clk) #1
        //rs1 = 2, rs2 = 3, rd = 2
        //instr = 32'h00310100;
        rs1 = 5'd2; rs2 = 5'd3; rd =5'd2;
        write_en = 1;
        write_data = 4;
        #(PERIOD)
        $display("data_1 = %d", data_1);
        $display("data_2 = %d", data_2);
        #(PERIOD*2)
        $finish();
    end



    
endmodule