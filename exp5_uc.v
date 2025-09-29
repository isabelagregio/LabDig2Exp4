module exp5_uc (
		 input wire       clock,
		 input wire       reset,
		 input wire       ligar,
		 input wire       pronto_medida,
		 input wire       pronto_transmissao,
		 input wire       fim_serial,
		 input wire 		 dois_segundos,
		 input wire       timeout_echo,
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
    parameter inicial       								= 3'd0;
    parameter envia_trigger_medida    					= 3'd1;
    parameter aguarda_medida 								= 3'd2;
    parameter inicia_transmissao_serial         	= 3'd3;
    parameter transmite     								= 3'd4;
    parameter conta         								= 3'd5;
	 parameter gira 			 								= 3'd6;
    parameter final         								= 3'd7;

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
            inicial: Eprox = envia_trigger_medida;
            envia_trigger_medida: Eprox = aguarda_medida;
            aguarda_medida: Eprox = timeout_echo ? envia_trigger_medida : (pronto_medida ? inicia_transmissao_serial : aguarda_medida) ;
            inicia_transmissao_serial: Eprox = transmite;
            transmite: Eprox = pronto_transmissao ? (fim_serial ? final : conta) : transmite;
            conta: Eprox = inicia_transmissao_serial; // passa para prox bloco de dados
            gira: Eprox = envia_trigger_medida; // se estava no ultimo angulo volta para o primeiro
            final: Eprox = (dois_segundos && ligar) ? gira : final;
            default: Eprox = inicial;
        endcase
    end

    // Saídas de controle
    assign zera        = (Eatual == envia_trigger_medida) | (Eatual == inicial);
    assign medir       = (Eatual == envia_trigger_medida);
    assign conta_timeout_echo = (Eatual == aguarda_medida);
    assign conta_ascii = (Eatual == conta);
    assign conta_angulo = (Eatual == gira);
    assign partida_serial  = (Eatual == inicia_transmissao_serial);

    // Lógica para o display do estado atual (apenas para simulação/depuração)
    always @(*) begin
        case (Eatual)
          inicial:          				db_estado = inicial;
          envia_trigger_medida:       	db_estado = envia_trigger_medida;
          aguarda_medida:   				db_estado = aguarda_medida;
          inicia_transmissao_serial:   db_estado = inicia_transmissao_serial;
          transmite:        				db_estado = transmite;
          conta:            				db_estado = conta;
          gira:             				db_estado = gira;
          final:            				db_estado = final;
          default:          				db_estado = 3'd0;
        endcase
    end

endmodule
