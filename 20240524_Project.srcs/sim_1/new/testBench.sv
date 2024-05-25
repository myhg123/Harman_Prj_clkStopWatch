`timescale 1ns / 1ps

module testBench ();

    reg  clk;
    reg  reset;
    reg  btn1;
    reg  btn2;
    reg  btnM;
    reg  rx;

    wire tx;
    wire btn1Tick;
    wire btn2Tick;
    wire selMode;

    controlUnit dut (
        .clk(clk),
        .reset(reset),
        .btn1(btn1),
        .btn2(btn2),
        .btnM(btnM),
        .rx(rx),

        .tx(tx),
        .btn1Tick(btn1Tick),
        .btn2Tick(btn2Tick),
        .selMode(selMode)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        btn1 = 0;
        btn2 = 0;
        btnM = 0;
        rx = 1;
    end

    initial begin
        #30 reset =0;
        #123 rx = 0 ; //start
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 0;
        #123 rx = 0;
        #123 rx = 1;
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 0;
        #123 rx = 1;//stop

        #3000 rx = 0 ; //start
        #123 rx = 0;
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 0;
        #123 rx = 1;
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 0;
        #123 rx = 1;//stop

        #3000 rx = 0 ; //start
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 1;
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 1;
        #123 rx = 1;
        #123 rx = 0;
        #123 rx = 1;//stop

        #3000 btnM = 1;
        #10 btnM = 0;

        #3000 btnM = 1;
        #10 btnM = 0;
    end



endmodule
