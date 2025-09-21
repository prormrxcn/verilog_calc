## Clock signal (100MHz)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
# Clock constraint (assuming 100MHz clock)
create_clock -period 10.000 -name sys_clk_pin [get_ports clk]

# Input delay constraints for all inputs
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {a[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 1.000 [get_ports {a[*]}]

set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {b[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 1.000 [get_ports {b[*]}]

set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {op[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -min 1.000 [get_ports {op[*]}]

set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports rst]
set_input_delay -clock [get_clocks sys_clk_pin] -min 1.000 [get_ports rst]

# If you're using buttons or switches, you might want false path constraints
set_false_path -from [get_ports {a[*]}] -to [get_clocks sys_clk_pin]
set_false_path -from [get_ports {b[*]}] -to [get_clocks sys_clk_pin]
set_false_path -from [get_ports {op[*]}] -to [get_clocks sys_clk_pin]
set_false_path -from [get_ports rst] -to [get_clocks sys_clk_pin]
## Reset button (btnC - center button)
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports rst]

## Operation code inputs (switches 0-3)
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {op[0]}]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {op[1]}]


## Operand A inputs (switches 4-7)
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {a[0]}]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {a[1]}]
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {a[2]}]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {a[3]}]

## Operand B inputs (switches 8-11)
set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {b[0]}]
set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {b[1]}]
set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {b[2]}]
set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {b[3]}]

## Seven Segment Display
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]

set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an[2]}]

## Optional: LEDs to show inputs (uncomment if you want visual feedback)
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {led_a[0]}] ;# LED 0 shows a[0]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {led_a[1]}] ;# LED 1 shows a[1]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {led_a[2]}] ;# LED 2 shows a[2]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {led_a[3]}] ;# LED 3 shows a[3]

# Input B LEDs
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {led_b[0]}] ;# LED 4 shows b[0]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {led_b[1]}] ;# LED 5 shows b[1]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {led_b[2]}] ;# LED 6 shows b[2]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {led_b[3]}] ;# LED 7 shows b[3]

# Operation code LEDs (only using 2 bits)
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {led_op[0]}] ;# LED 8 shows op[0]
set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {led_op[1]}] ;# LED 9 shows op[1]
set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {led_clk}] ;

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]