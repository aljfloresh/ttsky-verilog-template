`timescale 1ns / 1ps
`default_nettype none

module UART_TX #(
    parameter integer CLOCK_HZ  = 100_000_000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] data,
    input  wire       trigger,
    output reg        test
);

    localparam integer CLKS_PER_BIT = CLOCK_HZ / BAUD_RATE;

    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] START = 2'b01;
    localparam [1:0] DATA  = 2'b10;
    localparam [1:0] STOP  = 2'b11;

    reg [1:0]  state;
    reg [13:0] counter;
    reg [2:0]  data_count;
    reg [7:0]  transmit_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            counter       <= 32'd0;
            data_count    <= 3'd0;
            transmit_data <= 8'd0;
            test          <= 1'b1;
        end
        else begin
            case (state)

                IDLE: begin
                    test       <= 1'b1;
                    counter    <= 32'd0;
                    data_count <= 3'd0;

                    if (trigger) begin
                        transmit_data <= data;
                        state         <= START;
                    end
                end

                START: begin
                    test <= 1'b0;

                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 32'd0;
                        state   <= DATA;
                    end
                    else begin
                        counter <= counter + 32'd1;
                    end
                end

                DATA: begin
                    test <= transmit_data[data_count];

                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 32'd0;

                        if (data_count == 3'd7) begin
                            data_count <= 3'd0;
                            state      <= STOP;
                        end
                        else begin
                            data_count <= data_count + 3'd1;
                        end
                    end
                    else begin
                        counter <= counter + 32'd1;
                    end
                end

                STOP: begin
                    test <= 1'b1;

                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 32'd0;
                        state   <= IDLE;
                    end
                    else begin
                        counter <= counter + 32'd1;
                    end
                end

                default: begin
                    state <= IDLE;
                    test  <= 1'b1;
                end

            endcase
        end
    end

endmodule

`default_nettype wire