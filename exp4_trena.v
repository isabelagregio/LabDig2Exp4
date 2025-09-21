module exp4_trena (
    input clock,
    input reset,
    input mensurar,
    input echo,
    output trigger,
    output saida_serial,
    output [6:0] medida0,
    output [6:0] medida1,
    output [6:0] medida2,
    output pronto,
    output [6:0] db_estado
);

  wire medir, partida_serial, pronto_medida, pronto_transmissao;
  wire [1:0] seletor;
  wire [11:0] medida;
  wire [3:0] db_estado_bin;

  exp4_trena_fd FD (
    .clock(clock),
    .reset(reset),
    .medir(medir),
    .echo(echo),
    .partida_serial(partida_serial),
    .trigger(trigger),
    .conta_ascii(conta_ascii),
    .zera(zera),
    .fim_serial(fim_serial),
    .saida_serial(saida_serial),
    .pronto_medida(pronto_medida),
    .pronto_transmissao(pronto_transmissao),
    .medida(medida),
    .db_estado_medida(),
    .db_estado_serial()
);

  exp4_trena_uc UC (
    .clock(clock),
    .reset(reset),
    .mensurar(mensurar),
    .pronto_medida(pronto_medida),
    .pronto_transmissao(pronto_transmissao),
    .fim_serial(fim_serial),
    .conta_ascii(conta_ascii),
    .zera(zera),
    .pronto(pronto),
    .partida(partida_serial),
    .medir(medir),
    .db_estado(db_estado_bin) 
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

endmodule; 
