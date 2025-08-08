module control_part(
    input clk
    ,input rst_n
    ,input F_dr
    ,input End_Of_File
    ,input start
    ,input case_rc0
    ,output F_rtr
    ,output switch_operation
    ,output H_ready
    ,output validate_input
    ,output validate_R_H
    ,output [2:0] I
);
    
    reg [3:0] R_r;
    reg [2:0] R_i;
    wire disable_R_R,incrementation_round,next_iteration,case_empty_input,ric_12;
    assign F_rtr = (start & case_rc0)|ric_12;
    assign case_empty_input = case_rc0 & End_Of_File;
    assign switch_operation = disable_R_R | case_empty_input;
    assign disable_R_R = End_Of_File & ric_12;
    assign incrementation_round = disable_R_R == 1?0:next_iteration;
    assign validate_input = F_dr & F_rtr;
    assign validate_R_H = validate_input|switch_operation; 
    assign next_iteration = &R_i;
    assign ric_12 = R_r < 12?0:1;

    always_ff @( posedge clk or negedge rst_n ) 
   
        if(!rst_n)
        begin
            R_i <= 3'b000;
            R_r <= 4'b0000;  
        end 
        else if(next_iteration == 1'b0)
        begin
            R_i <= R_i+1;
        end else
        begin
            R_i <= 3'b000;  
            case({validate_input,incrementation_round})
                2'b00: R_r<=R_r;
                2'b01: R_r<=R_r+1;
                2'b10,2'b11: R_r<=4'b0000;
            endcase
         end
endmodule