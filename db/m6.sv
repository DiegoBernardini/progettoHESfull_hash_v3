//𝑀6 = {𝑀[3] ⊕ 𝑀[2], 𝑀[1], 𝑀[0], 𝑀[7], 𝑀[6], 𝑀[5] ⊕ 𝑀[4]}

module M6 (
     input  wire [7:0] a
    ,output wire [5:0] b 
);

assign b[0] = a[5] ^ a[4] ;
assign b[1] = a[6];
assign b[2] = a[7];
assign b[3] = a[0];
assign b[4] = a[1];
assign b[5] = a[3] ^ a[2];

endmodule