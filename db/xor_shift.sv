//𝐻[𝑖] = (𝐻[(𝑖 + 1) 𝑚𝑜𝑑 8] ⊕ 𝑆(𝑀6)) ≪ ⌊𝑖/2⌋

module xor_shift (
    input wire [31:0] H
    ,input wire [3:0] S
    ,input wire [2:0] I
    ,output wire [31:0] H_modified
);

reg [31:0] H_m; //registro di supporto per le operazioni successive 
assign H_modified = H_m;
always_comb
begin
    H_m = H;
    H_m[(I*4)+: 4] = ((H[(I*4)+:4] ^ S) << I) | ((H[(I*4)+:4] ^ S) >> (4 - I));
end

endmodule
