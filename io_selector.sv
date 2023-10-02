//
// Design unit  : I/O selector
//              :
// File name    : io_selector.sv
//              :
// Module name  : IO_Selector
//              :
// Description  : The FPGA has limited I/O pins, so setting 
//              : a unit surface to manage data in out write of
//              : intruction and data memory
//
// Version      : 2.0
//

module IO_Selector #(parameter WIDTH = 32) (
    input logic  selector,
    input logic [WIDTH - 1 : 0] data_in, ins_out, mem_out,
    output logic [WIDTH - 1 : 0] data_out, ins_in, mem_in
);
    always_comb begin
        case (selector)
            // Connecting to the instruction mem
            1'b0 : begin
                data_out = ins_out;
                ins_in = data_in;
            end
            // Connecting to the instruction mem
            1'b1 : begin
                data_out = mem_out;
                mem_in = data_in;
            end
            default: begin
                data_out = 32'bx;
                ins_in   = 32'bx;
                mem_in   = 32'bx;
            end
        endcase
    end
    
endmodule