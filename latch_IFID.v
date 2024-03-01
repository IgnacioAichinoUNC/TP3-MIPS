`timescale 1ns / 1ps


module latch_IFID
#(
     parameter SIZE_REGISTER_INST = 32,
     parameter SIZE_ADDR_PC       = 32
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,         //Habilita la etepa IFID, e activa los estados en el PC
    input wire i_instruction,
    input wire i_next_PC,

    output wire  o_instruction_ifid,
    output wire  o_next_pc_ifid,
    output wire  o_enable

);

    //registers
    reg [(SIZE_REGISTER_INST-1):0] instruction_data;
    reg [(SIZE_ADDR_PC-1):0] next_pc;

    assign o_instruction_ifid   = instruction_data;
    assign o_next_pc_ifid       = next_pc;  

    always @(posedge i_clk) begin
        if(i_reset) begin
            instruction_data    <= 0;
            next_pc             <= 0;
        end
        else begin
            if(i_enable) begin  //IFID enable
                instruction_data <= i_instruction;  
                next_pc          <= i_next_PC;
            end                
        end
    end

endmodule