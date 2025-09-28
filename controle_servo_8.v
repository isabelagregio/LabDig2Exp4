module controle_servo_8 (
 input wire clock,
 input wire reset,
 input wire [2:0] posicao,
 output wire controle,
 output wire db_controle, // pwm gerado pra depuração
 output wire [2:0] db_posicao
);

wire pwm1, pwm2;
assign controle = posicao[2] ? pwm2 : pwm1;
assign db_controle = controle;

circuito_pwm #(           
    .conf_periodo(1000000), 
    .largura_00  (35000),    
    .largura_01  (45700),   
    .largura_10  (56450),  
    .largura_11  (67150)   
) PWM_1 (
    .clock   (clock  ),
    .reset   (reset  ),
    .largura (posicao[1:0]),
    .pwm     (pwm1   ),
    .db_pwm  (   )
);

circuito_pwm #(           
    .conf_periodo(1000000),
    .largura_00  (77850),    
    .largura_01  (88550),  
    .largura_10  (99300),    
    .largura_11  (110000)   
) PWM_2 (
    .clock   (clock  ),
    .reset   (reset  ),
    .largura (posicao[1:0]),
    .pwm     (pwm2   ),
    .db_pwm  (   )
);

endmodule