module check(
    input [9:0] man_x,
    input [9:0] stage_x[0:1],  //中点
    input [9:0] stage_w[0:1],
    output game_over, 
    output middle,
    output on_second//判断在哪个台子上
);
wire on_first;
assign on_first = (man_x > (stage_x[0] - stage_w[0])) & (man_x < (stage_x[0] + stage_w[0]));
assign on_second = (man_x > (stage_x[1] - stage_w[1])) & (man_x < (stage_x[1] + stage_w[1]));
assign game_over = ~ (on_first | on_second);  //不在两个台子上
assign middle = ((man_x> (stage_x[0] - 10)) & (man_x < (stage_x[0] + 10))) | ((man_x>(stage_x[1] - 10)) & (man_x < (stage_x[1] + 10)));
endmodule

