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
    
    // --- Registro stato e stati
    reg[2:0] state;
    reg[2:0] next_state;
    localparam  [2:0] S_start = 3'd0;
    localparam  [2:0] S_read =  3'd1;
    localparam  [2:0] S_OP1_RR = 3'd2;
    localparam  [2:0] S_RI= 3'd3;
    localparam  [2:0] S_WAIT1 = 3'd4;
    localparam  [2:0] S_OP2_AZZERA = 3'd5;
    localparam  [2:0] S_OP2_RI = 3'd6;
    localparam  [2:0] S_END= 3'd7;
    

    reg [3:0] R_r;
    reg       VLI; 
    reg       SW_O;
    reg       H_R;
    reg       F_rtr_s; 
    wire incrementation_round,ric_12,real_start, last_iteration;
    assign F_rtr = F_rtr_s;
    assign switch_operation = SW_O;
    assign incrementation_round = (R_i==3'd7)?1'b1:1'b0;
    assign validate_input = F_dr & F_rtr;
    assign validate_R_H = VLI;  
    assign last_iteration = (R_i == 3'd6)?1'b1:1'b0;
    assign ric_12 = (R_r == 4'd11)?1'b1:1'b0;
    assign H_ready = H_R;
    assign real_start = case_rc0 & start;
  
  // avanzamento stati
    always_ff @(posedge clk or negedge rst_n ) 
      if(!rst_n)
      begin
        state <= S_start;
      end
      else if(real_start == 1'b1)
      begin
        state <= S_start;
      end
      else
      begin
        state <= next_state;
      end
    // Gestione degli stati
    always_comb 
        case(state)

          S_start: 
          begin
            if(F_dr == 1'b1 && F_rtr_s == 1'b1)
              next_state = S_read;
            else if(F_rtr_s == 1'b1 && End_of_File == 1'b1)
              next_state = S_OP2_RI;
            else 
              next_state = state;              
           
          end

          S_read:
            begin
                next_state = S_OP1_RR;
            end

          S_OP1_RR: 
            begin
              if(ric_12 == 1'b0  && incrementation_round == 1'b0)
              next_state = S_RI;
              else 
              next_state = state; 
            end

          S_RI:
            begin
              if(incrementation_round == 1'b1 && ric_12 == 1'b0)
                next_state = S_OP1_RR;
              else if(ric_12 == 1'b1 && last_iteration == 1'b1)
                next_state = S_WAIT1;
               else 
              next_state = state; 
            end

          S_WAIT1:
            begin
            if(F_dr == 1'b1)
              next_state = S_read;
            else if(End_of_File == 1'b1)
              next_state = S_OP1_AZZERA;
               else 
              next_state = state; 
            end

          S_OP2_AZZERA:
            begin
              next_state = S_OP2_RI;
            end

          S_OP2_RI:
            begin
            if(last_iteration == 1'b1)
              next_state = S_END;
               else 
              next_state = state; 
            end
          S_END:
            begin
            next_state = S_END;
            end
        endcase
    // blocco per il controllo di R_i e R_r
    always_ff @(posedge clk) 
                   
        if(state == S_start || state == S_WAIT1) 
        begin
            R_i <= 3'b000;
            R_r <= 4'b1111;  
        end  
        else if(state == S_RI) 
        begin
            R_i <= R_i+3'd1;
        end else if (state == S_OP1_RR) 
        begin  
            R_i<=3'b000;
            R_r<=R_r+3'd1;
        end
        else if(state == S_OP1_AZZERA) 
        begin
          R_i<=3'b000;
        end                                                                             
        else if(state == S_OP2_RI) 
         begin
          R_i<=R_i+3'd1;
        end
      

      // blocco per il controllo SW_O
    always_ff @(posedge clk  ) 
     if(state == S_start) 
      begin
        SW_O <=0;
      end 
      else if(state == S_OP2_RI) 
      begin
        SW_O <= 1'b1;
      end
    
    always_ff @(posedge clk  ) 
       if(state == S_start) 
        begin 
            F_rtr_s <=1'b1;
        end 

        else if(state == S_WAIT1)
        begin 
          F_rtr_s <= 1'b1;
        end 
        else if(state == S_read || state == S_OP1_AZZERA) 
        begin
          F_rtr_s<=1'b0;
        end
    //blocco per il controllo di validate_input
    always_ff @(posedge clk  ) 
       if(state == S_start) 
        begin
          VLI <=1'b0;
        end
        else if(state == S_OP1_RR || state == S_OP2_AZZERA) 
        begin
          VLI <= 1'b1;
        end
        else if(state == S_WAIT1 || state == S_END) 
        begin
          VLI<= 1'b0;
        end
    //blocco per il controllo di H_ready
    always_ff  @(posedge clk  )
     if(state == S_start) 
        begin 
            H_R <=1'b0;
        end 
        else if(state == S_END) 
        begin
          H_R <=1'b1;
        end

endmodule