
`timescale 1ns / 1ps


module Prj_ClockStopWatch (
    input clk,
    input reset,
    input btn1,
    input btn2,
    input btnM,
    input RX,
    input sw_digit,

    output TX,
    output [3:0] fndCom,
    output [7:0] fndFont,
    output [15:0] led
);
    wire w_btn1Tick, w_btn2Tick, w_selMode;
    wire [6:0] w_clockMin, w_clockSec, w_stopWatchSec, w_stopWatchMil;
    wire [6:0] w_dataMSB, w_dataLSB;
    controlUnit U_controlUnit (
        .clk  (clk),
        .reset(reset),
        .btn1 (btn1),
        .btn2 (btn2),
        .btnM (btnM),
        .rx   (RX),

        .tx(TX),
        .btn1Tick(w_btn1Tick),
        .btn2Tick(w_btn2Tick),
        .selMode(w_selMode)
    );
    stopWatch U_stopWatch (
        .clk(clk),
        .reset(reset),
        .btn_Mode(w_selMode),
        .btn1_Tick(w_btn1Tick),
        .btn2_Tick(w_btn2Tick),
        .sw_digit(sw_digit),
        .stopWatch_MSB(w_stopWatchMil),
        .stopWatch_LSB(w_stopWatchSec)
    );

    prjClock U_prjClock (
        .clk(clk),
        .reset(reset),
        .selMode(w_selMode),
        .minSet(w_btn1Tick),
        .secSet(w_btn2Tick),
        .sw_digit(sw_digit),
        .clock_MSB(w_clockMin),
        .clock_LSB(w_clockSec)
    );

 
    mux2x1 U_muxMSB (
        .x0 (w_clockMin),
        .x1 (w_stopWatchSec),
        .sel(w_selMode),
        .y  (w_dataMSB)
    );

modeLedOut U_modeLedOut(
    .selMode(w_selMode),
    .led(led)
);
    

    mux2x1 U_muxLSB (
        .x0 (w_clockSec),
        .x1 (w_stopWatchMil),
        .sel(w_selMode),
        .y  (w_dataLSB)
    );
    fndController U_fndController (
        .clk(clk),
        .reset(reset),
        .selMode(w_selMode),
        .digit1(w_dataLSB),
        .digit2(w_dataMSB),
        .fndFont(fndFont),
        .com(fndCom)
    );

endmodule


module modeLedOut (
    input selMode,
    output [15:0] led
);
    assign led = selMode ? 16'b1111111100000000 : 16'b0000000011111111;
    
endmodule