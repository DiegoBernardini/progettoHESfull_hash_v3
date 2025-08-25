module xor_shift (
    input wire [31:0] H
    ,input wire [3:0] S
    ,input wire [2:0] I
    ,output wire [31:0] H_modified
);

reg [31:0] H_m;
assign H_modified = H_m;
always_comb
begin
    H_m = H;
    H_m[(I*4)+: 4] = ((H[(I*4)+:4] ^ S) << I) | ((H[(I*4)+:4] ^ S) >> (4 - I));
end

endmodule
