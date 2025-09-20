module exp4_trena_fd #(
    input clock,
    input reset,
    input mensurar,
    input echo,
    input seletor,
    input partida,
    output trigger,
    output saida_serial,
    output pronto_medida,
    output pronto_transmissao,
    output [6:0] db_estado_medida
    output [6:0] db_estado_serial
);

    wire [6:0] dados_ascii;
    wire [11:0] s_medida;

    tx_serial_7E1 tx_serial (
       .clock(clock),
       .reset(reset),
       .partida(partida), 
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
        .medir(mensurar),
        .echo(echo),
        .trigger(trigger),
        .medida(s_medida),
        .pronto(pronto_medida),
        .db_estado(db_estado_medida)
    );

     mux_4x1_n #(
        .BITS(8)
    ) mux_inst (
        .D3(7'b0010111),           
        .D2({3'b00, s_medida[11:8]}),  
        .D1({3'b00, s_medida[7:4]}),   
        .D0({3'b00, s_medida[3:0]}),
        .SEL(seletor),
        .MUX_OUT(dados_ascii)
    );

endomodule; 