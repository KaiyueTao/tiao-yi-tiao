module display(
    input clk,rst,
    //小人的底部中心坐标，这里预先设定人的宽和高
    input [9:0] man_x,
    input [9:0] man_y,
    input [9:0] man_tall,
    //台子的坐标，同样为底部中心
    input [9:0] stage_x[0:1],
    //第二个台子的纵坐标，在falling效果时有用
    input [9:0] stage_y2,
    //台子的宽，实际上为半宽
    input [9:0] stage_w[0:1],
    //台子的颜色
    input [1:0] stage_color[0:1],
    //输入当前状态，在DEAD和START时显示图片
    input [3:0] state,  
    //VGA
    output wire VGA_HS,VGA_VS,
    output wire [3:0] VGA_R, 
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
);
parameter RED = 2'b11;    //红色
parameter YELLOW = 2'b10;   //黄色
parameter BLUE = 2'b01;  //蓝色
parameter GREEN = 2'b00;  //绿色

wire [9:0] x,y;
//rom
wire [18:0] rom_addr;  //两个rom可以共用地址
wire [2:0] rom_0_color,rom_1_color;

vga800x600 vga(
    .clk(clk),
    .rst(rst),
    .o_hs(VGA_HS),
    .o_vs(VGA_VS),
    .o_x(x),
    .o_y(y)//,
    .rom_addr(rom_addr)
);

//assign rom_addr = {8'd0,x} + {8'd0,y}*800;

//从ROM1读取图片start
blk_mem_gen_0 rom1(
    .clka(clk),
    .ena(1),
    .addra(rom_addr),
    .douta(rom_0_color)
);

//从ROM2读取图片dead
blk_mem_gen_1 rom2(
    .clka(clk),
    .addra(rom_addr),
    .douta(rom_1_color)
);

wire in_start_pic = (x>0) & (x<800) & (y>0) & (y<600);
wire in_dead_pic = (x>200) & (x<600) & (y>100) & (y<400) ;  //选定显示的范围
wire [9:0] head;
wire in_head;
wire in_body;
wire [9:0] circle_x,circle_y;
wire in_stage[1:0];  //判断当前坐标是否在人或台子内部
wire [9:0] stage_left[1:0];  //当stage - stage_w为负数时，为避免显示错误，将其设为0

assign stage_left[0] = (stage_x[0]>stage_w[0])? (stage_x[0] - stage_w[0]):0;
assign stage_left[1] = (stage_x[1]>stage_w[1])? (stage_x[1] - stage_w[1]):0;
assign circle_x = (x > man_x)? (x - man_x) : (man_x - x);
assign circle_y = (y > head)? (y - head) : (head - y);
assign head = man_y - man_tall - 15;   //人的头部纵坐标，圆心

//判断是否在内部
assign in_head = ((circle_x*circle_x + circle_y*circle_y)<100);
assign in_body = (x > (man_x - 10)) & (x < (man_x + 10)) & (y > (man_y - man_tall)) & (y < man_y);
assign in_stage[0] = (x > stage_left[0]) & (x < (stage_x[0] + stage_w[0])) & (y > 500) & (y < 600);
assign in_stage[1] = (x > stage_left[1]) & (x < (stage_x[1] + stage_w[1])) & (y > stage_y2) & (y < (stage_y2 + 100));

//根据内部赋予RGB值
//人以及四个平台不会出现重叠情况
/*
    人的颜色为白色
    当且仅当在台子内且台子颜色为该颜色时，才为真
    当然黄色由绿红组成，当color[1]==1时VGA_R都应为1，color[0]==0时VGA_G都应为1
*/
//R
assign VGA_R[3] = (state == 4'd0)? (in_start_pic & rom_0_color[2]) : (((state == 4'd7) & in_dead_pic & rom_1_color[2]) | in_head | in_body | (in_stage[0] & (stage_color[0][1] == 1)) | (in_stage[1] & (stage_color[1][1] == 1)));
assign VGA_R[2] = (state == 4'd0)? (in_start_pic & rom_0_color[2]) : (((state == 4'd7) & in_dead_pic & rom_1_color[2]) | in_head | in_body | (in_stage[0] & (stage_color[0][1] == 1)) | (in_stage[1] & (stage_color[1][1] == 1)));
assign VGA_R[1] = (state == 4'd0)? (in_start_pic & rom_0_color[2]) : (((state == 4'd7) & in_dead_pic & rom_1_color[2]) | in_head | in_body | (in_stage[0] & (stage_color[0][1] == 1)) | (in_stage[1] & (stage_color[1][1] == 1)));
assign VGA_R[0] = (state == 4'd0)? (in_start_pic & rom_0_color[2]) : (((state == 4'd7) & in_dead_pic & rom_1_color[2]) | in_head | in_body | (in_stage[0] & (stage_color[0][1] == 1)) | (in_stage[1] & (stage_color[1][1] == 1)));
//G
assign VGA_G[3] = (state == 4'd0)? (in_start_pic & rom_0_color[1]) : (((state == 4'd7) & in_dead_pic & rom_1_color[1]) | in_head | in_body);
assign VGA_G[2] = (state == 4'd0)? (in_start_pic & rom_0_color[1]) : (((state == 4'd7) & in_dead_pic & rom_1_color[1]) | in_head | in_body | (in_stage[0] & (stage_color[0][0] == 0)) | (in_stage[1] & (stage_color[1][0] == 0)));
assign VGA_G[1] = (state == 4'd0)? (in_start_pic & rom_0_color[1]) : (((state == 4'd7) & in_dead_pic & rom_1_color[1]) | in_head | in_body | (in_stage[0] & (stage_color[0][0] == 0)) | (in_stage[1] & (stage_color[1][0] == 0)));
assign VGA_G[0] = (state == 4'd0)? (in_start_pic & rom_0_color[1]) : (((state == 4'd7) & in_dead_pic & rom_1_color[1]) | in_head | in_body | (in_stage[0] & (stage_color[0][0] == 0)) | (in_stage[1] & (stage_color[1][0] == 0)));
//B
assign VGA_B[3] = (state == 4'd0)? (in_start_pic & rom_0_color[0]) : (((state == 4'd7) & in_dead_pic & rom_1_color[0]) | in_head | in_body | (in_stage[0] & (stage_color[0] == BLUE)) | (in_stage[1] & (stage_color[1] == BLUE)));
assign VGA_B[2] = (state == 4'd0)? (in_start_pic & rom_0_color[0]) : (((state == 4'd7) & in_dead_pic & rom_1_color[0]) | in_head | in_body | (in_stage[0] & (stage_color[0] == BLUE)) | (in_stage[1] & (stage_color[1] == BLUE)));
assign VGA_B[1] = (state == 4'd0)? (in_start_pic & rom_0_color[0]) : (((state == 4'd7) & in_dead_pic & rom_1_color[0]) | in_head | in_body | (in_stage[0] & (stage_color[0] == BLUE)) | (in_stage[1] & (stage_color[1] == BLUE)));
assign VGA_B[0] = (state == 4'd0)? (in_start_pic & rom_0_color[0]) : (((state == 4'd7) & in_dead_pic & rom_1_color[0]) | in_head | in_body | (in_stage[0] & (stage_color[0] == BLUE)) | (in_stage[1] & (stage_color[1] == BLUE)));

endmodule