`timescale 1ns / 1ps


module IF #
(
    parameter SIZE_PC       = 32,
    parameter SIZE_REG_MEM  = 32
)
(
    //inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_flag_select_pc,
    input wire [(SIZE_PC-1):0] i_PCBranch,
    input wire [(SIZE_PC-1):0] i_next_pc,
    input wire [(SIZE_REG_MEM-1):0] i_instruction_write,
    input wire i_enable,
    input wire i_flag_instruction_write,

    //outputs
    output wire [(SIZE_PC-1):0] o_pc4,
    output wire [(SIZE_REG_MEM-1):0] o_instruction_memory,
    output wire [(SIZE_PC-1):0] o_pc
);

    wire [(SIZE_PC-1):0] wire_pc_mux, wire_pc_output;

    Mux21 PCMux21 (
        .i_muxA(o_pc4),
        .i_muxB(i_PCBranch),
        .i_muxSel(i_flag_select_pc),
        .o_muxO(wire_pc_mux)
    ); //En este modulo lo que se hace es elegir si el PC viene del PC+4 o de la ejecucionn de una instruccion de salto

    PC program_counter (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_PC(wire_pc_mux), //El PC del mux
        .i_enable(i_enable), //Va a ser 1 siempre que haya terminado la unidad de debug, que el clock no esta tomado y que no haya un stall.
        .o_PC(wire_pc_output) //El PC seleccionado
    ); //Con este modulo obtengo el PC que luego voy a utilizar en el modulo de instructionMemory.

    PC4 program_counter_4 (
        .i_PC(wire_pc_output),
        .o_PC4(o_pc4)
    );

    ProgramMemory program_memory(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pc(wire_pc_output),
        .i_instruction_debug(i_instruction_write),
        .i_flag_instruction_debug(i_flag_instruction_write & ~i_enable), //esto es para el caso en el que tengo que cargar la memoria con las instrucciones desde la unidad de debug
        .o_instruction(o_instruction_memory)
    );

    assign o_pc = wire_pc_output;

endmodule