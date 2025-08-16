module control_part(
    input  wireclk
    ,input wire rst_n
    ,input wire F_dr
    ,input wire End_Of_File
    ,input wire start
    ,input wire case_rc0
    ,output wire F_rtr
    ,output wire switch_operation
    ,output wire H_ready
    ,output wire validate_input
    ,output wire validate_R_H
    ,output reg [2:0] R_i
);
    
    reg [3:0] R_r;
    wire disable_R_R,incrementation_round,next_iteration,case_empty_input,ric_12,real_start;
    assign F_rtr = (start & case_rc0)|ric_12;
    assign case_empty_input = case_rc0 & End_Of_File;
    assign switch_operation = disable_R_R | case_empty_input;
    assign disable_R_R = End_Of_File & ric_12;
    assign incrementation_round = disable_R_R == 1?0:next_iteration;
    assign validate_input = F_dr & F_rtr;
    assign validate_R_H = validate_input|switch_operation; 
    assign next_iteration = &R_i;
    assign ric_12 = R_r < 12?0:1;
    assign H_ready = End_Of_File & next_iteration;
    assign real_start = case_rc0 & start
    always_ff @(posedge clk or negedge rst_n or posedge real_start) 
   
        if(!rst_n || real_start)
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