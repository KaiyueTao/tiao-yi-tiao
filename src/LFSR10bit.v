`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/12 23:09:46
// Design Name: 
// Module Name: LFSR10bit
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


module LFSR10bit(
    input clk,rst,
    input [9:0] seed,
    output reg [9:0] rand_num
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        rand_num<=seed;
    else begin
        rand_num[0] <= rand_num[1];
        rand_num[1] <= rand_num[2];
        rand_num[2] <= rand_num[3];
        rand_num[3] <= rand_num[4];
        rand_num[4] <= rand_num[5];
        rand_num[5] <= rand_num[6] ^ rand_num[0];
        rand_num[6] <= rand_num[7] ^ rand_num[0];
        rand_num[7] <= rand_num[8];
        rand_num[8] <= rand_num[9] ^ rand_num[0];
        rand_num[9] <= rand_num[0];
    end
end

endmodule
