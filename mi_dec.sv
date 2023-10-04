//
// Design unit  : Multicycle Instrcution decorder
//              :
// File name    : mi_dec.sv
//              :
// Module name  : MI_dec
//              :
// Description  : Handle the multi instruction memcopy 
//              : decording to lW, SW instruction
//
// Version      : 4.0 Completing instructions running
//              : Multi_cycle
//

module MI_dec #(parameter WIDTH = 32) (
    input logic clk, rst, en,
    input logic [WIDTH - 1 : 0] pc_in, instr_in,
    output logic pc_en,
    output logic [WIDTH - 1 : 0] pc_out, instr_out,
    output reg [1:0] state
);
    
    parameter IDLE  = 2'd0;
    parameter LOAD_W = 2'd1;
    parameter STORE_W = 2'd2;

    logic [11:0] count, size;
    logic [WIDTH - 1 : 0] memc, pc;

    //State machine
    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin
            state <= IDLE;
        end else begin        
            case (state)
                IDLE : begin
                    instr_out   <= instr_in;
                    memc        <= instr_in;
                    pc          <= pc_in;
                    count       <= 0;
                    size        <=instr_in[31:20];
                    state = (en) ? LOAD_W: IDLE;
                end
                       
                LOAD_W : begin
                    instr_out <= {count,memc[19:15],3'b010,5'b01001,7'b0000011};
                    state <= STORE_W;

                end

                STORE_W : begin
                    instr_out <= {count[11:5],5'b0,memc[11:7],3'b010,count[4:0],7'b0000011};
                    state <= (count == size) ? IDLE : LOAD_W;
                    count <= count + 1; 
                end

            endcase
        end
        
    end

    assign pc_out = (state == IDLE) ? pc_in : pc;
    assign pc_en  = (state == IDLE) ? 1 : 0;

    
endmodule