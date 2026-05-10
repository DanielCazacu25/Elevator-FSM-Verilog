`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 06:37:36 PM
// Design Name: 
// Module Name: Elevator_tb
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


module Elevator_tb;
    reg clk, rst, b_p;
    reg [2:0] c_f,t_f;
    wire motor, dir, d_o;

    Elevator TEST(.clk(clk)
                 ,.rst(rst)
                 ,.button_pressed(b_p)
                 ,.current_floor(c_f)
                 ,.target_floor(t_f)
                 ,.motor(motor)
                 ,.direction(dir)
                 ,.door_open(d_o));
    
    always #5 clk = ~clk;

    initial begin
        {clk,rst,b_p,c_f,t_f} = 0;
        @(negedge clk) rst = 1'b1;
        @(negedge clk) rst = 1'b0;
        c_f = 3'd3;
        t_f = 3'd0;
        b_p = 1'b1;
        wait(d_o == 1'b1)
        
        $display("At the time (%0t) the doors opent at the floor: %d", $time, c_f);
        
        @(negedge clk) b_p = 0;

        wait(motor == 1'b1 && dir == 1'b0);

        $display("At the time (%0t) the elevator started going the the floor:%d",$time, t_f);

        repeat(3) begin
            #50;
            c_f = c_f - 1'b1;
            $display("The current floor is: %d",c_f);
        end

        #1000;
        $finish;
    end
endmodule
