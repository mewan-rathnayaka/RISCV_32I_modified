//
// Design unit  : Load Store extender testbench
//              :
// File name    : ls_extender_tb.sv
//              :
// Module name  : LS_extender_tb
//              :
// Description  : Testbench for LS_extender
//
// Version      : 4.0 
//

module LS_extender_tb;
    localparam WIDTH = 32;

    logic [2:0] selector;
    logic [WIDTH - 1 : 0] load_in, load_out, store_in, store_out;

    LS_extender dut(.*);

    initial begin
        {selector, load_in, store_in} = 0;
        //LW, SW
        #10 selector <= 3'd0; load_in <= 32'haaaa_aaaa; store_in <= 32'hbbbb_bbbb;
        #10
        //default
        #10 selector <= 3'd5; load_in <= 32'haaaa_aaaa; store_in <= 32'hbbbb_bbbb;
        #10

        //LH, SH
        #10 selector <= 3'd1; load_in <= 32'h9BDF_C000; store_in <= 32'h9BDF_C000;
        #10
        #10 selector <= 3'd1; load_in <= 32'h9BDF_4000; store_in <= 32'h9BDF_4000;
        #10

        //LHU, SW
        #10 selector <= 3'd3; load_in <= 32'h9BDF_C000; store_in <= 32'h9BDF_C000;
        #10
        #10 selector <= 3'd3; load_in <= 32'h9BDF_0400; store_in <= 32'h9BDF_0400;
        #10

        //LB, SB
        #10 selector <= 3'd2; load_in <= 32'h809B_DFC0; store_in <= 32'h809B_DFC0;
        #10
        #10 selector <= 3'd2; load_in <= 32'h809B_DF40; store_in <= 32'h809B_DF40;
        #10
        //LBU, SW
        #10 selector <= 3'd4; load_in <= 32'h809B_DFC0; store_in <= 32'h809B_DFC0;
        #10
        #10 selector <= 3'd4; load_in <= 32'h809B_DF40; store_in <= 32'h809B_DF40;
        #10

        #(10*2)
        $finish();
    end
    
endmodule