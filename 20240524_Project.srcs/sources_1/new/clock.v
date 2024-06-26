
`timescale 1ns / 1ps

module prjClock (
    input        clk,
    input        reset,
    input        selMode,
    input        minSet,
    input        secSet,
    input        sw_digit,
    output [6:0] clock_MSB,
    output [6:0] clock_LSB
);
    wire w_clk_100hz;
    wire [6:0] w_msecData, w_secData, w_minData, w_hourData;

    clkDiv #(
        .MAX_COUNT(1_000_000)
    ) U_ClkDiv (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_100hz)
    );

    clock U_CLOCK (
        .clk(clk),
        .reset(reset),
        .tick(w_clk_100hz),
        .selMode(selMode),
        .minSet(minSet),
        .secSet(secSet),
        .sw_digit(sw_digit),
        .msecData(w_msecData),
        .secData(w_secData),
        .minData(w_minData),
        .hourData(w_hourData)
    );

    mux2x1 U_muxMSB (
        .x0 (w_secData),
        .x1 (w_hourData),
        .sel(sw_digit),
        .y  (clock_MSB)
    );

    mux2x1 U_muxLSB (
        .x0 (w_msecData),
        .x1 (w_minData),
        .sel(sw_digit),
        .y  (clock_LSB)
    );

endmodule

module clock (
    input        clk,
    input        reset,
    input        tick,
    input        selMode,
    input        minSet,
    input        secSet,
    input        sw_digit,
    output [6:0] msecData,
    output [6:0] secData,
    output [6:0] minData,
    output [6:0] hourData
);
    localparam NONE = 0, MILISET = 1, SECSET = 2, MINSET = 3, HOURSET = 4;

    reg [2:0] state, state_next;
    reg [6:0] count_hour_reg, count_hour_next;
    reg [6:0] count_min_reg, count_min_next;
    reg [6:0] count_sec_reg, count_sec_next;
    reg [6:0] count_msec_reg, count_msec_next;

    reg btn1_reg, btn1_next;
    reg btn2_reg, btn2_next;

    assign hourData = count_hour_reg;
    assign minData  = count_min_reg;
    assign secData  = count_sec_reg;
    assign msecData = count_msec_reg;

    // State register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state          <= NONE;
            count_hour_reg <= 0;
            count_min_reg  <= 0;
            count_sec_reg  <= 0;
            count_msec_reg <= 0;
            btn1_reg       <= 0;
            btn2_reg       <= 0;
        end else begin
            state          <= state_next;
            count_hour_reg <= count_hour_next;
            count_min_reg  <= count_min_next;
            count_sec_reg  <= count_sec_next;
            count_msec_reg <= count_msec_next;
            btn1_reg       <= btn1_next;
            btn2_reg       <= btn2_next;
        end
    end

    always @(tick, minSet, secSet) begin
        state_next = state;
        count_hour_next = count_hour_reg;
        count_min_next = count_min_reg;
        count_sec_next = count_sec_reg;
        count_msec_next = count_msec_reg;
        btn1_next = minSet;
        btn2_next = secSet;

        case (state)
            NONE: begin
                if (tick) begin
                    if (count_hour_reg > 23) begin
                        count_hour_next = 0;
                    end else begin
                        if (count_min_reg > 59) begin
                            count_min_next  = 0;
                            count_hour_next = count_hour_reg + 1;
                        end else begin
                            if (count_sec_reg > 59) begin
                                count_sec_next = 0;
                                count_min_next = count_min_reg + 1;
                            end else begin
                                if (count_msec_reg > 99) begin
                                    count_msec_next = 0;
                                    count_sec_next  = count_sec_reg + 1;
                                end else begin
                                    count_msec_next = count_msec_reg + 1;
                                end
                            end
                        end
                    end
                end
                if (!selMode) begin
                    if (sw_digit) begin
                        if (minSet) state_next = HOURSET;
                        if (secSet) state_next = MINSET;
                    end else begin
                        if (minSet) state_next = SECSET;
                        if (secSet) state_next = MILISET;
                    end
                end
            end
            HOURSET: begin
                count_hour_next = count_hour_reg + 1;
                state_next = NONE;
            end
            MINSET: begin
                count_min_next = count_min_reg + 1;
                state_next = NONE;
            end
            SECSET: begin
                count_sec_next = count_sec_reg + 1;
                state_next = NONE;
            end
            MILISET: begin
                count_msec_next = count_msec_reg + 1;
                state_next = NONE;
            end
        endcase
    end
endmodule