module exp5_fd #(
    parameter TIME = 100_000_000
) (
    input clock,
    input reset,
    input medir,
    input echo,
    input partida_serial,
    input zera,
    input conta_ascii,
    input conta_angulo,
    input conta_timeout_echo,
    output fim_serial,
    output trigger,
    output saida_serial,
    output pronto_medida,
    output pronto_transmissao,
    output [11:0] medida,
    output pwm,
    output timeout_echo,
    output fim_posicao,
    output [2:0] dp_posicao,
    output db_pwm,
    output [6:0] db_estado_medida,
    output [6:0] db_estado_serial,
	output dois_segundos
);

    wire [6:0] dados_ascii;
    wire [11:0] s_medida;
    wire [23:0] saida_rom;
    wire [1:0] seletor;
	wire fim_dois_segundos;
    
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

    controle_servo_8 controle_servo (
        .clock(clock),
        .reset(reset),
        .posicao(posicao),
        .controle(pwm), // pwm ligado no servomotor
        .db_controle(db_pwm), // pwm gerado pra depuração
        .db_posicao(dp_posicao)
    );

     mux_8x1_n #(
        .BITS(7)
    ) mux_inst (
        .D7(7'h23),
        .D6({3'b000, s_medida[3:0]} + 7'h30),  
        .D5({3'b000, s_medida[7:4]} + 7'h30),   
        .D4({3'b000, s_medida[11:8]} + 7'h30),
        .D3(7'h2C),
        .D2(saida_rom[6:0]),  // descarte do bit mais significativo
        .D1(saida_rom[14:8]),
        .D0(saida_rom[22:16]),
        .SEL(seletor),
        .MUX_OUT(dados_ascii)
    );

    rom_angulos_8x24 rom (
        .endereco(endereco_rom), 
        .saida(saida_rom)
    );
  
    contador_m #(  // contador blocos ascii
        .M (8), 
        .N (3)
    ) contador_ascii (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera ),
        .conta   (conta_ascii),
        .Q       (seletor), 
        .fim     (fim_serial),  
        .meio    (      )
    );

    contador_m #(  // contador angulos
        .M (8), 
        .N (3)
    ) contador_angulos (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera ),
        .conta   (conta_angulo),
        .Q       (posicao), 
        .fim     (fim_posicao),  
        .meio    (      )
    );

	   
    contador_m #(   // timer de 2 segundos
        .M (TIME), 
        .N (27)
    ) contador_segundo (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera ),
        .conta   (1'b1),
        .Q       (), 
        .fim     (fim_dois_segundos),  
        .meio    (      )
    );

    contador_m #(   // timer de 200 milisegundos
        .M (10_000_000), 
        .N (24)
    ) contador_timeout_echo (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera ),
        .conta   (conta_timeout_echo),
        .Q       (), 
        .fim     (timeout_echo),  
        .meio    (      )
    );
	 
	 
	registrador_n #(
        .N(1)
    ) segundo (
        .clock  (clock    ),
        .clear  (zera),
        .enable (fim_dois_segundos),
        .D      (fim_dois_segundos),
        .Q      (dois_segundos)
    );
	 
	 
endmodule