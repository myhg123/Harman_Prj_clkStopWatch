
`timescale 1ns / 1ps

module prjClock (
    input        clk,
    input        reset,
    input        selMode,
    input        minSet,
    input        secSet,
    output [6:0] minData,
    output [6:0] secData
);
    wire w_clk_1hz;

    clkDiv #(
        .MAX_COUNT(100_000_000)
        // .MAX_COUNT(10)
    ) U_ClkDiv (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_1hz)
    );

    clock U_CLOCK (
        .clk(clk),
        .reset(reset),
        .tick(w_clk_1hz),
        .selMode(selMode),
        .minSet(minSet),
        .secSet(secSet),
        .minData(minData),
        .secData(secData)
    );

endmodule

module clock (
    input        clk,
    input        reset,
    input        tick,
    input        selMode,
    input        minSet,
    input        secSet,
    output [6:0] minData,
    output [6:0] secData
);

    reg [6:0] count_min;
    reg [6:0] count_sec;


    assign minData = count_min;
    assign secData = count_sec;

    always @(posedge tick, posedge minSet, posedge secSet, posedge reset) begin
        if (reset) begin
            count_min <= 0;
            count_sec <= 0;
        end else if (minSet && !selMode) count_min <= count_min + 1;
        else if (secSet && !selMode) count_sec <= count_sec + 1;
        else begin
            if (count_min > 58) begin
                count_min <= 0;
            end else begin
                if (count_sec > 58) begin
                    count_sec <= 0;
                    count_min <= count_min + 1;
                end else begin
                    count_sec <= count_sec + 1;
                end
            end
        end
    end


    ila_0 U_ila (
        .clk(clk),  // input wire clk


        .probe0(minSet),  // input wire [0:0]  probe0  
        .probe1(secSet),  // input wire [0:0]  probe1 
        .probe2(count_min),  // input wire [6:0]  probe2 
        .probe3(count_sec)  // input wire [6:0]  probe3
    );

endmodule

