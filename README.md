# Calculator Project Documentation

## Overview
This Verilog project implements a 4-bit calculator with 7-segment display output and UART transmission capabilities. The design performs basic arithmetic operations (addition, subtraction, multiplication, division) and displays results on both LED segments and via serial communication.

## Project Structure

### Main Modules

#### 1. Top Module (`top`)
- **Inputs**: 
  - `clk`: System clock
  - `rst`: Reset signal
  - `op[1:0]`: Operation selector (00: add, 01: subtract, 10: multiply, 11: divide)
  - `a[3:0]`, `b[3:0]`: 4-bit operands
  - `enable`: UART transmission enable
- **Outputs**:
  - `seg[6:0]`: 7-segment display segments
  - `an[3:0]`: 7-segment display anodes
  - `led_a[3:0]`, `led_b[3:0]`: LED indicators for inputs
  - `led_op[1:0]`: LED indicators for operation
  - `led_clk`: Clock indicator LED
  - `serial_tx`: UART transmit line

#### 2. Calculator Core (`calaculator`)
Performs arithmetic operations based on the selected opcode:
- **Addition**: Uses 4-bit ripple carry adder
- **Subtraction**: Direct arithmetic operation
- **Multiplication**: Combinational multiplier using partial products
- **Division**: Includes divide-by-zero detection (returns 0xFF)

#### 3. Seven Segment Driver (`seven_seg_driver`)
- Multiplexes 3-digit display (hundreds, tens, units)
- Uses time-division multiplexing with 16-bit counter
- Supports values 0-255

#### 4. UART Transmitter (`transmitter`)
- Implements serial communication at 9600 baud (assuming 100MHz clock)
- 8N1 format (8 data bits, no parity, 1 stop bit)
- Manual enable-based transmission

#### 5. Binary to ASCII Converter (`binary_to_ascii`)
- Converts 8-bit binary result to ASCII character
- Currently outputs only units digit ASCII code

## Resource Utilization

| Resource Type | Usage |
|---------------|-------|
| **Flip-Flops (FF)** | 54 |
| **Look-Up Tables (LUT)** | 86 |
| **I/O Pins** | 36 |

### Detailed Breakdown:

- **Flip-Flops (39)**:
  - Calculator module: Pipeline registers for operations
  - Seven segment driver: 16-bit counter + state registers
  - UART transmitter: Baud counter, bit counter, shift register
  - Various state machines and data registers

- **Look-Up Tables (24)**:
  - Arithmetic logic (adder, multiplier, divider)
  - 7-segment decoding logic
  - Multiplexers and control logic
  - UART state machine and baud rate generation

- **I/O Usage**:
  - 1 clock input
  - 1 reset input
  - 2-bit operation selector
  - 8-bit data inputs (4+4)
  - 7-segment display outputs (7 segments + 4 anodes)
  - 10 LED indicators (4+4+2+1)
  - UART interface (1 output + 1 enable)

## Key Features

### Arithmetic Operations
- **Addition**: 4-bit with carry (5-bit result)
- **Subtraction**: 4-bit direct subtraction
- **Multiplication**: 4×4 bit multiplication (8-bit result)
- **Division**: Integer division with error handling

### Display System
- 3-digit 7-segment display
- Automatic digit multiplexing
- Support for values 0-255
- Error display for divide-by-zero (shows all segments)

### Communication
- UART transmission at 9600 baud
- ASCII output of calculation results
- Manual transmission control

### Error Handling
- Divide-by-zero detection returns 0xFF (255)
- Default operation fallback to addition
- Reset synchronization

## Clock and Timing
- **System Clock**: External input
- **Display Refresh**: ~381 Hz (100MHz/2^16)
- **UART Baud Rate**: 9600 baud (10417 clock cycles per bit at 100MHz)

## Operation Codes
| Opcode | Operation | Result Format |
|--------|-----------|---------------|
| 00 | Addition | {3'b000, carry, sum[3:0]} |
| 01 | Subtraction | {4'b0000, a-b} |
| 10 | Multiplication | a × b |
| 11 | Division | a ÷ b (or 0xFF if b=0) |

## Limitations
- Division result truncated to integer
- No overflow detection for addition/subtraction
- ASCII conversion only outputs units digit
- Fixed baud rate (requires 100MHz clock for 9600 baud)

## Potential Improvements
- Add overflow indicators
- Implement signed arithmetic
- Enhance ASCII conversion for multi-digit numbers
- Add receive capability for bidirectional communication
- Include parity and framing error detection

This design demonstrates efficient resource usage while providing comprehensive calculator functionality with multiple output modalities.
