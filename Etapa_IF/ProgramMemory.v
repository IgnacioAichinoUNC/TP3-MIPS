`timescale 1ns / 1ps


module ProgramMemory
#(
    parameter SIZE_REGISTER_INST    =  32,
    parameter SIZE_ADDR_PC          =  32,
    parameter SIZE_MEMORY           =  10
)
(
    input wire i_clk,
    input wire i_reset,
    input wire [(SIZE_ADDR_PC-1):0] i_pc,
    input wire [(SIZE_REGISTER_INST-1):0] i_instruction_debug,
    input wire i_flag_instruction_debug,

    output wire [(SIZE_REGISTER_INST-1):0] o_instruction  //La intruccion obtenida
    
);

reg [(SIZE_REGISTER_INST-1):0] reg_memoryBuffer [(2**SIZE_MEMORY)-1:0]; //reg_memoryBuffer[(2^10)-1 : 0] -> reg_memoryBuffer[1023:0]. Cada registro tiene 32 bits de ancho, y hay 1024 registros en total, numerados desde 0 hasta 1023.

reg [(SIZE_MEMORY-1):0] reg_ptr_write, reg_ptr_write_next, reg_ptr_write_tmp; //estos registros son de size 10 para poder llevar a los 1024 registros.

always @(posedge i_clk) begin
    if(i_flag_instruction_debug) begin //Si puede escribir. Esto significa que puede escribir y que no este enable la etapa de IF
        reg_memoryBuffer[reg_ptr_write] <= i_instruction_debug; //Escribo en el buffer de memoria la instruccion
    end
    if(i_reset) begin
        reg_ptr_write <= 0;
    end
    else begin
        reg_ptr_write <= reg_ptr_write_next;
    end
end

always @(*) begin
    reg_ptr_write_tmp = reg_ptr_write + 1;
    reg_ptr_write_next = reg_ptr_write;

    if(i_flag_instruction_debug) begin
        reg_ptr_write_next = reg_ptr_write_tmp; //En el caso de que estÃ© cargando las instrucciones me voy moviendo en el buffer de memoria para ir cargando las mismas.
    end
end

assign o_instruction = reg_memoryBuffer[i_pc >> 2]; //con esto voy buscando en el buffer de memoria desde la posiciÃ³n 0, despuÃ©s en la 1, despuÃ©s en la 2, 3, 4, etc.

endmodule