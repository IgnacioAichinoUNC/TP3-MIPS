module PC4
#(
    parameter SIZE_ADDR_PC = 32
)
(
    input wire [(SIZE_ADDR_PC-1):0] i_PC,
    output wire [(SIZE_ADDR_PC)-1:0] o_PC4
);

reg [(SIZE_ADDR_PC-1):0] reg_PC4;

always @(*) begin
    reg_PC4 = i_PC + 4;
end

assign o_PC4 = reg_PC4;

endmodule