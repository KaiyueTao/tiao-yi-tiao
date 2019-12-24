`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 12:03:26
// Design Name: 
// Module Name: stagefall
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


module stagefall(
    input clk,rst,update,enable,generate_en,pulse,
    output reg [9:0] stage_y2,
    output reg fall_fin
);
always @(posedge clk)
begin
    if(generate_en) begin
        stage_y2<=500;
        fall_fin<=0;
    end
    else if(update) begin
        stage_y2<=0;
        fall_fin<=0;
    end
    else if(enable) begin
        if(pulse) begin
            if(stage_y2<500)
                stage_y2<=stage_y2+5;
            else begin
                stage_y2<=500;
                fall_fin<=1;
            end
        end
    end
    else begin
        stage_y2<=stage_y2;
        fall_fin<=0;
    end
end
endmodule
