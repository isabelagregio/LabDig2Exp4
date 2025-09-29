module exp5_uc (
    input wire       clock,
    input wire       reset,
    input wire       ligar,
    input wire       pronto_medida,
    input wire       pronto_transmissao,
    input wire       fim_serial,
	input wire 		 dois_segundos,
    input wire       timeout_echo;
    output           conta_ascii,
    output           conta_angulo,
    output           zera,
    output           partida_serial,
    output           medir,
    output           conta_timeout_echo,
    output reg [2:0] db_estado 
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial       = 3'b000;
    parameter preparacao    = 3'b001;
    parameter aguarda_medida = 3'b010;
    parameter envia         = 3'b011;
    parameter transmite     = 3'b100;
    parameter conta         = 3'b101;
    parameter final         = 3'b110;

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial: Eprox = preparacao;
            preparacao: Eprox = aguarda_medida;
            aguarda_medida: Eprox = timeout_echo ? (pronto_medida ? envia : aguarda_medida) : preparacao;
            envia: Eprox = transmite;
            transmite: Eprox = pronto_transmissao ? (fim_serial ? final : conta) : transmite;
            conta: Eprox = envia; // passa para prox bloco de dados
            gira: Eprox = preparacao; // se estava no ultimo angulo volta para o primeiro
            final: Eprox = (dois_segundos && ligar) ? gira : final;
            default: Eprox = inicial;
        endcase
    end

    // Saídas de controle
    assign zera        = (Eatual == preparacao) | (Eatual == inicial);
    assign medir       = (Eatual == preparacao);
    assign conta_timeout_echo = (Eatual == aguarda_medida);
    assign conta_ascii = (Eatual == conta);
    assign conta_angulo = (Eatual == gira);
    assign partida_serial  = (Eatual == envia);

    // Lógica para o display do estado atual (apenas para simulação/depuração)
    always @(*) begin
        case (Eatual)
          inicial:          db_estado = 3'b000;
          preparacao:       db_estado = 3'b001;
          aguarda_medida:   db_estado = 3'b010;
          envia:            db_estado = 3'b011;
          transmite:        db_estado = 3'b100;
          conta:            db_estado = 3'b101;
          gira              db_estado = 3'b110;
          final:            db_estado = 3'b111;
          default:          db_estado = 3'b111;
        endcase
    end

endmodule
