
`timescale 1ns/1ns

module exp5_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         ligar = 0;
    reg         echo_in = 0;
    wire        trigger_out, saida_serial_out, fim_posicao_out, pwm_out;

    // Componente a ser testado (Device Under Test -- DUT)
    exp5 #(
        .TIME(10_000)
    ) dut (
        .clock(clock_in),
        .reset(reset_in),
        .ligar(ligar),
        .echo(echo_in),
        .trigger(trigger_out),
        .pwm(pwm_out),
        .saida_serial(saida_serial_out),
        .fim_posicao(fim_posicao_out)
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste [0:7]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio das simulacoes");

        // Inicialização do array de casos de teste
        casos_teste[0] = 5882;   // 5882us (100cm)
        casos_teste[1] = 5899;   // 5899us (100,29cm) truncar para 100cm
        casos_teste[2] = 4353;   // 4353us (74cm)
        casos_teste[3] = 4399;   // 4399us (74,79cm) arredondar para 75cm
        casos_teste[4] = 5882;   // 5882us (100cm)
        casos_teste[5] = 5899;   // 5899us (100,29cm) truncar para 100cm
        casos_teste[6] = 4353;   // 4353us (74cm)
        casos_teste[7] = 4399;   // 4399us (74,79cm) arredondar para 75cm

        // Valores iniciais
        ligar = 0;
        echo_in  = 0;

        // Reset
        caso = 0; 
        #(2*clockPeriod);
        reset_in = 1;
        #(2_000); // 2 us
        reset_in = 0;
        @(negedge clock_in);

        ligar = 1;

        // Espera de 100us
        #(100_000); // 100 us


        // Loop pelos casos de teste
        for (caso = 1; caso < 8; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso-1]);
            larguraPulso = casos_teste[caso-1]*1000; // 1us=1000

            // 3) Espera por 400us (tempo entre trigger e echo)
            #(400_000); // 400 us

            // 4) Gera pulso de echo
            echo_in = 1;
            #(larguraPulso);
            echo_in = 0;

            // 5) Espera final da medida
            wait (fim_posicao_out == 1'b1);
            $display("Fim do caso %0d", caso);

            // 6) Espera entre casos de teste
            #(100_000); // 100 us
        end

        ligar = 0;

        // Espera de 100us
        #(100_000); // 100 us

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end

endmodule
