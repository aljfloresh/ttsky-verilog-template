`timescale 1ns / 1ps
`default_nettype none

module tt_um_UART (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    localparam integer CLOCK_HZ  = 66_000_000;
    localparam integer BAUD_RATE = 9600;

    wire       rx_trigger;
    wire [7:0] internal_data;

    wire       fir_trigger;
    wire [7:0] final_data;

    wire       uart_tx;
    wire [3:0] count;
    wire       finished;
    wire       fir_input_valid;
    
    reg uart_rx_meta;
    reg uart_rx_sync;

 assign uo_out[0]   = uart_tx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uart_rx_meta <= 1'b1;
            uart_rx_sync <= 1'b1;
        end
        else begin
            uart_rx_meta <= ui_in[0];
            uart_rx_sync <= uart_rx_meta;
        end
    end

    UART_RX #(
        .CLOCK_HZ  (CLOCK_HZ),
        .BAUD_RATE (BAUD_RATE)
    ) my_RX (
        .data_in  (uart_rx_sync),
        .clk      (clk),
        .rst_n    (rst_n),
        .data_out (internal_data),
        .trigger  (rx_trigger)
    );

    input_counter my_counter (
        .clk        (clk),
        .rst_n      (rst_n),
        .rx_trigger (rx_trigger),
        .count      (count),
        .finished   (finished)
    );

    assign fir_input_valid = rx_trigger && !finished;

    _3tap_fir my_FIR (
        .count      (count),
        .user_in    (internal_data),
        .rx_trigger (fir_input_valid),
        .final_out      (final_data),
        .trigger    (fir_trigger),
        .clk        (clk),
        .rst_n      (rst_n)
    );

    UART_TX #(
        .CLOCK_HZ  (CLOCK_HZ),
        .BAUD_RATE (BAUD_RATE)
    ) my_TX (
        .clk     (clk),
        .rst_n   (rst_n),
        .data    (final_data),
        .trigger (fir_trigger),
        .test    (uart_tx)
    );

   
    assign uo_out[7:1] = 7'b0000000;

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;



    wire _unused = &{
        ena,
        ui_in[7:1],
        uio_in,
        1'b0
    };
    
endmodule

`default_nettype wire
