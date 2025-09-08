// File: testbench_verilog.v
`timescale 1ns/1ps

module testbench;

  // --- Parametri di Simulazione ---
  parameter CLK_PERIOD = 20; // Periodo del clock: 10 ns (Frequenza: 100 MHz)

  // 1. --- Segnali della Testbench ---
  // Uso 'reg' per i segnali che devono essere guidati da un blocco procedurale (initial, always)
  reg           clk = 1'b0;
  reg           rst_n;
  reg           start;
  reg   [7:0]   Byte;
  reg           End_of_File;
  reg           F_dr;
  
  // Uso 'wire' per leggere le uscite dal DUT
  wire  [0:31]  R_h;
  wire          F_rtr;
  wire          H_ready;


  // registri di lavoro
  reg [31:0] test_output;
   
  // Variabile intera per i cicli
  integer i;
  integer reset_done = 0;

  // Memoria per contenere i dati di test
  string test = "CiaoMondo";
  integer test_reset = $urandom_range(0,test.len()); // posizione in cui avviene il reset
  integer test_start = $urandom_range(0,test.len()); // posizione in cui si tenta di ripremere il tast start
   integer ritardo = $urandom_range(0,test.len()); 
  // 2. --- Istanza del DUT (Design Under Test) ---
  // Collega i segnali della testbench alle porte del modulo da testare
  full_hash dut (
      .clk          (clk),
      .rst_n        (rst_n),
      .start        (start),
      .Byte         (Byte),
      .End_of_File  (End_of_File),
      .F_dr         (F_dr),
      .R_h          (R_h),
      .F_rtr        (F_rtr),
      .H_ready      (H_ready)
  );

  // 3. --- Generatore di Clock ---
  // Questo blocco 'always' crea un'onda quadra continua per il clock
  always #((CLK_PERIOD)/2) clk = ~clk;


  // 4. --- Blocco Principale degli Stimoli ---
  initial begin
    // --- Inizializzazione ---
    $display("Avvio della simulazione ...");
    clk   = 1'b0;
    $display("Test di esecuzione regolare");
    rst_n = 1'b1;
    start = 1'b0;
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;
   
    // --- Inizio del Test esecuzione regolare ---
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;

    // --- Invio del flusso di dati con un ciclo 'for' ---
    for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1) 
      F_dr        = 1'b1;
      wait(F_rtr == 1);     
      Byte        = test[i];     
      @(posedge clk);
      
      F_dr = 1'b0;
      wait(F_rtr == 0);
     
    end
    wait(F_rtr == 1);
    End_of_File = 1'b1;
    wait(F_rtr == 0);
    End_of_File = 1'b0;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);


    #(CLK_PERIOD * 2)
    
    //--- Fine test esecuzione regolare --- 
   
    //--- Inizio Test con Reset ---
    rst_n = 1'b0;
    $display("Test di Esecuzione con Reset Casuale");
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;
    #(CLK_PERIOD * 5);
    rst_n = 1'b1; // Rilascia il reset
    start = 1'b0;
    
    // --- Inizio del Test ---
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
    rst_n = 1'b1; 
    
    $display("Punto di reset: %0d Lettera", test_reset);

    for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1) 
      F_dr        = 1'b1;
      wait(F_rtr == 1);     
      Byte        = test[i];      
    
      @(posedge clk);
     
      F_dr = 1'b0;
      wait(F_rtr == 0);

      if(i == test_reset && reset_done == 0)
        begin
          rst_n = 1'b0; // Applica il reset (attivo basso)
          F_dr  = 1'b0;
          Byte  = 8'h00;
          i = -1;
          reset_done = 1;
          #(CLK_PERIOD * 5);
          rst_n = 1'b1; // Rilascia il reset
          $display("Tempo: %0t ns -> Reset rilasciato.", $time);
          @(posedge clk);
        end
      
     
    end
    wait(F_rtr == 1);
    End_of_File = 1'b1;
    wait(F_rtr == 0);
    End_of_File = 1'b0;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);


    // --- Fine Test esecuzione con reset ----



    // --- Inizio Test esecuzione con Start bloccato


    rst_n = 1'b0;
    $display("Test di esecuzione blocco start");
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;
    #(CLK_PERIOD * 5);
    rst_n = 1'b1; // Rilascia il reset
    start = 1'b0;
    
   
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
   
    
    $display("Punto di start: %0d", test_start);

    for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1) 
      F_dr        = 1'b1;
      wait(F_rtr == 1);     
      Byte        = test[i];
    

      @(posedge clk);
      
      F_dr = 1'b0;
      wait(F_rtr == 0);

      if(i == test_start)
        begin
          start = 1'b1; // tenta di inviare un altro start
          @(posedge clk);
          start = 1'b0;
        end
      
     
    end
    wait(F_rtr == 1);
    End_of_File = 1'b1;
    wait(F_rtr == 0);
    End_of_File = 1'b0;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);

   // --- Fine test Start bloccato

  
    // --- inizio test su ritardo ----
     rst_n = 1'b0;
    $display("Test di Esecuzione con Ritardo");
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;
    #(CLK_PERIOD * 5);
    rst_n = 1'b1; // Rilascia il reset
    start = 1'b0;
    
    // --- Inizio del Test ---
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;
    rst_n = 1'b1; 
    
    $display("Ritardo: %0d", ritardo);

    for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1) 
      if(i == ritardo)
      begin
       #(CLK_PERIOD*500);
       @(posedge clk);
      end
      F_dr        = 1'b1;
      wait(F_rtr == 1);     
      Byte        = test[i];      

      @(posedge clk);
      
      F_dr = 1'b0;
      wait(F_rtr == 0);


     
    end
    wait(F_rtr == 1);
    End_of_File = 1'b1;
    wait(F_rtr == 0);
    End_of_File = 1'b0;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);



   // --- Inizio test Valore vuoto;

    test = ""; 

    rst_n = 1'b0;
    $display("Test valore vuoto");
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;
    #(CLK_PERIOD * 5);
    rst_n = 1'b1; // Rilascia il reset
    start = 1'b0;
    
   
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;

     for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1) 
      F_dr        = 1'b1;
      wait(F_rtr == 1);     
      Byte        = test[i];     

      @(posedge clk);
      
      F_dr = 1'b0;
      wait(F_rtr == 0);

      if(i == test_start)
        begin
          start = 1'b1;
          @(posedge clk);
          start = 1'b0;
        end
      
     
    end
    wait(F_rtr == 1);
    End_of_File = 1'b1;
    wait(F_rtr == 0);
    End_of_File = 1'b0;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);
    // -----  Fine test valore vuoto ---- 

    $stop;
  end

endmodule