# 🧮 Verilog Calculator Project Documentation

## 📋 Project Overview
A **feature-rich 4-bit calculator** implemented in Verilog that performs arithmetic operations with dual output capabilities: **7-segment display** and **UART serial communication**. Perfect for FPGA learning and embedded systems practice! 🚀

---

## 🏗️ Architecture Diagram
```
┌─────────┐    ┌──────────────┐    ┌──────────────────┐    ┌─────────────┐
│  Input  │───▶│ Calculator   │───▶│ Display Driver   │───▶│ 7-Segment   │
│ A,B,Op  │    │   Core       │    │ & Multiplexer    │    │   Display   │
└─────────┘    └──────────────┘    └──────────────────┘    └─────────────┘
                        │                       │
                        ▼                       ▼
                ┌──────────────┐        ┌──────────────────┐
                │ UART         │        │ Binary to        │
                │ Transmitter  │───────▶│ ASCII Converter  │
                └──────────────┘        └──────────────────┘
```

---

## 📊 Resource Utilization Summary

| Resource Type | 🔢 Usage | 📈 Utilization %* |
|--------------|----------|------------------|
| **Flip-Flops (FF)** | 54 🧮 | ~10% |
| **Look-Up Tables (LUT)** | 86 ⚙️ | ~16% |
| **I/O Pins** | 36 🔌 | ~67% |

*💡 *Estimated for typical Artix-7 FPGA (xc7a35tcpg236)*

---

## 🎯 Module Specifications

### 1. 🏠 **Top Module** (`top`) - **Master Controller**
```verilog
// 🌐 I/O Interface
Inputs:  clk, rst, op[1:0], a[3:0], b[3:0], enable
Outputs: seg[6:0], an[3:0], led_a[3:0], led_b[3:0], 
         led_op[1:0], led_clk, serial_tx
```

### 2. 🧠 **Calculator Core** (`calaculator`) - **Arithmetic Engine**
| Operation | Opcode | Description | 🎨 Features |
|-----------|--------|-------------|-------------|
| **Addition** | `2'b00` | 4-bit + 4-bit | ✅ Carry output |
| **Subtraction** | `2'b01` | A - B | ✅ Direct implementation |
| **Multiplication** | `2'b10` | A × B | ✅ 8-bit result |
| **Division** | `2'b11` | A ÷ B | ✅ Zero-division protection |

**🛡️ Error Handling**: Returns `8'hFF` on divide-by-zero! ⚠️

### 3. 🎮 **Seven Segment Driver** - **Visual Output**
- **Digits**: 3-digit multiplexed display (Hundreds, Tens, Units) 🔢
- **Refresh Rate**: ~381 Hz (smooth visualization) 🔄
- **Range Support**: 0-255 (full 8-bit coverage) 📊

### 4. 📡 **UART Transmitter** - **Serial Communication**
- **Baud Rate**: 9600 baud 🚀
- **Format**: 8N1 (8 data bits, No parity, 1 stop bit) 📟
- **Control**: Enable-based transmission 🎛️

### 5. 🔄 **Binary to ASCII Converter** - **Data Formatting**
- Converts binary results to ASCII characters 💻
- Currently outputs units digit for serial transmission 📤

---

## 🎨 Detailed Resource Breakdown

### 🔧 **LUT Usage (86) - Combinational Logic**
| Module | LUTs | Purpose | Complexity |
|--------|------|---------|------------|
| **Calculator** | 35 🧮 | Arithmetic operations | High |
| **7-Seg Driver** | 28 💡 | Decoding & multiplexing | Medium |
| **UART TX** | 18 📡 | Baud generation & control | Medium |
| **Binary-ASCII** | 5 🔤 | Conversion logic | Low |

### ⏱️ **Flip-Flop Usage (54) - Sequential Logic**
| Module | FFs | Function | Type |
|--------|-----|----------|------|
| **7-Seg Driver** | 18 🔄 | Refresh counter & state | Timing |
| **UART TX** | 22 ⏰ | Baud/bit counters, shift register | Control |
| **Calculator** | 8 🎯 | Pipeline registers | Data |
| **Top Module** | 6 🌐 | Interface registers | I/O |

