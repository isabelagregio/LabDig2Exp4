/* --------------------------------------------------------------------------
 *  Arquivo   : exp3_sensor.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de teste do componente interface_hcsr04.v
 *              inclui componentes para dispositivos externos
 *              detector de borda e codificadores de displays de 7 segmentos
 *
 *              usar para sintetizar projeto no Intel Quartus Prime
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 *      09/09/2024  1.1     Edson Midorikawa  revisao
 * --------------------------------------------------------------------------
 */
 
module exp3_desafio (
    input wire        clock,
    input wire        reset,
    input wire        medir,
    input wire        echo,
	 input wire  [1:0] posicao,
    output wire       trigger,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire       pronto,
    output wire       db_medir,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] db_estado,
	 output wire       controle,
    output wire       db_controle
);

    // Sinais internos
    wire        s_medir  ;
    wire        s_trigger;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;

    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .medir    (s_medir  ),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida ),
        .pronto   (pronto   ),
        .db_estado(s_estado )
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_medida[3:0]), 
        .display(hex0         )
    );
    hexa7seg H1 (
        .hexa   (s_medida[7:4]), 
        .display(hex1         )
    );
    hexa7seg H2 (
        .hexa   (s_medida[11:8]), 
        .display(hex2          )
    );

    // Trata entrada medir (considerando borda de subida)
    edge_detector DB (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(medir  ), 
        .pulso(s_medir)
    );
	 
	 circuito_pwm #(           
    .conf_periodo(1000000), // periodo 20 ms do servomotor
    .largura_00  (0),    
    .largura_01  (50000),   // 1 ms de largura 
    .largura_10  (75000),   // 1.5 ms de largura 
    .largura_11  (100000)   // 2 ms de largura 
     ) pwm (
    .clock   (clock  ),
    .reset   (reset  ),
    .largura (posicao),
    .pwm     (controle   ),
    .db_pwm  (db_controle )
);


    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );
    assign db_echo    = echo;
    assign db_trigger = s_trigger;
    assign db_medir   = medir;

endmodule