`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 10:43:44
// Design Name: 
// Module Name: multi_fan_top
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


module multi_fan_top(
    input clk, reset_p,
    input[3:0] btn,
    input echo,
    inout dht11_data,
    output fan_motor,
    output trig,
    output led_r,
    output [3:0] com,
    output [7:0] seg_7
    );
    
    wire time_change, led_change, speed_change;
    button_cntr bcntr_timer(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(time_change));
    button_cntr bcntr_led(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_pe(led_change));
    button_cntr bcntr_speed(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(speed_change));

    wire [6:0] duty_led;
    wire [6:0] duty_s;
    wire [6:0] duty_speed;
    wire [15:0] distance_cm;
    reg duty_speed_en;
    fan_led fan_l(.clk(clk), .reset_p(reset_p), .btn(led_change),  .duty(duty_led));
    pwm_100 pwm_l(.clk(clk), .reset_p(reset_p), .duty(duty_led), .pwm_preq(10000), .pwm_100pc(led_r));
    
    fan_speed fan_s(.clk(clk), .reset_p(reset_p), .btn(speed_change), .duty(duty_s));
    pwm_100 pwm_s(.clk(clk), .reset_p(reset_p), .duty(duty_speed), .pwm_preq(100), .pwm_100pc(fan_motor));

    fan_ultrasonic fan_sr04(.clk(clk), .reset_p(reset_p), .echo(echo), .trig(trig), .distance_cm(distance_cm));
    
    always @(posedge clk or posedge reset_p) begin
      if(reset_p) duty_speed_en = 0;
      else begin
        if(distance_cm >= 20) duty_speed_en = 0;
        else duty_speed_en = 1;
      end
    end

    wire [7:0] humidity, temperature;
    fan_dht11 fan_dht(.clk(clk), .reset_p(reset_p), .dht11_data(dht11_data), .humidity(humidity), .temperature(temperature));
    
    wire [15:0] bcd_humi, bcd_tmpr;
    bin_to_dec b2d_humi(.bin({4'b0000, humidity}), .bcd(bcd_humi));
    bin_to_dec b2d_tmpr(.bin({4'b0000, temperature}), .bcd(bcd_tmpr));
    wire [15:0] value_dht11;
    assign value_dht11 = {bcd_humi[7:0], bcd_tmpr[7:0]};

    wire timer_start, start_stop;
    wire [15:0] value_timer;
    fan_timer fan_time(.clk(clk), .reset_p(reset_p), .btn(time_change), .value(value_timer), .start_stop(start_stop), .timer_start(timer_start));
    assign duty_speed = duty_speed_en ? (~start_stop ? duty_s : 0) : 0; 
    wire [15:0] value;
    assign value = ~timer_start ? value_dht11 : value_timer;
    
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(value), .com(com), .seg_7(seg_7));
    
endmodule
