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


module sbox (
    input   wire [5:0] in
    ,output wire [3:0] out
);

        always_comb// Valuta la combinazione con uno switch-case
          case (in)
            6'b000000: out = 4'b0010;
            6'b000001: out = 4'b1110;
            6'b000010: out = 4'b1100;
            6'b000011: out = 4'b1011;
            6'b000100: out = 4'b0100;
            6'b000101: out = 4'b0010;
            6'b000110: out = 4'b0001;
            6'b000111: out = 4'b1100;
            6'b001000: out = 4'b0111;
            6'b001001: out = 4'b0100;
            6'b001010: out = 4'b1010;
            6'b001011: out = 4'b0111;
            6'b001100: out = 4'b1011;
            6'b001101: out = 4'b1101;
            6'b001110: out = 4'b0110;
            6'b001111: out = 4'b0001;

            6'b010000: out = 4'b1000;
            6'b010001: out = 4'b0101;
            6'b010010: out = 4'b0101;
            6'b010011: out = 4'b0000;
            6'b010100: out = 4'b0011;
            6'b010101: out = 4'b1111;
            6'b010110: out = 4'b1111;
            6'b010111: out = 4'b1100;
            6'b011000: out = 4'b1101;
            6'b011001: out = 4'b0011;
            6'b011010: out = 4'b0000;
            6'b011011: out = 4'b1001;
            6'b011100: out = 4'b1110;
            6'b011101: out = 4'b1000;
            6'b011110: out = 4'b1001;
            6'b011111: out = 4'b0110;

            6'b100000: out = 4'b0100;
            6'b100001: out = 4'b1011;
            6'b100010: out = 4'b0010;
            6'b100011: out = 4'b1000;
            6'b100100: out = 4'b0001;
            6'b100101: out = 4'b1100;
            6'b100110: out = 4'b1011;
            6'b100111: out = 4'b0111;
            6'b101000: out = 4'b1100;
            6'b101001: out = 4'b0001;
            6'b101010: out = 4'b1101;
            6'b101011: out = 4'b1110;
            6'b101100: out = 4'b0111;
            6'b101101: out = 4'b0010;
            6'b101110: out = 4'b1000;
            6'b101111: out = 4'b1101;

            6'b110000: out = 4'b1111;
            6'b110001: out = 4'b0110;
            6'b110010: out = 4'b1001;
            6'b110011: out = 4'b1111;
            6'b110100: out = 4'b1100;
            6'b110101: out = 4'b0000;
            6'b110110: out = 4'b0101;
            6'b110111: out = 4'b1001;
            6'b111000: out = 4'b0110;
            6'b111001: out = 4'b1100;
            6'b111010: out = 4'b0011;
            6'b111011: out = 4'b0100;
            6'b111100: out = 4'b0000;
            6'b111101: out = 4'b0101;
            6'b111110: out = 4'b1110;
            6'b111111: out = 4'b0011;
        endcase
endmodule


module xor_shift (
    input wire [31:0] H
    ,input wire [3:0] S
    ,input wire [2:0] I
    ,output wire [31:0] H_modified
);

assign H_modified[(I*4)+3 : (I*4)] = ((H[(I*4)+3 : (I*4)] ^ S) << I) | ((H[(I*4)+3 : (I*4)] ^ S) >> (4 - I));


endmodule

module Operative_module (
    input   wire [7:0] B
    ,input  wire start //flag di start  
    ,input  wire clock
    ,input  wire rstn
    ,input  wire validate_input //c
    ,input  wire switch_operation //e
    ,input  wire validate_R_h //f
    ,input  wire [2:0] R_i
    ,output reg [31:0] R_h //digest
    ,output wire case_R_c_zero //h
);
    
    reg [7:0]  R_b;
    reg [63:0] R_c;
    wire [5:0] m6_out;
    wire [7:0] m6_in;
    wire [5:0] c6_out;
    wire [63:0] c6_in;
    wire real_start; // case_R_c_zero AND start

    wire [5:0] sbox_in;
    wire [3:0] sbox_out;

    wire [31:0] xor_shift_in;
    wire [31:0] xor_shift_out;

assign case_R_c_zero = ~(&R_c);
assign real_start = case_R_c_zero & start;
assign m6_in = R_b;
assign c6_in = R_c;

assign sbox_in = switch_operation == 1? c6_out : m6_out; 

assign xor_shift_in = R_h;

M6 modulo_m6(
    .a(m6_in),
    .b(m6_out));

C6 modulo_c6(
    .C6_in(c6_in),
    .i(R_i),
    .C6_out(c6_out));

sbox modulo_sbox(
    .in(sbox_in),
    .out(sbox_out)
);

xor_shift modulo_xor_shift(
    .H(xor_shift_in),
    .S(sbox_out),
    .I(R_i),
    .H_modified(xor_shift_out)
);

always_ff @(posedge real_start or posedge clock or negedge rstn) begin
    if (!rstn or real_start) begin//casi reset     
        R_c <= '0;
        R_h <= 4'h3FA1EF23;
        R_b <= 8'b0;
    end

    else begin
        if(validate_input == 1) begin
            R_c <= R_c + 1;
            R_b <= B;
        end 

        if(validate_R_h == 1) begin
            R_h <= xor_shift_out;
        end
    end
end

endmodule
