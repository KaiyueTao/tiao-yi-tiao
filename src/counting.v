`timescale 1ns / 1ps
`include "parameter.v"
module counting(
    input clk, rst, c_En,
    input on_second, //是否落到第二个台子上
    input middle, //是否落到中心
    input [1:0] color, //建筑物颜色，不同颜色分�?�不�?
    output reg [9:0] score
);
reg [9:0] add;
always @(*)
begin
    case(color)
        `RED: add <= 10'd20 + {8'b0,middle,1'b0};
        `YELLOW: add <= 10'd10 + {8'b0,middle,1'b0};
        `GREEN: add <= 10'd5 + {8'b0,middle,1'b0};
        `BLUE: add <= 10'd1 + {8'b0,middle,1'b0};
        default: add <= 0;
    endcase
end

always @(posedge clk or posedge rst)
begin
    if(rst)
        score <= 0;  //分数清零
    else if(c_En) 
        if(on_second)   //在第二个台子上才加分
            score <= score + add;
        else
            score <= score;
end

endmodule





