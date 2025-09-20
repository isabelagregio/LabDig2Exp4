module exp4_trena_uc (
    input wire       clock,
    input wire       reset,
    input wire       mensurar,
    input wire       pronto_medida,
    input wire       pronto_transmissao,

    output reg       zera,
    output reg       pronto,
    output reg [1:0] seletor,
    output reg       partida,
    output reg       medir,

    output reg [3:0] db_estado 
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial       = 4'b0000;
    parameter preparacao    = 4'b0001;
    parameter mede          = 4'b0010;
    parameter envia_prim    = 4'b0011;
    parameter aguarda_prim  = 4'b0100;
    parameter envia_segu    = 4'b0101;
    parameter aguarda_seg   = 4'b0110;
    parameter envia_terc    = 4'b0111;
    parameter aguarda_terc  = 4'b1000;
    parameter envia_quart   = 4'b1001;
    parameter aguarda_quart = 4'b1010;
    parameter final         = 4'b1011;

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
            inicial: 
                begin 
                  if (mensurar) 
                      Eprox = preparacao; 
                  else 
                      Eprox = inicial;
                end
            mede: 
                begin
                  if (pronto_medida) 
                      Eprox = envia_prim;
                  else
                    Eprox = mede;
                end
            envia_prim:
                Eprox = aguarda_prim;
            aguarda_prim: 
                begin 
                  if (pronto_transmissao) 
                      Eprox = envia_segu; 
                  else 
                      Eprox = aguarda_prim;
                end
            envia_segu: 
                Eprox = aguarda_seg;
            aguarda_seg:
                begin 
                  if (pronto_transmissao) 
                      Eprox = envia_terc; 
                  else 
                      Eprox = aguarda_seg;
                end
            envia_terc: 
                Eprox = aguarda_terc;
            aguarda_terc:
                begin 
                  if (pronto_transmissao) 
                      Eprox = envia_quart; 
                  else 
                      Eprox = aguarda_terc;
                end
            envia_quart: 
                Eprox = aguarda_quart;
            aguarda_quart:
                begin 
                  if (pronto_transmissao) 
                      Eprox = final; 
                  else 
                      Eprox = aguarda_quart;
                end
            final:
                begin
                    if (mensurar)
                        Eprox = inicial;
                    else
                        Eprox = final_medida;
                end
            default: 
                Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        case (Eatual)
            zera   =  (Eatual == preparacao || Eatual == inicial) ? 1'b1 : 1'b0;
            medir  =  (Eatual == mede) ? 1'b1 : 1'b0;
            seletor = (Eatual == envia_prim) ? 2'b00 :
                      (Eatual == envia_segu) ? 2'b01 :
                      (Eatual == envia_terc) ? 2'b10 : 2'b11;
            partida = (Eatual == envia_prim || Eatual == envia_segu || Eatual == envia_terc || Eatual == envia_quart) ? 1'b1 : 1'b0;
            pronto = (Eatual == final) ? 1'b1 : 1'b0;
            default:    zera = 1'b0;
        endcase

        case (Eatual)
            inicial:       db_estado = 4'b0000;
            preparacao:    db_estado = 4'b0001;
            mede           db_estado = 4'b0010;
            envia_prim     db_estado = 4'b0011;
            aguarda_prim   db_estado = 4'b0100;
            envia_segu     db_estado = 4'b0101;
            aguarda_seg    db_estado = 4'b0110;
            envia_terc     db_estado = 4'b0111;
            aguarda_terc   db_estado = 4'b1000;
            envia_quart    db_estado = 4'b1001;
            aguarda_quart  db_estado = 4'b1010;
            final          db_estado = 4'b1011;
            default:       db_estado = 4'b1111;
        endcase
    end

endmodule
