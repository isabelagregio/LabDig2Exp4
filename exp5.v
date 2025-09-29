module exp5 #(
    parameter TIME = 100_000_000
) (
    input clock,
    input reset,
    input ligar,
    input echo,
    input [2:0] mux_debug_select,
    output trigger,
    output pwm, 
    output saida_serial,
    output fim_posicao,
    output [6:0] display0,
    output [6:0] display1,
    output [6:0] display2,
    output [6:0] display3,
    output [6:0] display4,
    output [6:0] display5
);


  wire medir, partida_serial, pronto_medida, pronto_transmissao, um_segundo, timeout_echo, conta_timeout_echo, conta_angulo, conta_ascii;
  wire zera_timeout_echo,reset_circuito, fim_serial,zera_contador_ascii;
  wire [1:0] seletor;
  wire [11:0] medida;
  wire [3:0] db_estado_bin;
  
  assign db_echo = echo;
  assign db_trigger = trigger;

  
  exp5_fd  #(
        .TIME(TIME)
    )  FD (
    .clock(clock),
    .reset(reset),
    .medir(medir),
    .echo(echo),
    .partida_serial(partida_serial),
    .trigger(trigger),
    .conta_ascii(conta_ascii),
    .conta_angulo(conta_angulo),
    .zera_timeout_echo(zera_timeout_echo),
    .zera_contador_ascii(zera_contador_ascii),
    .reset_circuito(reset_circuito),
    .conta_timeout_echo(conta_timeout_echo),
    .fim_serial(fim_serial),
    .saida_serial(saida_serial),
    .pronto_medida(pronto_medida),
    .pronto_transmissao(pronto_transmissao),
    .medida(medida),
    .pwm(pwm),
    .timeout_echo(timeout_echo),
    .db_posicao(db_posicao),
    .db_pwm(),
    .db_estado_medida(db_estado_medida),
    .db_estado_serial(db_estado_serial),
    .db_partida_serial(db_partida_serial),
    .db_conta_ascii(db_conta_ascii),
    .db_conta_timeout_echo(db_conta_timeout_echo),
    .db_conta_angulo(db_conta_angulo),
    .db_pronto_medida(db_pronto_medida),
    .db_pronto_transmissao(db_pronto_transmissao),
	.dois_segundos(dois_segundos)
  );

  exp5_uc UC (
    .clock(clock),
    .reset(reset),
    .ligar(ligar),
    .pronto_medida(pronto_medida),
    .pronto_transmissao(pronto_transmissao),
    .timeout_echo(timeout_echo),
    .fim_serial(fim_serial),
    .conta_ascii(conta_ascii),
    .conta_angulo(conta_angulo),
    .zera_timeout_echo(zera_timeout_echo),
    .zera_contador_ascii(zera_contador_ascii),
    .reset_circuito(reset_circuito),
    .partida_serial(partida_serial),
    .medir(medir),
    .db_estado(db_estado_bin),
    .fim_posicao(fim_posicao),
	.dois_segundos(dois_segundos), 
    .conta_timeout_echo(conta_timeout_echo)
  );


 // ORDEM DOS DISPLAYS: H5 - H4 - H3 - H2 - H1 - H0    | <- cresce da direita pra esquerda <-
wire [3:0] db_posicao_4bits;
assign db_posicao_4bits = {1'b0,db_posicao};
  //Depuração
wire [23:0] debug0,debug1,debug2,debug3;
wire [23:0] mux_out;

// debug0 : estado_medida | estado_serial | posicao | distancia2 | distancia1 | distancia0
assign debug0 = {db_estado_medida , db_estado_serial , db_posicao_4bits, medida[11:8] , medida[7:4] , medida[3:0]} ;

wire [3:0] db_partida_serial_4bits, db_conta_ascii_4bits, db_conta_timeout_echo_4bits, db_conta_angulo_4bits; 
wire [3:0] db_pronto_medida_4bits, db_pronto_transmissao_4bits;

assign db_partida_serial_4bits = {3'b000,db_partida_serial};
assign db_conta_ascii_4bits = {3'b000,db_conta_ascii};
assign db_conta_timeout_echo_4bits = {3'b000,db_conta_timeout_echo};
assign db_conta_angulo_4bits = {3'b000,db_conta_angulo};
assign db_pronto_medida_4bits = {3'b000,db_pronto_medida};
assign db_pronto_transmissao_4bits = {3'b000,db_pronto_transmissao};
assign debug1 = {db_partida_serial_4bits,db_conta_ascii_4bits,db_conta_timeout_echo_4bits,db_conta_angulo_4bits,db_pronto_medida_4bits,db_pronto_transmissao_4bits};

assign debug2 = 24'b0;
assign debug3 = 24'b0;
    mux_4x1_n #(
        .BITS(24)
    )  Debug (
        .D0(debug0),
        .D1(debug1),
        .D2(debug2),
        .D3(debug3),
        .SEL(mux_debug_select),
        .MUX_OUT(mux_out)
    );

    hexa7seg H0 (
      .hexa   ( mux_out[3:0] ), 
      .display( display0 )
  );
    hexa7seg H1 (
      .hexa   ( mux_out[7:4] ), 
      .display( display1 )
  );
    hexa7seg H2 (
      .hexa   ( mux_out[11:8] ), 
      .display( display2 )
  );
    hexa7seg H3(
      .hexa   ( mux_out[15:12] ), 
      .display( display3 )
  );
    hexa7seg H4 (
      .hexa   ( mux_out[19:16] ), 
      .display( display4 )
  );
    hexa7seg H5 (
      .hexa   ( mux_out[23:20] ), 
      .display( display5 )
  );

endmodule