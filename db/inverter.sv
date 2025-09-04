//invert the positions of the nipples

module inverter (
    input  wire [31:0] H_in
    ,output wire [0:31] H_out
);

    assign H_out = {    H_in[3:0],
                        H_in[7:4],
                        H_in[11:8],
                        H_in[15:12],
                        H_in[19:16],
                        H_in[23:20],
                        H_in[27:24],
                        H_in[31:28]
                        };

endmodule