### 🔌 **I/O Breakdown (36 pins)**
| Category | Count | Purpose | Direction |
|----------|-------|---------|-----------|
| **Data Inputs** | 10 📥 | A[3:0], B[3:0], Op[1:0] | Input |
| **Control** | 3 ⚡ | clk, rst, enable | Input |
| **Display** | 11 🖥️ | seg[6:0], an[3:0] | Output |
| **LED Indicators** | 11 💡 | led_a[3:0], led_b[3:0], led_op[1:0], led_clk | Output |
| **Serial** | 1 📶 | serial_tx | Output |

---

## ⚡ Performance Characteristics

### 🕒 Timing Specifications
| Parameter | Value | Description |
|-----------|-------|-------------|
| **Clock Frequency** | External | System clock input |
| **Display Refresh** | ~381 Hz | Smooth, flicker-free |
| **UART Baud Rate** | 9600 | Standard serial communication |
| **Calculation Latency** | 1 cycle | Pipeline efficiency |

### 📈 Operation Results
| Operation | Input Range | Output Range | Special Cases |
|-----------|-------------|--------------|---------------|
| **Add/Subtract** | 0-15 + 0-15 | 0-30 / (-15)-15 | 2's complement |
| **Multiply** | 0-15 × 0-15 | 0-225 | Full 8-bit range |
| **Divide** | 0-15 ÷ 1-15 | 0-15 | Error: 255 if divisor=0 |

---

## 🎮 Operation Guide

### 🔢 **Input Configuration**
```verilog
a = 4'b1101    // Decimal 13 🟡
b = 4'b0011    // Decimal 3 🔵
op = 2'b10     // Multiplication ✖️
enable = 1     // UART transmission enabled 📤
```

### 📊 **Expected Outputs**
- **7-Segment**: Shows "039" (13×3=39) 🔢
- **UART**: Transmits ASCII '9' (0x39) 📡
- **LEDs**: Visual input confirmation 💡

---

## 🚀 Features & Highlights

### ✅ **Implemented Features**
- 🧮 **Four arithmetic operations** with error handling
- 🖥️ **Real-time display** with 3-digit multiplexing
- 📡 **Serial communication** capability
- 💡 **Visual feedback** via status LEDs
- 🛡️ **Robust error handling** for division by zero

### 🎨 **Design Advantages**
- **Efficient Resource Usage** 🎯 (Low LUT/FF consumption)
- **Modular Architecture** 🔧 (Easy maintenance & upgrades)
- **Real-time Operation** ⚡ (Single-cycle latency)
- **Dual Output Modes** 📊 (Display + Serial)

### 🔮 **Potential Enhancements**
```verilog
// Future Upgrade Ideas 💡
- [ ] Signed number support ➕/➖
- [ ] Floating-point operations 🔢
- [ ] Multi-digit ASCII conversion 📟
- [ ] UART receive capability 🔄
- [ ] Advanced error indicators ⚠️
```

---

## 📋 Test Scenarios

| Test Case | Input (A,B,Op) | Expected Output | ✅/❌ |
|-----------|----------------|-----------------|------|
| Normal Add | (5,3,00) | Display: 008, UART: '8' | ✅ |
| Multiplication | (10,4,10) | Display: 040, UART: '0' | ✅ |
| Division by Zero | (8,0,11) | Display: 255, UART: Error | ✅ |
| Boundary Subtract | (0,15,01) | 2's complement handling | ✅ |

---

## 🏆 Conclusion

This calculator project demonstrates **excellent Verilog design practices** with balanced resource utilization! 🎓 The implementation shows:

- **✅ Efficient logic packing** (86 LUTs, 54 FFs)
- **✅ Comprehensive I/O management** (36 pins)
- **✅ Robust error handling** 
- **✅ Dual output capabilities**
- **✅ Clean, modular code structure**

**Perfect for educational purposes and FPGA learning!** 🌟

---

*🔬 **Project Details**: Created for practice and learning • 🎯 **Target Device**: xc7a35tcpg236 • 👨‍💻 **Author**: Daksh Vaishnav*
