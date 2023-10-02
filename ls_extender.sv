//
// Design unit  : Load Store extender
//              :
// File name    : ls_extender.sv
//              :
// Module name  : LS_extender
//              :
// Description  : Handling the size of byte required to 
//              : Load and store, along with sign extention 
//
// Version      : 4.0 
//

module LS_extender #(parameter WIDTH = 32) (
    input logic [2:0] selector,
    input logic [WIDTH - 1 : 0] load_in, store_in,
    output logic [WIDTH - 1 : 0] load_out, store_out
);
    always_comb begin
        case (selector)
            //LW, SW
            3'd0 :begin
                load_out  = load_in;
                store_out = store_in;
            end
            //LH, SH
            3'd1 :begin
                load_out  = {{16{load_in[15]}},load_in[15:0]};
                store_out = {{16{store_in[15]}},store_in[15:0]};
            end
            //LB, SB
            3'd2 :begin
                load_out  = {{24{load_in[7]}},load_in[7:0]};
                store_out = {{24{store_in[7]}},store_in[7:0]};
            end
            //LHU, SW
            3'd3 :begin
                load_out  = {{16{1'b0}},load_in[15:0]};
                store_out = store_in;
            end
            //LBU, SW
            3'd4 :begin
                load_out = {{24{1'b0}},load_in[7:0]};
                store_out = store_in;
            end
            default: begin
                load_out = load_in;
                store_out = store_in;
            end
        endcase
    end
    
endmodule