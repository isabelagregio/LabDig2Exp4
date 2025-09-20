/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
	/* completar */
	 parameter inicial = 3'd0;
	 parameter waiting = 3'd1;
	 parameter medindo1Metade = 3'd2;
	 parameter zeraContadorR = 3'd3;
	 parameter medindo2Metade = 3'd4;
	 parameter conta = 3'd5;
	 parameter fim = 3'b111;

    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
				inicial:
					Eprox <= waiting;
				waiting:
				begin
					if(pulso)
						Eprox <= medindo1Metade;
					else
						Eprox <= waiting;
				end
				medindo1Metade:
				begin
					if(tick)
						Eprox <= zeraContadorR;
					else
						begin
						if (pulso)
							Eprox <= medindo1Metade;
						else
							Eprox <= fim;
						end
				end
				zeraContadorR:
					Eprox <= medindo2Metade;
				medindo2Metade:
				begin
					if (tick)
						Eprox <= conta;
					else
					begin
						if (pulso)
							Eprox <= medindo2Metade;
						else
							Eprox <= conta;
					end
				end
				conta:
				begin
					if (pulso)
						Eprox <= medindo1Metade;
					else
						Eprox <= fim;
				end
				fim:
					Eprox <= inicial;	
        endcase
	end

    // Lógica de saída (Moore)
    always @(*) begin
		zera_tick = (Eatual == zeraContadorR) || (Eatual == inicial) || (Eatual == waiting) || (Eatual == conta);
		conta_tick = (Eatual == medindo1Metade) || (Eatual == medindo2Metade);
		zera_bcd = (Eatual == inicial) || (Eatual == waiting);
		conta_bcd = (Eatual == conta);
		pronto = (Eatual == fim);
		
    end

endmodule