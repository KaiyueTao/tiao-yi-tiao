`timescale 1ns / 1ps

module top(
    input clk,rst,
    input start,   //开始
    input press,   //蓄力
    //输出数码管，显示分数
    output [7:0] an,
    output ca,cb,cc,cd,ce,cf,cg,dp,
    //输出vga信号
    output wire VGA_HS,       // horizontal sync output
    output wire VGA_VS,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
);

wire clk_40mhz,pulse;
wire press_clean;
reg [3:0] press_cnt;
//去抖动
always @(posedge clk)
begin
    if(press == 0)
        press_cnt<=0;
    else if(press_cnt<4'h8)
        press_cnt<=press_cnt+1; 
end
assign press_clean = press_cnt[3];

clk_wiz_0 clk_wiz(
    .clk_in1(clk),
    .reset(rst),
    .clk_out1(clk_40mhz)
);

reg [19:0] clk_count;
always @(posedge clk)
begin
    if(rst) clk_count<=0;
    else if(clk_count>=299999)
        clk_count<=0;
    else clk_count<=clk_count+1;
end
assign pulse = (clk_count == 20'd1);

//top链接模块

//control signal
wire jump_En,move_En,generate_En,update_En,press_En,press_zero,count_En,fall_En;  //输出
wire [2:0] state;
wire jump_fin,game_over,move_fin,fall_fin;  //输入

//pressing 
wire [9:0] jump_length,press_man_tall;

//jump 产生人的坐标
wire [9:0] man_x,man_y,jump_man_tall;

//update 更新台子坐标
wire [9:0] stage_x[0:1];
wire [9:0] stage_w[0:1];
wire [1:0] stage_color[0:1];

//move 更新人和台子的横坐标
wire [9:0] moved_stage_x[0:1];
wire [9:0] moved_man_x;

//check 检查跳跃后的小人是否在台子上，是否落到正中心
wire middle, on_second;

//counting 计算分数，在check阶段计分
wire [9:0] score;

//stagefall模块，形成台子落下的动画效果
wire [9:0] stage_y2;

control control1(
    .clk(clk),
    .rst(rst),
    .press(press_clean), 
    .start(start),
    .jump_fin(jump_fin),
    .game_over(game_over),
    .move_fin(move_fin),
    .fall_fin(fall_fin),
    .on_second(on_second),
    .jump_En(jump_En),
    .generate_En(generate_En),
    .update_En(update_En),
    .fall_En(fall_En),
    .count_En(count_En),
    .move_En(move_En),
    .press_En(press_En),
    .press_zero(press_zero),   //按压清零
    .state(state)
);

pressing pressing1(
    .clk(clk),
    .enable(press_En),
    .press(press_clean),
    .clean(press_zero),
    .length(jump_length),
    .man_tall(press_man_tall)
);

jump jump1(
    .clk(clk),
    .rst(rst),
    .enable(jump_En),
    .generate_en(generate_En),
    .pulse(pulse),
    .tall(press_man_tall),
    .length(jump_length),
    .moved_man_x(moved_man_x),
    .jump_fin(jump_fin),
    .man_x(man_x),
    .man_y(man_y),
    .man_tall(jump_man_tall)
);

update update1(
    .clk(clk),
    .rst(rst),
    .score(score),
    .update_en(update_En),
    .generate_en(generate_En),
    .move_fin(move_fin),
    .moved_stage_x(moved_stage_x),
    .stage_x(stage_x),
    .stage_w(stage_w), 
    .stage_color(stage_color)
);

stagefall stagefall1(
    .clk(clk),
    .pulse(pulse),
    .update(update_En),
    .generate_en(generate_En),
    .enable(fall_En),
    .stage_y2(stage_y2),
    .fall_fin(fall_fin)
);

move move1(
    .clk(clk),
    .pulse(pulse),
    .enable(move_En),
    .man_x(man_x),
    .stage_x(stage_x),
    .move_fin(move_fin),
    .new_man_x(moved_man_x),
    .new_stage_x(moved_stage_x)
);

check check_if_dead(
    .man_x(man_x), 
    .stage_x(stage_x),
    .stage_w(stage_w),
    .game_over(game_over), 
    .middle(middle),
    .on_second(on_second)
);

counting counting_score(
    .clk(clk), 
    .rst(rst),
    .c_En(count_En),
    .on_second(on_second),
    .middle(middle), 
    .color(stage_color[1]),   //显然是计算跳到第二个台子上的颜色
    .score(score)
);

//display

segdisplay seg_display(
    .clk(clk), 
    .rst(rst), 
    .score(score),
    .state(state),
    .an(an),
    .ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg),.dp(dp)
);

display vga_display(
    .clk(clk_40mhz),
    .rst(rst),
    .man_x(moved_man_x),
    .man_y(man_y),
    .man_tall(jump_man_tall),
    .stage_x(moved_stage_x),
    .stage_y2(stage_y2),
    .stage_w(stage_w),
    .stage_color(stage_color),
    .state(state),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_R(VGA_R), 
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
);

endmodule















