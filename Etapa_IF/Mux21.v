module Mux21
#(
    parameter SIZE_REG_MEM  = 32
)
(
    input wire [(SIZE_REG_MEM-1):0] i_muxA,
    input wire [(SIZE_REG_MEM-1):0] i_muxB,
    input wire                      i_muxSel,

    output wire [(SIZE_REG_MEM-1):0] o_muxO
);

reg [(SIZE_REG_MEM-1):0] reg_muxO;

always @(*) begin
    case (i_muxSel)
        1'b0: reg_muxO = i_muxA;
        1'b1: reg_muxO = i_muxB;

        default: reg_muxO = i_muxA;
    endcase
end

assign o_muxO = reg_muxO;

endmodule