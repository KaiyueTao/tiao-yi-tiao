//module始终产生新的坐标，更新与否取决于update模块
module create(
    input clk,rst,
    input [9:0] score,
    input [9:0] min,max,
    output [9:0] new_x,
    output reg [9:0] new_w,
    output [1:0] new_color
);
wire [9:0] x;
wire [1:0] w,color;

LFSR10bit random_x(
    .clk(clk),
    .rst(rst),
    .seed(10'b1111111111),
    .rand_num(x)
);

assign w = x[1:0];
assign color = x[3:2];

assign new_x = min + 60 + x%200;
assign new_color = color % 4;

always @(posedge clk)
begin
    if (score <= 10'd40)
        new_w <= 60;   //三种宽度 30/60/120
    else if (score <= 10'd100)
        new_w <= 10'd15<<(1 + w % 2);
    else
        new_w <= 10'd15<<(w % 3);
end
endmodule



