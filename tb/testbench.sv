// File: testbench_verilog.v
`timescale 1ns/1ps

module testbench;

  // --- Parametri di Simulazione ---
  parameter CLK_PERIOD = 10; // Periodo del clock: 10 ns (Frequenza: 100 MHz)

  // 1. --- Segnali della Testbench ---
  // Uso 'reg' per i segnali che devono essere guidati da un blocco procedurale (initial, always)
  reg           clk = 1'b0;
  reg           rst_n;
  reg           start;
  reg   [7:0]   Byte;
  reg           End_of_File;
  reg           F_dr;
  
  // Uso 'wire' per leggere le uscite dal DUT
  wire  [31:0]  R_h;
  wire          F_rtr;
  wire          H_ready;


  // registri di lavoro
  reg [31:0] test_output;
  // reg [7:0] input;
  
  // Variabile intera per i cicli
  integer i;
  

  // Memoria per contenere i dati di test
  string test = "CiaoMondo";

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
    $display("Avvio della simulazione (stile Verilog classico)...");
    clk   = 1'b0;
    rst_n = 1'b0; // Applica il reset (attivo basso)
    start = 1'b0;
    F_dr  = 1'b0;
    Byte  = 8'h00;
    End_of_File = 1'b0;

    // Mantieni il reset per alcuni cicli
    #(CLK_PERIOD * 5);
    rst_n = 1'b1; // Rilascia il reset
    $display("Tempo: %0t ns -> Reset rilasciato.", $time);
    @(posedge clk);

    // --- Inizio del Test ---
    $display("Tempo: %0t ns -> Invio del segnale di start.", $time);
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;

    // --- Invio del flusso di dati con un ciclo 'for' ---
    for (i = 0; i < test.len(); i = i + 1) begin
      // Aspetta che il DUT sia pronto a ricevere (F_rtr == 1)
      wait (F_rtr == 1);
      
      @(posedge clk);
      F_dr        = 1'b1;
      Byte        = test[i];
      

      @(posedge clk);
      F_dr = 1'b0;
      // Se è l'ultimo byte, alza il flag End_Of_File
     /* if (i == test.len()) begin
        End_Of_File = 1'b1;
      end
      
      $display("Tempo: %0t ns -> Inviando byte 0x%h (End_Of_File=%b)", $time, Byte, End_Of_File);
      
      
      // Disattiva i segnali di controllo dopo un ciclo di clock
      F_dr        = 1'b0;
      End_Of_File = 1'b0;*/
    end
    
    End_of_File = 1'b1;

    $display("Tempo: %0t ns -> Tutti i byte sono stati inviati. Attendo il risultato...", $time);
    
    wait(H_ready == 1)
    
    $display("Valore Hash finale (R_h) = 0x%h", R_h);


    // --- Fine della Simulazione ---
    #(CLK_PERIOD * 10);
    $stop;
  end

endmodule