module my_first_sv_module (
     input  a
    ,input  b
    ,output c 
);
    assign c = a & b;
endmodule