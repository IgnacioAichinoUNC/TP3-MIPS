`timescale 1ns / 1ps


module ProgramMemory
#(
    parameter SIZE_REGISTER_INST =  32,
    parameter SIZE_MEMORY        =  320
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_pc, //Address recibida por el modulo del program counter
    input wire [(SIZE_REGISTER_INST-1):0] i_instruction_debug,
    input wire i_flag_instruction_debug,  //Me indica que hay una nueva instruccion del debug a cargar
    input wire i_flag_program_PC,        //Flag para avanzar el programa por el PC

    output wire o_instruction_memory  //La intruccion obtenida
    
);

    //FSM( One-Hot)
    localparam [3:0]
        IDDLE               =   4'b0001;
        RECIVE_INSTRUCTION  =   4'b0010;
        WAIT_SEND           =   4'b0011;
        SEND_INSTRUCTION    =   4'b0100;


    localparam HALT_INSTRUCTION             = 32'b00000000000000000000000000000000;
    localparam TOTAL_INSTRUCTIONS_PROGRAM   = 10;

    reg [3:0] state_current, state_next;  
    reg [(SIZE_MEMORY-1):0] memory_buffer_position, memory_buffer_next_position; //Buffer de entrada de memoria de instrucciones
    reg [5:0] instructions, next_instructions;
    reg [(SIZE_REGISTER_INST-1):0] instruction_output;


    assign o_instruction_memory = instruction_output;


    always @ (posedge i_clk) begin
        if(i_reset)begin
            state_current           <= IDDLE;
            memory_buffer_position  <= 0;
            instructions            <= TOTAL_INSTRUCTIONS_PROGRAM;
        end
        else begin
            state_current           <= state_next;
            memory_buffer_position  <= memory_buffer_next_position;
            instructions            <= next_instructions;
        end
    end


    //Combinacional
    always @(*) begin
        state_next = state_current;
        memory_buffer_next_position = memory_buffer_position;
        next_instructions = instructions;

        case(state_current)
            IDDLE: begin
                if(i_flag_instruction_debug) begin           //Check si recibo instrucciones del debug para cargar
                        state_next = RECIVE_INSTRUCTION;    //Tengo que recibir la intruccion del debug
                end
            end

            RECIVE_INSTRUCTION: begin
                if(i_instruction_debug == HALT_INSTRUCTION) begin //Si recibi un Halt finalizo la carga y puedo ejecutar
                    memory_buffer_next_position = {i_instruction_debug, memory_buffer_position[(SIZE_MEMORY-1):SIZE_REGISTER_INST]}; //Tomo el halt
                    memory_buffer_next_position = memory_buffer_next_position >> (SIZE_REGISTER_INST*(instructions -1)); //halt al final
                    state_next = WAIT_SEND;
                end
                else begin //Recibi instruccion del Debug y la guardo en memoria
                    memory_buffer_next_position = {i_instruction_debug, memory_buffer_position[(SIZE_MEMORY-1):SIZE_REGISTER_INST]};  //Tomo la instruccion
                    next_instructions = instructions - 1;
                    state_next = IDDLE; //Vuelvo a esperar instruccion
                end
            end

            WAIT_SEND: begin
                instruction_output = memory_buffer_position[0+:SIZE_REGISTER_INST];
                if(i_flag_program_PC) begin //Tengo que avanzar en el program, entonces envio la instruccion
                    state_next = SEND_INSTRUCTION;
                end
            end

            SEND_INSTRUCTION: begin
                instruction_output= memory_buffer_position[(i_pc)+:SIZE_REGISTER_INST];  //Saco la instruccion indicada por el address del PC.
            end

        endcase
     end
endmodule