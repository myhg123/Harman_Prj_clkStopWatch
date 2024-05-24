
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
    
    reg [6:0] count_min, count_min_next;
    reg [6:0] count_sec, count_sec_next;

    
    assign minData = count_min;
    assign secData = count_sec;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count_min <= 0;
            count_sec <= 0;
        end else begin
            count_min <= count_min_next;
            count_sec <= count_sec_next;
        end
    end

    always @(*) begin
        count_min_next = count_min;
        count_sec_next = count_sec;
        if (tick) begin
            if (count_min > 58) begin
                count_min_next = 0;
            end else begin
                if (count_sec > 58) begin
                    count_sec_next   = 0;
                    count_min_next = count_min + 1;
                end else begin
                    count_sec_next = count_sec + 1;
                end
            end
        end
        else if (!selMode) begin
            if (minSet) count_min_next = count_min + 1;
            else if (secSet) count_sec_next = count_sec + 1;
        end
    end
endmodule

