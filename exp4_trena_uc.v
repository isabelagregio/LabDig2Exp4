module exp4_trena_uc (
    input wire       clock,
    input wire       reset,
    input wire       mensurar,
    input wire       pronto_medida,
    input wire       pronto_transmissao,
    input wire       fim_serial,
    output reg       conta_ascii,
    output reg       zera,
    output reg       pronto,
    output reg       partida,
    output reg       medir,

    output reg [2:0] db_estado 
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial       = 3'b000;
    parameter preparacao    = 3'b001;
    parameter mede          = 3'b010;
    parameter envia    = 3'b011;
    parameter aguarda  = 3'b100;
    parameter final         = 3'b101;

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
            inicial: Eprox = mensurar ? preparacao : inicial;
            mede: Eprox = pronto_medida ? envia : mede;
            envia: Eprox = aguarda;
            aguarda: Eprox = pronto_transmissao ? (fim_serial ? final : envia) : aguarda;
            final: Eprox = mensurar ? preparacao : final;
            default: Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        case (Eatual)
            zera   =  (Eatual == preparacao || Eatual == inicial) ? 1'b1 : 1'b0;
            medir  =  (Eatual == mede) ? 1'b1 : 1'b0;
            conta_ascii = (Eatual == envia) ? 1'b1 : 1'b0;
            partida = (Eatual == envia_prim || Eatual == envia_segu || Eatual == envia_terc || Eatual == envia_quart) ? 1'b1 : 1'b0;
            pronto = (Eatual == final) ? 1'b1 : 1'b0;
            default:    zera = 1'b0;
        endcase

        case (Eatual)
          inicial          db_estado = 3'b000;
          preparacao       db_estado = 3'b001;
          mede             db_estado = 3'b010;
          envia            db_estado = 3'b011;
          aguarda          db_estado = 3'b100;
          final            db_estado = 3'b101;
          default:       db_estado = 4'b111;
        endcase
    end

endmodule
