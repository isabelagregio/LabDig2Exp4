module exp4_trena_fd (
    input clock,
    input reset,
    input medir,
    input echo,
    input partida_serial,
    input zera,
    input conta_ascii,
    output fim_serial,
    output trigger,
    output saida_serial,
    output pronto_medida,
    output pronto_transmissao,
    output [11:0] medida,
    output [6:0] db_estado_medida,
    output [6:0] db_estado_serial
);

    wire [6:0] dados_ascii;
    wire [11:0] s_medida;
    wire [1:0] seletor;

    assign medida = s_medida;

    tx_serial_7E1 tx_serial (
       .clock(clock),
       .reset(reset),
       .partida(partida_serial), 
       .dados_ascii(dados_ascii),
       .saida_serial(saida_serial), 
       .pronto(pronto_transmissao),
       .db_clock(), 
       .db_tick(),
       .db_partida(),
       .db_saida_serial(),
       .db_estado(db_estado_serial)   
    );

    interface_hcsr04 hcsr04(
        .clock(clock),
        .reset(reset),
        .medir(medir),
        .echo(echo),
        .trigger(trigger),
        .medida(s_medida),
        .pronto(pronto_medida),
        .db_estado(db_estado_medida)
    );

     mux_4x1_n #(
        .BITS(7)
    ) mux_inst (
        .D3(7'b0010111),
        .D2({3'b000, s_medida[11:8]} + 7'h30),  
        .D1({3'b000, s_medida[7:4]} + 7'h30),   
        .D0({3'b000, s_medida[3:0]} + 7'h30),
        .SEL(seletor),
        .MUX_OUT(dados_ascii)
    );
  
    contador_m #(
        .M (4), 
        .N (2)
    ) contador_ascii (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera ),
        .conta   (conta_ascii),
        .Q       (seletor), 
        .fim     (fim_serial),  
        .meio    (      )
    );

endmodule; 

