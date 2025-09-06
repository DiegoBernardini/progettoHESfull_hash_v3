// modulo che genera i segnali di controllo

module control_part(
    input  wire clk
    ,input wire rst_n
    ,input wire F_dr
    ,input wire End_of_File
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
    reg       Eof;
    reg       VLI; 
    reg       SW_O;
    reg       H_R;
    reg       F_rtr_s; 
    wire disable_R_R,incrementation_round,next_iteration,case_empty_input,ric_12,real_start;
    assign F_rtr = F_rtr_s;
    assign case_empty_input = case_rc0 & End_of_File;
    assign switch_operation = disable_R_R | case_empty_input;
    assign disable_R_R = Eof & ric_12;
    assign incrementation_round = (disable_R_R == 1'b1)?0:next_iteration;
    assign validate_input = F_dr & F_rtr;
    assign validate_R_H = VLI|SW_O; 
    assign next_iteration = (R_i==3'd7)?1:0;  
    assign ric_12 = (R_r == 4'd12)?1:0;
    assign H_ready = H_R;
    assign real_start = case_rc0 & start;

    // blocco per il controllo di R_i e R_r
    always_ff @(posedge clk or negedge rst_n ) 
        if(!rst_n)
        begin
            R_i <= 3'b000;
            R_r <= 4'b0000; 
            
        end 
        else if(real_start == 1'b1 || validate_input == 1'b1) 
        begin
            R_i <= 3'b000;
            R_r <= 4'b0000;  
        end 
        else if(next_iteration == 1'b0 && switch_operation == 1'b0)
        begin
            R_i <= R_i+1;
        end else if (incrementation_round == 1'b1)
        begin  
            R_i<=3'b000;
            R_r<=R_r+1;
        end
        else if(switch_operation== 1'b1 && End_of_File == 1'b1) 
        begin
          R_i<=3'b000;
        end
        else if(switch_operation== 1'b1 && End_of_File == 1'b0 && next_iteration == 1'b0) //per incrementare dopo l'arrivo di End_of_File, perché il contantore R_i prende 3 cicli in più quindi la seconda operazione non parte da 0, ma da 2, è necessario resettare I
         begin
          R_i<=R_i+1;
        end
      
    // blocco per il controllo Eof
    always_ff @(posedge clk or negedge rst_n ) 

      if(!rst_n)
      begin
        Eof <=0;
      end 
      else if(real_start == 1'b1)
      begin
        Eof <=0;
      end
      else if(End_of_File == 1'b1)
      begin
        Eof <= End_of_File;
      end


      // blocco per il controllo SW_O
      always_ff @(posedge clk or negedge rst_n ) 
      if(!rst_n)
      begin
        SW_O <=0;
      end 
      else if(real_start == 1'b1)
      begin
        SW_O <=0;
      end
      else if(switch_operation == 1'b1 && R_i==3'd2) 
      begin
        SW_O <= 1'b1;
      end
      else if(case_empty_input == 1'b1)
      begin
         SW_O <= 1'b1;
      end
    // blocco per il controllo del flag ready_to_read
    always_ff @(posedge clk or negedge rst_n ) 
        if(!rst_n)
        begin 
            F_rtr_s <=1'b1;
        end
        else if(real_start == 1'b1) 
        begin
          F_rtr_s <= 1'b1;
        end
        else if(Eof == 1'b1)
        begin
          F_rtr_s <=1'b0;
        end
        else if(F_rtr == 1'b0)
        begin 
          F_rtr_s <= ric_12;
        end 
        else if(F_dr == 1'b1)
        begin
          F_rtr_s<=1'b0;
        end
    //blocco per il controllo di validate_input
    always_ff @(posedge clk or negedge rst_n ) 
        if(!rst_n)
        begin
          VLI <=1'b0;
        end
        else if(real_start == 1)
        begin
          VLI <= 1'b0;
        end
        else if(F_dr == 1 &&  F_rtr ==1)
        begin
          VLI <= 1'b1;
        end
        else if(ric_12 == 1)
        begin
          VLI<= 1'b0;
        end
    //blocco per il controllo di H_ready
    always_ff  @(posedge clk or negedge rst_n )
      if(!rst_n)
        begin 
            H_R <=1'b0;
        end
        else if(real_start == 1'b1) 
        begin
          H_R <= 1'b0;
        end
        else if(Eof == 1'b1 && next_iteration==1'b1)
        begin
          H_R <=1'b1;
        end
        else if(next_iteration == 1'b0)
        begin
          H_R <=1'b0;
        end

endmodule