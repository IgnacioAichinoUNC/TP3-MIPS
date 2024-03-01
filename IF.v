`timescale 1ns / 1ps


module IF #
(
    parameter SIZE_PC       = 32
)
(
    //inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_flag_start_pc,
    input wire [(SIZE_PC-1):0] i_next_pc,
    input wire i_enable
    input wire i_flag_halt,
    input wire i_flag_load_pc,


    //outputs
    output wire o_next_pc;
);

    wire [(SIZE_PC-1):0] wire_pc_memory, wire_next_pc;


    PC program_counter (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_nextPC(i_next_pc),
        .i_flag_start_pc(i_flag_start_pc), //Flag para incrementar el PC y avanzar el programa
        .i_enable(i_enable),            //Habilita la etepa IFID, e activa los estados del PC
        .i_flag_halt(i_flag_halt),       //Recibi un Halt de la unidad de riesgo y termino el progama
        .i_flag_load_pc(i_flag_load_pc), //No aumento el PC, hubo un Stall detectado
        .o_pc(wire_pc_memory),
        .o_next_pc(wire_next_pc)
    );

    assign o_next_pc = next_pc >> 3; //mapeo de bits a bytes

endmodule