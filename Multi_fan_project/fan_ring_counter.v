`timescale 1ns / 1ps
module fan_ring_counter(
        input clk, reset_p,
        input btn,
        output reg [3:0] ring
    );
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p) ring = 4'b0001;
        else if(btn) begin
            if(ring == 4'b0001) ring = 4'b0010;
            else if(ring == 4'b0010) ring = 4'b0100;
            else if(ring == 4'b0100) ring = 4'b1000;
            else if(ring == 4'b1000) ring = 4'b0001;
            else ring = 4'b0001;                 // 디폴트 값
        end 
    end
endmodule