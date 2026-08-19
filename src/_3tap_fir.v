`timescale 1ns / 1ps
`default_nettype none

module _3tap_fir (
    input  wire [3:0] count,
    input  wire [7:0] user_in,
    input  wire       rx_trigger,
    output reg  [7:0] final,
    output reg        trigger,
    input  wire       clk,
    input  wire       rst_n
);

    reg [7:0] sample0;
    reg [7:0] sample1;
    reg [7:0] sample2;

    reg [7:0] coefficient0;
    reg [7:0] coefficient1;
    reg [7:0] coefficient2;
    
    reg       calc_pending; 

    wire [15:0] product0;
    wire [15:0] product1;
    wire [15:0] product2;

    wire [19:0] fir_sum;

    assign product0 = sample0 * coefficient0;
    assign product1 = sample1 * coefficient1;
    assign product2 = sample2 * coefficient2;

    assign fir_sum =
        {4'b0000, product0} +
        {4'b0000, product1} +
        {4'b0000, product2};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sample0      <= 8'd0;
            sample1      <= 8'd0;
            sample2      <= 8'd0;

            coefficient0 <= 8'd0;
            coefficient1 <= 8'd0;
            coefficient2 <= 8'd0;

            final        <= 8'd0;
            trigger      <= 1'b0;
            calc_pending <= 1'b0;
        end
        else begin
            
            trigger <= 1'b0; 
    
            if (rx_trigger) begin
                case (count)
                    4'd1: sample0      <= user_in;
                    4'd2: sample1      <= user_in;
                    4'd3: sample2      <= user_in;
                    4'd4: coefficient0 <= user_in;
                    4'd5: coefficient1 <= user_in;
                    4'd6: begin
                        coefficient2 <= user_in;
                        calc_pending <= 1'b1; 
                    end
                    default: ;
                endcase
            end
            
          
            if (calc_pending) begin
                calc_pending <= 1'b0;
                
                if (fir_sum > 20'd255)
                    final <= 8'd255;
                else
                    final <= fir_sum[7:0];
                    
                trigger <= 1'b1; 
            end
        end
    end

endmodule
`default_nettype wire
