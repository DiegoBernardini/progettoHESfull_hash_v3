//𝐶6[𝑖] = {𝐶[𝑖][7] ⊕ 𝐶[𝑖][1], 𝐶[𝑖][3], 𝐶[𝑖][2], 𝐶[𝑖][5] ⊕ 𝐶[𝑖][0], 𝐶[𝑖][4], 𝐶[𝑖][6]}

module C6 (
    input   wire [63:0] C6_in
    ,input  wire [2:0] i
    ,output wire [5:0] C6_out
);

assign C6_out[0] = C6_in[(i*8) + 6]; 
assign C6_out[1] = C6_in[(i*8) + 4]; 
assign C6_out[2] = C6_in[(i*8) + 5] ^ C6_in[(i*8) + 0]; 
assign C6_out[3] = C6_in[(i*8) + 2];
assign C6_out[4] = C6_in[(i*8) + 3];
assign C6_out[5] = C6_in[(i*8) + 7] ^ C6_in[(i*8) + 1];

endmodule