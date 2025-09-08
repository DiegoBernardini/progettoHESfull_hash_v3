// modulo che contiene il modulo operativo e il modulo di cotrollo

module full_hash (
    input wire clk
    ,input wire rst_n
    ,input wire start
    ,input wire [7:0] Byte
    ,input wire End_of_File
    ,input wire F_dr
    ,output reg [0:31] R_h
    ,output wire F_rtr
    ,output wire H_ready
);

   

    wire case_rc0,sw_o,vi,v_R_H; // fili di connessione
    wire [2:0] i;
    wire [31:0] digest;
    wire [0:31] real_digest; // output finale
    assign R_h = real_digest;
    control_part control(
        .clk(clk)
        ,.rst_n(rst_n)
        ,.F_dr(F_dr)
        ,.End_of_File(End_of_File)
        ,.start(start)
        ,.case_rc0(case_rc0)
        ,.F_rtr(F_rtr)
        ,.switch_operation(sw_o)
        ,.H_ready(H_ready)
        ,.validate_input(vi)
        ,.validate_R_H(v_R_H)
        ,.R_i(i)
    );

    operative_part operative(
     .B(Byte)
    ,.start(start)  
    ,.clock(clk)
    ,.rstn(rst_n)
    ,.validate_input(vi)
    ,.switch_operation(sw_o)
    ,.validate_R_h(v_R_H)
    ,.R_i(i)
    ,.R_h(digest)
    ,.case_R_c_zero(case_rc0)
    );

    inverter invertitore(  
    .H_in(digest)
    ,.H_out(real_digest)
    );
endmodule