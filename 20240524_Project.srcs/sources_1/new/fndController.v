
`timescale 1ns / 1ps

module fndController (
    //input [13:0] digit,
    //input [1:0] sw,
    input clk,
    input reset,
    input [6:0] digit1,
    input [6:0] digit2,
    output [7:0] fndFont,
    output [3:0] com
);

    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000, w_dot;
    wire [3:0] w_digit;
    wire [2:0] w_count;
    wire w_clk_1khz;

    clkDiv #(
        .MAX_COUNT(100_000)
    ) U_ClkDiv (  // can use like parameter, not default value
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_1khz)
    );

    counter #(
        .MAX_COUNT(5)
    ) U_Counter_3bit (
        .clk  (w_clk_1khz),
        .reset(reset),
        .count(w_count)
    );

    Fndset U_Decoder_3x4 (  // 3 to 4 decoder
        .sw (w_count),
        .com(com)
    );

    digitSplitter U_DigitSplitter (
        .i_digit(digit1),
        .o_digit_1(w_digit_1),
        .o_digit_10(w_digit_10)
    );

    digitSplitter U_DigitSplitter2 (
        .i_digit(digit2),
        .o_digit_1(w_digit_100),
        .o_digit_10(w_digit_1000)
    );

    mux U_Mux_5x1 (
        .x0 (w_digit_1),
        .x1 (w_digit_10),
        .x2 (w_digit_100),
        .x3 (w_digit_1000),
        .x4 (w_dot),
        .sel(w_count),
        .y  (w_digit)
    );

    BCDtoSEG U_BcdToSeg (
        .bcd(w_digit),
        .seg(fndFont)
    );

    comparator U_Comparator (
        .value (w_clk_1khz),
        .result(w_dot)

    );

endmodule

module comparator (
    input value,
    output reg [3:0] result  // ��� �� (4��Ʈ)
);

    reg [7:0] counter;  // 8��Ʈ ī����

    always @(posedge value) begin
        counter = counter + 1;
        if(counter == 250) begin
            counter = 0;
        end
        else if(counter < 120) begin
            result = 4'b1010;  
        end
        else if(counter > 121) begin
            result = 4'b1011; 
        end
    end

endmodule



module digitSplitter (
    input  [6:0] i_digit,
    output [3:0] o_digit_1,
    output [3:0] o_digit_10
);

    assign o_digit_1 = i_digit % 10;
    assign o_digit_10 = i_digit / 10 % 10;

endmodule

module mux (
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input [3:0] x4,  // dot
    input [2:0] sel,
    output reg [3:0] y
);

    always @(*) begin  // check every variables in case
        case (sel)
            3'b000:  y = x0;
            3'b001:  y = x1;
            3'b010:  y = x2;
            3'b011:  y = x3;
            3'b100:  y = x4;
            default: y = x0;
        endcase
    end
endmodule

module mux2x1 (
    input [6:0] x0,
    input [6:0] x1,  // dot
    input sel,
    output reg [6:0] y
);

    always @(*) begin  // check every variables in case
        case (sel)
            1'b0:  y = x0;
            1'b1:  y = x1;
            default: y = x0;
        endcase
    end
endmodule

module BCDtoSEG (
    input      [3:0] bcd,
    output reg [7:0] seg
);

    always @(bcd) begin
        case (bcd)
            4'h0: seg = 8'hc0;
            4'h1: seg = 8'hf9;
            4'h2: seg = 8'ha4;
            4'h3: seg = 8'hb0;
            4'h4: seg = 8'h99;
            4'h5: seg = 8'h92;
            4'h6: seg = 8'h82;
            4'h7: seg = 8'hf8;
            4'h8: seg = 8'h80;
            4'h9: seg = 8'h90;

            4'ha: seg = 8'b01111111;
            4'hb: seg = 8'hff;

            4'hc: seg = 8'hc6;
            4'hd: seg = 8'ha1;
            4'he: seg = 8'h86;
            4'hf: seg = 8'h8e;

            default: seg = 8'hff;
        endcase
    end
endmodule

module Fndset (  // 2 to 4 decoder
    input [2:0] sw,
    output reg [3:0] com
);

    always @(sw) begin
        case (sw)
            3'h0: com = 4'he;
            3'h1: com = 4'hd;
            3'h2: com = 4'hb;
            3'h3: com = 4'h7;

            3'h4: com = 4'hb;

            default: com = 4'hf;
        endcase

    end

endmodule


module counter #(
    parameter MAX_COUNT = 4  // ������ 4
) (  // default value
    input clk,
    input reset,
    output [$clog2(MAX_COUNT) -1:0] count,
    output [5:0] min
);
    reg [$clog2(MAX_COUNT)-1:0] counter = 0;
    reg [5:0] minutes = 0;

    assign count = counter;
    assign min   = minutes;

    always @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            counter <= 0;
        end else begin

            if (counter == MAX_COUNT - 1) begin
                counter <= 0;
                minutes <= minutes + 1;
            end else begin
                counter <= counter + 1;
            end

        end
    end
endmodule

