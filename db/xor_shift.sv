module xor_shift (
    input wire [31:0] H
    ,input wire [3:0] S
    ,input wire [2:0] I
    ,output wire [31:0] H_modified
);

assign H_modified[(I*4)+3 : (I*4)] = ((H[(I*4)+3 : (I*4)] ^ S) << I) | ((H[(I*4)+3 : (I*4)] ^ S) >> (4 - I));


endmodule
