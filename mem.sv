//
// Design unit  : Memory
//              :
// File name    : Mem.sv
//              :
// Module name  : Mem
//              :
// Description  : Memory for RISC 32I processor 64 * 32 bit
//              : to be used in instruction and data seperately
//              : With reset added, read_en removed
//
// Version      : 3.0 (Change to byte addressable memory)
//


//  32 * 64 = 8 * 246
module Mem #(parameter WIDTH = 32, DEPTH = 256) (
    input logic clk, write_en, rst,
    input logic [WIDTH - 1: 0] addr,
    input logic [WIDTH - 1: 0] write_data,    
    output logic [WIDTH - 1: 0] data  
);
    //Byte addressable memory 
    //256 byte space
    logic [8 -1 : 0] mem [0 : DEPTH - 1];

    //Writing numbers from 0 to 7 in first 8 doublewords
    initial begin
        $readmemh("mem.dat",mem);
    end

    //Reading data is combinational
    // WIll always return a double word
    //Little endian ordering
    always_comb begin
        data = {mem[addr+3],
                mem[addr+2],
                mem[addr+1],
                mem[addr]};
    end

    //Writing data is sequential
    integer i;
    always_ff @(posedge clk) begin     
        if (write_en) begin
            mem[addr]   <= write_data[7:0];
            mem[addr+1] <= write_data[15:8];
            mem[addr+2] <= write_data[23:16];
            mem[addr+3] <= write_data[31:24];
        end
        //Reset
        if (rst) 
        begin
          for (i=0; i< DEPTH; i++) mem[i] <= 8'd0;
        end
    end    
endmodule