module exp5 (
    input clock,
    input reset,
    input ligar,
    input echo,
    output trigger,
    output pwm, 
    output saida_serial,
    output fim_posicao
);


  wire medir, partida_serial, pronto_medida, pronto_transmissao, um_segundo, timeout_echo, conta_timeout_echo;
  wire [1:0] seletor;
  wire [11:0] medida;
  wire [3:0] db_estado_bin;
  
  assign db_echo = echo;
  assign db_trigger = trigger;

  
  exp5_fd FD (
    .clock(clock),
    .reset(reset),
    .medir(medir),
    .echo(echo),
    .partida_serial(partida_serial),
    .trigger(trigger),
    .conta_ascii(conta_ascii),
    .conta_angulo(conta_angulo),
    .zera(zera),
    .conta_timeout_echo(conta_timeout_echo),
    .fim_serial(fim_serial),
    .saida_serial(saida_serial),
    .pronto_medida(pronto_medida),
    .pronto_transmissao(pronto_transmissao),
    .medida(medida),
    .pwm(pwm),
    .fim_posicao(fim_posicao),
    .timeout_echo(timeout_echo),
    .dp_posicao(),
    .db_pwm(),
    .db_estado_medida(),
    .db_estado_serial(),
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
    .zera(zera),
    .partida_serial(partida_serial),
    .medir(medir),
    .db_estado(db_estado_bin),
	.dois_segundos(dois_segundos), 
    .conta_timeout_echo(conta_timeout_echo),
  );


  hexa7seg H5 (
      .hexa   (db_estado_bin), 
      .display(db_estado)
  );
  hexa7seg H0 (
      .hexa   (medida[3:0]), 
      .display(medida0         )
  );
  hexa7seg H1 (
      .hexa   (medida[7:4]), 
      .display(medida1         )
  );
  hexa7seg H2 (
      .hexa   (medida[11:8]), 
      .display(medida2          )
  );

endmodule