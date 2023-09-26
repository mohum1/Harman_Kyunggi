`timescale 1ns / 1ps

module fan_ultrasonic(
    input clk, reset_p,
    input echo,
    output reg trig,
    output reg [15:0] distance_cm
    );
    
    parameter S_IDLE = 4'b0001;
    parameter S_TRIG = 4'b0010;
    parameter S_WAIT_PEDGE = 4'b0100;
    parameter S_WAIT_NEDGE = 4'b1000;
    
    reg [16:0] count_usec;
    wire clk_usec;
    reg count_usec_e;        
    
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));    
    
     always @(negedge clk or posedge reset_p)begin
        if(reset_p) count_usec = 0;
        else begin
            if(clk_usec && count_usec_e) count_usec = count_usec + 1;
            else if (!count_usec_e) count_usec = 0;
        end
    end   
    wire echo_pedge, echo_nedge;
    edge_detector_p ed_start0(.clk(clk), .cp_in(echo), .reset_p(reset_p), .p_edge(echo_pedge), .n_edge(echo_nedge));   
   
    reg [5:0] state, next_state;
    always @(negedge clk or posedge reset_p)begin
        if(reset_p)state = S_IDLE;
        else state = next_state;
    end
    
    reg [16:0] temp_value [15:0];   // 17bit 16
    reg [16:0] old_usec;
    reg [20:0] sum_value;
    reg [3:0] index;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            index = 0;
            count_usec_e = 0;
            trig = 0;
            next_state = S_IDLE;
        end
        else begin
            case(state)
                S_IDLE : begin
                    if(count_usec < 17'd80) begin // 80_000
                        count_usec_e = 1;
                    end
                    else begin
                        next_state = S_TRIG;
                        count_usec_e = 0;
                    end
                end
                S_TRIG : begin
                     if(count_usec < 17'd10) begin
                        count_usec_e = 1;
                        trig = 1;
                     end
                     else begin
                        next_state = S_WAIT_PEDGE;
                        count_usec_e = 0;
                        trig = 0;
                     end
                end
                S_WAIT_PEDGE : begin
                    if(echo_pedge) begin
                        old_usec = count_usec;
                        next_state = S_WAIT_NEDGE;
                    end
                    else begin
                        if(count_usec < 17'd80_000) begin
                            count_usec_e = 1;
                            next_state = S_WAIT_PEDGE;
                        end
                        else begin
                            next_state = S_IDLE;
                            count_usec_e = 0;
                        end
                    end
                end
                S_WAIT_NEDGE : begin
                    if(echo_nedge) begin
                        temp_value[index] = count_usec - old_usec;
                        index = index + 1;
                        count_usec_e = 0;
                        next_state = S_IDLE;
                    end
                    else begin
                        if(count_usec < 17'd80_000) begin
                            count_usec_e = 1;
                            next_state = S_WAIT_NEDGE;
                        end
                        else begin
                            next_state = S_IDLE;
                            count_usec_e = 0;
                        end
                    end
                end
                default : next_state = S_IDLE;
            endcase
        end
    end
    
    reg [4:0] i;
    always @(posedge clk_usec or posedge reset_p) begin
        if(reset_p) begin
            sum_value = 0;
            i = 0;
        end
        else begin
            sum_value = 0;
            for (i = 0; i < 16; i = i + 1) begin
                sum_value = sum_value + temp_value[i];    
            end
        end    
    end
          
    always @(posedge clk_usec or posedge reset_p) begin
        if(reset_p) distance_cm = 0;
        else distance_cm = sum_value[20:4] / 58;
    end   
    
        
endmodule
