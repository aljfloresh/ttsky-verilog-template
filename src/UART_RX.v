`timescale 1ns / 1ps
`default_nettype none

module UART_RX #(
    parameter integer CLOCK_HZ  = 100_000_000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire       data_in,
    input  wire       clk,
    input  wire       rst_n,
    output reg  [7:0] data_out,
    output reg        trigger
);

    localparam integer CLKS_PER_BIT = CLOCK_HZ / BAUD_RATE;
    localparam integer HALF_BIT     = CLKS_PER_BIT / 2;

    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] START = 2'b01;
    localparam [1:0] DATA  = 2'b10;
    localparam [1:0] STOP  = 2'b11;

    reg [1:0]  state;
    reg [13:0] counter;
    reg [2:0]  data_count;
    reg [7:0]  received_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            counter       <= 32'd0;
            data_count    <= 3'd0;
            received_data <= 8'd0;
            data_out      <= 8'd0;
            trigger       <= 1'b0;
        end
        else begin
            
            trigger <= 1'b0;

            case (state)

                IDLE: begin
                    counter    <= 32'd0;
                    data_count <= 3'd0;
                    
                    if (data_in == 1'b0)
                        state <= START;
                end

                START: begin
                    
                    if (counter == HALF_BIT - 1) begin
                        counter <= 32'd0;

                        if (data_in == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                    else begin
                        counter <= counter + 32'd1;
                    end
                end

                DATA: begin
                    
                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 32'd0;
                        received_data[data_count] <= data_in;

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
                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 32'd0;
                        
                        if (data_in == 1'b1) begin
                            data_out <= received_data;
                            trigger  <= 1'b1;
                        end

                        state <= IDLE;
                    end
                    else begin
                        counter <= counter + 32'd1;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule

`default_nettype wire