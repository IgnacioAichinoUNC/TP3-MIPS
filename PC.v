`timescale 1ns / 1ps

module PC#
(
    parameter SIZE_ADDR_PC = 32
)
(

    input wire i_clk,
    input wire i_reset,
    input wire [(SIZE_ADDR_PC-1):0] i_nextPC, //PC de una burbuja y no hay que hacer PC+4
    input wire i_flag_start_pc,  //Flag para incrementar el PC y avanzar el programa
    input wire i_enable,         //Habilita la etepa IFID, e activa los estados
    input wire i_flag_halt,      //Recibi un Halt de la unidad de riesgo y termino el progama
    input wire i_flag_load_pc,  //No aumento el PC, hubo un Stall detectado
    output wire [(SIZE_ADDR_PC)-1:0] o_pc
    output wire [(SIZE_ADDR_PC)-1:0] o_next_pc
);


    //FSM( One-Hot)
    localparam [3:0]
        IDDLE           =   4'b0001;
        INCREMENT_PC    =   4'b0010;
        FINISH_PC       =   4'b0011;
        NO_LOAD_PC      =   4'b0111;
        

    //Registros
    reg [3:0] state_current, state_next;
    reg [SIZE_ADDR_PC-1:0] pc;


    assign o_pc = pc;
    assign o_next_pc= pc + {{(SIZE_PC-6){1'b0}},6'b100000};//pc+4Bytes

    always @(posedge i_clk) begin
        if(i_reset) begin
            state_current <= IDDLE;
        end
        else begin
            if(i_enable) begin  //IFID enable
                state_current <= state_next;
            end
        end
    end

    
    always @(*) begin
        state_next = state_current;

        case(state_current)
            IDDLE: begin
                pc = 0;
                if(i_flag_start_pc) begin //Habilita ejecutar instrucciones
                    state_next = INCREMENT_PC;
                end
            end

            INCREMENT_PC: begin
                //Aca hay 2 opciones
                //1 recibi un halt es decir termino de ejecutar
                //2 no tengo q cargar mas intrucciones por que hay un stall, burbuja
                if(i_flag_halt) begin
                    state_next = FINISH_PC;
                end
                else begin
                    if(i_flag_load_pc) begin
                        state_next = NO_LOAD_PC;
                    end
                    //caso contrario??
                    if(~i_flag_load_pc) begin
                        pc=i_next_pc<<3;  // Mapeo de i_next_pc de BYTE a BIT.
                    end
                end
            end

            NO_LOAD_PC: begin
                // y aca? vuelvo simpre al estado increment?
                state_next = INCREMENT_PC;
            end

            FINISH_PC: begin
                //loop
                state_next = FINISH_PC;
            end
        endcase
    end 
endmodule