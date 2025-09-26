`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: iist
// Engineer: daksh vaishnav
// 
// Create Date: 09/21/2025 09:32:42 AM
// Design Name: calculator
// Module Name: calaculator
// Project Name: practice_2
// Target Devices: xc7a35tcpg236
// Tool Versions: 2025.1
// Description: only for practice
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk, rst,
    input [1:0] op, 
    input [3:0] a,
    input [3:0] b,
    output  [6:0] seg,
    output  [3:0] an,
    output [3:0] led_a,      
    output [3:0] led_b,
    output [1:0] led_op,
    output led_clk,
    input enable,
    output wire serial_tx
);
    wire [7:0] result;  
    wire [7:0] ascii_data;
    assign led_a = a;
    assign led_b = b;
    assign led_op = op;
    assign led_clk = clk;  
    
    calaculator calc (.clk(clk), .rst(rst), .op(op), .a(a), .b(b), .result(result));
    seven_seg_driver driver (.data(result), .seg(seg), .an(an), .rst(rst), .clk(clk));
    binary_to_ascii converter (
        .binary_in(result),
        .ascii_out(ascii_data)
    );
    
    transmitter uart_tx (
        .clk(clk),  
        .rst(rst),
        .enable(enable),
        .data(ascii_data),  // Send ASCII now
        .tx(serial_tx)
    );
endmodule

module calaculator(
input clk, rst , input [1:0] op, input [3:0] a,input [3:0] b, output reg [7:0] result 
    );
    wire [4:0] temp;
    wire [7:0] product;
    
    adder_4bit add (.a(a), .b(b), .cin(1'b0), .sum(temp[3:0]), .cout(temp[4]));
    multiply mul (.a(a),.b(b),.product(product));
    always @(posedge clk)begin
    if (rst) begin
        result<=8'b0;
    end
    else begin
        case(op)
            2'b00 : result <= {3'b000, temp} ;
            2'b01 :result <= {4'b0000, a - b} ;
            2'b10 : result <= product;
                            2'b11 : begin                     
                    if (b == 0) begin
                        result <= 8'b11111111;        
                    end else begin
                        result <= {4'b0000, a / b};      
                    end
                end
            default : result <= {3'b000, temp};
        endcase
        end
    end
endmodule

module full_adder(
    input a, b, cin,
    output sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin, 
    output [3:0] sum,
    output cout
);
    wire [3:0] c;
   
    full_adder fa0(.a(a[0]), .b(b[0]), .cin(cin),  .sum(sum[0]), .cout(c[0]));
    full_adder fa1(.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
    full_adder fa2(.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
    full_adder fa3(.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(cout));
endmodule


module multiply(input [3:0] a ,b ,output [7:0] product);
    wire [3:0] pp0 = a &{4{b[0]}};
    wire [3:0] pp1 = a & {4{b[1]}};
    wire [3:0] pp2 = a & {4{b[2]}};
    wire [3:0] pp3 = a & {4{b[3]}};
    assign product = pp0 + (pp1 << 1) + (pp2 << 2) + (pp3 << 3);
endmodule

module seven_seg_driver (input [7:0] data, output reg [6:0] seg , output reg [3:0] an ,input wire rst, input wire clk);
    wire [1:0] an_sel;
    reg [15:0]counter = 0 ;
    reg [3:0] digit ;
    wire [3:0] hundreds = data / 100;
    wire [3:0] tens = (data / 10) % 10;
    wire [3:0] units = data % 10;
    localparam zero  = 7'b1000000;
    localparam one   = 7'b1111001; 
    localparam two   = 7'b0100100; 
    localparam three = 7'b0110000; 
    localparam four  = 7'b0011001; 
    localparam five  = 7'b0010010; 
    localparam six   = 7'b0000010; 
    localparam seven = 7'b1111000; 
    localparam eight = 7'b0000000; 
    localparam nine  = 7'b0010000; 
    always @(posedge clk)begin
        if (rst) begin 
            counter <=0;
        end
        else begin
        counter <= counter + 1;
        end  
    end
    assign an_sel = counter [15:14];
    always @(*)begin
        case (an_sel)
            2'b00 : begin
                        an = 4'b1110;
                        digit = units;
                    end
            2'b01 : begin 
                        an = 4'b1101;
                        digit = tens;
                    end
            2'b10 : begin 
                        an = 4'b1011;
                        digit = hundreds;
                    end
            default : begin an  = 4'b1111;
                            digit = 4'b0;
                       end
        endcase
        case (digit)
            4'd0: seg = zero;
            4'd1: seg = one;
            4'd2: seg = two;
            4'd3: seg = three;
            4'd4: seg = four;
            4'd5: seg = five;
            4'd6: seg = six;
            4'd7: seg = seven;
            4'd8: seg = eight;
            4'd9: seg = nine;
            default : seg = 7'b1111111;
        endcase
        end
endmodule

module transmitter(
    input clk,
    input rst,
    input enable,
    input [7:0] data,
    output reg tx
);

reg [3:0] bit_counter;
reg [13:0] counter;
reg state;
reg [9:0] shift_reg;

localparam BAUD_COUNT = 14'd10417;

always @(posedge clk) begin
    if (rst) begin
        state <= 0;
        counter <= 0;
        bit_counter <= 0;
        shift_reg <= 10'h3FF;
        tx <= 1'b1;
    end else begin
        case (state)
            0: begin
                tx <= 1'b1;
                if (enable) begin
                    state <= 1;
                    shift_reg <= {1'b1, data, 1'b0};
                    bit_counter <= 0;
                    counter <= 0;
                end
            end

            1: begin
                counter <= counter + 1;

                if (counter >= BAUD_COUNT) begin
                    counter <= 0;

                    if (bit_counter >= 10) begin
                        state <= 0;
                        tx <= 1'b1;
                    end else begin
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_counter <= bit_counter + 1;
                    end
                end
            end

            default: state <= 0;
        endcase
    end
end

endmodule


module binary_to_ascii(
    input [7:0] binary_in,
    output reg [7:0] ascii_out
);
    wire [3:0] hundreds = binary_in / 100;
    wire [3:0] tens = (binary_in / 10) % 10;
    wire [3:0] units = binary_in % 10;

    always @(*) begin
        ascii_out = 8'h30 + units;
    end
endmodule
