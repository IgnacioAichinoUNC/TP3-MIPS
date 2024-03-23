`timescale 1ns / 1ps

module PC#
(
    parameter SIZE_ADDR_PC = 32
)
(

    input wire i_clk,
    input wire i_reset,
    input wire [(SIZE_ADDR_PC-1):0] i_PC, //PC de una burbuja y no hay que hacer PC+4
    input wire i_enable,         //Habilita la etepa IFID
    
    
    output wire [(SIZE_ADDR_PC)-1:0] o_PC
);

reg [(SIZE_ADDR_PC-1):0] reg_PC;

always @(posedge i_clk) begin
    if(i_reset) begin
        reg_PC <= 0;
    end
    else if (i_enable) begin
        reg_PC <= i_PC;
    end
end

assign o_PC = reg_PC;

endmodule