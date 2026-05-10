`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 06:37:26 PM
// Design Name: 
// Module Name: Elevator
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


module Elevator(input clk, rst, button_pressed, input [2:0] current_floor, target_floor,  output reg motor, direction, door_open);
    parameter IDLE = 3'b000;
    parameter CLOSE_DOOR = 3'b001;
    parameter MOVE_UP = 3'b010;
    parameter MOVE_DOWN = 3'b011;
    parameter OPEN_DOOR = 3'b100;
    reg time_passed;
    reg [31:0] counter;

    reg [2:0] present_state, next_state;
    always @(posedge clk or posedge rst) begin
        if(rst)
            present_state <= IDLE;
        else 
            present_state <= next_state;
    end

    always @(*) begin
        case (present_state)
            IDLE: begin
                if(button_pressed == 1)
                    next_state = CLOSE_DOOR;
                else
                    next_state = IDLE;
            end
            CLOSE_DOOR:begin
                if(current_floor > target_floor)
                    next_state = MOVE_DOWN;
                else if(current_floor < target_floor)
                    next_state = MOVE_UP;
                else begin
                    next_state = OPEN_DOOR;
                end 
            end
            MOVE_UP:begin
                if(current_floor == target_floor) begin
                    next_state = OPEN_DOOR;
                end
                else
                    next_state = MOVE_UP; 
            end
            MOVE_DOWN:begin
                if(current_floor == target_floor) begin
                    next_state = OPEN_DOOR;
                end
                else
                    next_state = MOVE_DOWN; 
            end
            OPEN_DOOR:begin
                if(time_passed == 1'b1)
                    next_state = IDLE;
                else
                    next_state = OPEN_DOOR;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
            time_passed <= 0;
        end
        else begin
            if(next_state == OPEN_DOOR) begin
                 if(counter == 500_000_000 - 1) // Numaram 5 secunde, pasul e de 1ns, incepem de la 0.
                    time_passed <= 1'b1;
                else begin
                    counter <= counter + 1'b1;
                    time_passed <= 1'b0;
                end
            end
            else begin
                counter <= 0;
                time_passed <= 0;
            end
        end
    end

    always @(*) begin

        motor  = 0;
        direction = 0;
        door_open = 0;
        
        case (present_state)
            IDLE: begin
                motor  = 0;
                direction = 0;
                door_open = 1'b1; 
            end

            CLOSE_DOOR: begin
                motor  = 0;
                direction = 0;
                door_open = 0; 
            end

            MOVE_UP: begin
                motor  = 1'b1;
                direction = 1'b1;
                door_open = 0;
            end

            MOVE_DOWN: begin
                motor = 1'b1;
                direction = 0;
                door_open = 0;
            end

            OPEN_DOOR: begin
                motor  = 0;
                direction = 0;
                door_open = 1'b1; 
            end

            default: begin
                motor  = 0;
                direction = 0;
                door_open = 1;
            end
        endcase
    end
endmodule
