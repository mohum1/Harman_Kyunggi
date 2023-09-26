`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 09:47:03
// Design Name: 
// Module Name: fan_timer
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


module fan_timer(
    input clk, reset_p,
    input btn,
    output [15:0] value,
    output start_stop,
    output reg timer_start
    );
    
    reg load_enable;
    wire [3:0] count_btn;
    fan_ring_counter ring_timer(.clk(clk), .reset_p(reset_p), .btn(btn), .ring(count_btn));
   
    reg [3:0] set_hour;
    wire clk_usec, clk_msec, clk_sec, clk_min;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    clock_div_1000 msec_clk(.clk(clk), .clk_source(clk_usec), .reset_p(reset_p), .clk_div_1000(clk_msec));
    clock_div_1000 sec_clk(.clk(clk), .clk_source(clk_msec), .reset_p(reset_p), .clk_div_1000(clk_sec));
    clock_min min_clk(.clk(clk), .clk_sec(clk_sec), .reset_p(reset_p), .clk_min(clk_min));
    // 시, 분 타이머 설정
    
    wire dec_clk;
    wire [3:0] hour1, hour10;
    wire [3:0] min1, min10;
    always @(posedge clk) begin
        case(count_btn)       
            4'b0001 : begin
                timer_start = 0;
                load_enable = 0;
            end
            4'b0010 : begin
                set_hour = 1;
                timer_start = 1;
                load_enable = 1;
            end
            4'b0100 : begin
                set_hour = 3;
                timer_start = 1;
                load_enable = 0;
            end
            4'b1000 : begin
                set_hour = 5;
                timer_start = 1;
                load_enable = 1;
            end
        endcase       
    end
    wire clk_start;
    wire delay_time_change;
    wire n_ed, p_ed;
    edge_detector_p load_ed(.clk(clk), .cp_in(load_enable), .reset_p(reset_p), .n_edge(n_ed), .p_edge(p_ed));
    wire loadable_ed;
    assign loadable_ed = n_ed | p_ed; 
    
    loadable_down_counter_dec_60 dc_min(.clk(clk), .reset_p(reset_p), .clk_time(clk_start), .load_enable(loadable_ed), 
    .set_value1(0), .set_value10(0), .dec1(min1), .dec10(min10), .dec_clk(dec_clk));
    loadable_down_counter_dec_60 dc_hour(.clk(clk), .reset_p(reset_p), .clk_time(dec_clk), .load_enable(loadable_ed), 
    .set_value1(set_hour), .set_value10(0), .dec1(hour1), .dec10(hour10));
    
    reg [15:0] count_time;
    assign value = timer_start ? count_time : 0;
    
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count_time = 0;
        else count_time = {hour10, hour1, min10, min1};
    end

    wire timeout_edge;
    assign timeout = |count_time;
    edge_detector_n ed_timeout(.clk(clk), .cp_in(timeout), .reset_p(reset_p), .n_edge(timeout_edge));
    assign timer_off = |{btn, reset_p};
    T_flip_flop_p tff_start(.clk(clk), .t(timeout_edge), .reset_p(timer_off), .q(start_stop));
  
    assign clk_start = start_stop ? 0 : clk_sec;
     
endmodule

