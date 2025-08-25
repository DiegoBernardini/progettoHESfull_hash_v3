module sbox (
    input   wire [5:0] in
    ,output wire [3:0] out
);
        reg [3:0] sup_out;
        assign out = sup_out;
        always_comb// Valuta la combinazione con uno switch-case
          case (in)
            6'b000000: sup_out = 4'b0010;
            6'b000001: sup_out = 4'b1110;
            6'b000010: sup_out = 4'b1100;
            6'b000011: sup_out = 4'b1011;
            6'b000100: sup_out = 4'b0100;
            6'b000101: sup_out = 4'b0010;
            6'b000110: sup_out = 4'b0001;
            6'b000111: sup_out = 4'b1100;
            6'b001000: sup_out = 4'b0111;
            6'b001001: sup_out = 4'b0100;
            6'b001010: sup_out = 4'b1010;
            6'b001011: sup_out = 4'b0111;
            6'b001100: sup_out = 4'b1011;
            6'b001101: sup_out = 4'b1101;
            6'b001110: sup_out = 4'b0110;
            6'b001111: sup_out = 4'b0001;

            6'b010000: sup_out = 4'b1000;
            6'b010001: sup_out = 4'b0101;
            6'b010010: sup_out = 4'b0101;
            6'b010011: sup_out = 4'b0000;
            6'b010100: sup_out = 4'b0011;
            6'b010101: sup_out = 4'b1111;
            6'b010110: sup_out = 4'b1111;
            6'b010111: sup_out = 4'b1100;
            6'b011000: sup_out = 4'b1101;
            6'b011001: sup_out = 4'b0011;
            6'b011010: sup_out = 4'b0000;
            6'b011011: sup_out = 4'b1001;
            6'b011100: sup_out = 4'b1110;
            6'b011101: sup_out = 4'b1000;
            6'b011110: sup_out = 4'b1001;
            6'b011111: sup_out = 4'b0110;

            6'b100000: sup_out = 4'b0100;
            6'b100001: sup_out = 4'b1011;
            6'b100010: sup_out = 4'b0010;
            6'b100011: sup_out = 4'b1000;
            6'b100100: sup_out = 4'b0001;
            6'b100101: sup_out = 4'b1100;
            6'b100110: sup_out = 4'b1011;
            6'b100111: sup_out = 4'b0111;
            6'b101000: sup_out = 4'b1100;
            6'b101001: sup_out = 4'b0001;
            6'b101010: sup_out = 4'b1101;
            6'b101011: sup_out = 4'b1110;
            6'b101100: sup_out = 4'b0111;
            6'b101101: sup_out = 4'b0010;
            6'b101110: sup_out = 4'b1000;
            6'b101111: sup_out = 4'b1101;

            6'b110000: sup_out = 4'b1111;
            6'b110001: sup_out = 4'b0110;
            6'b110010: sup_out = 4'b1001;
            6'b110011: sup_out = 4'b1111;
            6'b110100: sup_out = 4'b1100;
            6'b110101: sup_out = 4'b0000;
            6'b110110: sup_out = 4'b0101;
            6'b110111: sup_out = 4'b1001;
            6'b111000: sup_out = 4'b0110;
            6'b111001: sup_out = 4'b1100;
            6'b111010: sup_out = 4'b0011;
            6'b111011: sup_out = 4'b0100;
            6'b111100: sup_out = 4'b0000;
            6'b111101: sup_out = 4'b0101;
            6'b111110: sup_out = 4'b1110;
            6'b111111: sup_out = 4'b0011;
        endcase
endmodule