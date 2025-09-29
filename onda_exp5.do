onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 20 /exp5_tb/echo_in
add wave -noupdate -height 20 /exp5_tb/ligar
add wave -noupdate -height 20 /exp5_tb/saida_serial_out
add wave -noupdate -height 20 /exp5_tb/trigger_out
add wave -noupdate -divider UC
add wave -noupdate -height 20 /exp5_tb/dut/UC/reset
add wave -noupdate -height 20 /exp5_tb/dut/UC/conta_angulo
add wave -noupdate -height 20 /exp5_tb/dut/UC/conta_timeout_echo
add wave -noupdate -height 20 /exp5_tb/dut/UC/conta_ascii
add wave -noupdate -height 20 /exp5_tb/dut/UC/fim_posicao
add wave -noupdate -height 20 /exp5_tb/dut/UC/fim_serial
add wave -noupdate -height 20 /exp5_tb/dut/UC/medir
add wave -noupdate -height 20 /exp5_tb/dut/UC/partida_serial
add wave -noupdate -height 20 /exp5_tb/dut/UC/pronto_medida
add wave -noupdate -height 20 /exp5_tb/dut/UC/pronto_transmissao
add wave -noupdate -height 20 /exp5_tb/dut/UC/timeout_echo
add wave -noupdate -divider FD
add wave -noupdate -height 20 /exp5_tb/dut/FD/dois_segundos
add wave -noupdate -height 20 /exp5_tb/dut/FD/fim_serial
add wave -noupdate -height 20 -radix hexadecimal -childformat {{{/exp5_tb/dut/FD/medida[11]} -radix unsigned} {{/exp5_tb/dut/FD/medida[10]} -radix unsigned} {{/exp5_tb/dut/FD/medida[9]} -radix unsigned} {{/exp5_tb/dut/FD/medida[8]} -radix unsigned} {{/exp5_tb/dut/FD/medida[7]} -radix unsigned} {{/exp5_tb/dut/FD/medida[6]} -radix unsigned} {{/exp5_tb/dut/FD/medida[5]} -radix unsigned} {{/exp5_tb/dut/FD/medida[4]} -radix unsigned} {{/exp5_tb/dut/FD/medida[3]} -radix unsigned} {{/exp5_tb/dut/FD/medida[2]} -radix unsigned} {{/exp5_tb/dut/FD/medida[1]} -radix unsigned} {{/exp5_tb/dut/FD/medida[0]} -radix unsigned}} -subitemconfig {{/exp5_tb/dut/FD/medida[11]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[10]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[9]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[8]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[7]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[6]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[5]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[4]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[3]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[2]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[1]} {-height 15 -radix unsigned} {/exp5_tb/dut/FD/medida[0]} {-height 15 -radix unsigned}} /exp5_tb/dut/FD/medida
add wave -noupdate -height 20 /exp5_tb/dut/FD/partida_serial
add wave -noupdate -height 20 -radix unsigned /exp5_tb/dut/FD/posicao_angulo
add wave -noupdate -height 20 /exp5_tb/dut/FD/pronto_medida
add wave -noupdate -height 20 /exp5_tb/dut/FD/pronto_transmissao
add wave -noupdate -height 20 /exp5_tb/dut/FD/pwm
add wave -noupdate -height 20 -radix hexadecimal /exp5_tb/dut/FD/s_medida
add wave -noupdate -height 20 -radix binary /exp5_tb/dut/FD/saida_serial
add wave -noupdate -height 20 -radix hexadecimal /exp5_tb/dut/FD/seletor
add wave -noupdate -radix hexadecimal /exp5_tb/dut/FD/tx_serial/U1_FD/dados_ascii
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7370890 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {43793348 ns}
