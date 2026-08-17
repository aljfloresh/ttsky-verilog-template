`timescale 1ns / 1ps
`default_nettype none

module input_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx_trigger,
    output reg  [3:0] count,
    output reg        finished
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 4'd1;
            finished <= 1'b0;
        end
        else if (rx_trigger) begin
            if (count < 4'd6) begin
                count <= count + 4'd1;
            end
            else begin
                count <= 4'd1;
            end
        end
    end

endmodule

`default_nettype wire