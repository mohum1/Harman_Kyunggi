`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 11:41:45
// Design Name: 
// Module Name: fan_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fan_led(
    input clk, reset_p,
    input btn,
    output led_r
    );
    // duty 0 30 60 90
    
    wire [3:0] count_btn;
    fan_ring_counter ring_led(.clk(clk), .reset_p(reset_p), .btn(btn), .ring(count_btn));
    reg [6:0] duty;

    always @(posedge clk) begin
        case(count_btn)
            4'b0001: begin
                duty = 0;
            end
            4'b0010: begin
                duty = 30;
            end
            4'b0100: begin
                duty = 60;
            end
            4'b1000: begin
                duty = 90;
            end
        endcase
    end
    
    pwm_100 pwm_l(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm_preq(10000), .pwm_100pc(led_r));

    
    
endmodule
