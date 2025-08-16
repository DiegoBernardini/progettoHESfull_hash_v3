module full_hash (
    input wire clk
    ,input wire start
    ,input wire [7:0] Byte
    ,input wire End_Of_File
    ,input wire F_dr
    ,output reg [31:0] R_h
    ,output wire F_rtr
    ,output wire H_ready
);

    control_part control(
        .clk(clk)
    );

    opertive oper(

    );
endmodule