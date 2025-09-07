module operative_part (
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
    reg [63:0] R_c = 64'd0;
    wire [5:0] m6_out;
    wire [7:0] m6_in;
    wire [5:0] c6_out;
    wire [63:0] c6_in;
   
    wire [5:0] sbox_in;
    wire [3:0] sbox_out;

    wire [31:0] xor_shift_in;
    wire [31:0] xor_shift_out;
    wire real_start;

assign case_R_c_zero = (R_c == 64'd0)?1:0;
assign m6_in = R_b;
assign c6_in = R_c;
assign real_start = case_R_c_zero & start;
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



always_ff @(posedge clock or negedge rstn) begin
    if (!rstn) begin//casi reset  S_start   
        R_c <= 64'd0;
        R_h <= 32'h32FE1AF3; 
        R_b <= 8'd0;
    end
    else if(real_start==1'b1) // S_start
    begin
        R_c <= 64'd0;
        R_h <= 32'h32FE1AF3; // dobbiamo scriverlo al contrario perché abbiamo scelto la notazione [MSB:LSB], nel modello in c++ ovviamente la notazione del vettore è [LSB:MSB]
        R_b <= 8'd0;
    end
    else 
    begin
        if(validate_input == 1) begin //S_OP1_RR
            R_c <= R_c + 1;
            R_b <= B;
        end 

        if(validate_R_h == 1) begin //S_OP1_RR e S_OP2_RI
            R_h <= xor_shift_out;
        end
    end
end

endmodule
