module control(
    input clk,rst,
    input press,   //输入的是去抖动之后的press信号
    input start,
    input jump_fin,
    input game_over,
    input move_fin,
    input fall_fin,
    input on_second,
    output reg press_En,
    output reg jump_En,
    output reg fall_En,
    output reg generate_En,
    output reg update_En,
    output reg count_En,
    output reg move_En,
    output reg press_zero,  //清零
    output wire [3:0] state
);

parameter START = 4'd0;
parameter WAIT = 4'd1; 
parameter PRESSING = 4'd2;
parameter JUMP = 4'd3;
parameter CHECK = 4'd4;
parameter UPDATE = 4'd5;
parameter MOVE = 4'd6;
parameter DEAD = 4'd7;
parameter FALL = 4'd8;    //用于产生台子落下的动画效果

reg [3:0] curr_state, next_state;

always @(*)
begin
    case(curr_state)
        START:
            if(start) next_state<=WAIT;
            else next_state<=curr_state;
        WAIT:
            if(press) next_state<=PRESSING;   //按压之后变成PRESSING
            else next_state<=curr_state;
        PRESSING:
            if(press) next_state<=curr_state;  
            else next_state<=JUMP;   //停止按压则开始jump
        JUMP:
            if(jump_fin)
                next_state<=CHECK;  //跳完之后检查
            else next_state<=curr_state;
        CHECK:
            if(game_over) next_state<=DEAD;
            else if(on_second) next_state<=UPDATE;
            else next_state<=WAIT;
        UPDATE:
            next_state<=FALL;   //更新在一个周期内完成，转入空状态将新状态同步给move
        FALL:
            if(fall_fin) next_state<=MOVE;
            else next_state<=curr_state;
        MOVE:
            if(move_fin) next_state<=WAIT;
            else next_state<=curr_state;
        DEAD:
            next_state<=curr_state;
        default: next_state<=START;   
    endcase
end

always @(posedge clk or posedge rst)
begin
    if(rst)
        curr_state<=START;
    else    
        curr_state<=next_state;
end

always @(*)
begin
    case(curr_state)
        START: begin
            generate_En<=1;
            jump_En<=0;
            update_En<=0;
            move_En<=0;
            press_zero<=1;  //用于一开始的清零
            press_En<=0;
            count_En<=0;
            fall_En<=0;
            end
        WAIT: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0;
            move_En<=0;
            press_En<=0;
            press_zero<=0;
            count_En<=0;
            fall_En<=0;
            end           
        PRESSING: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0;
            move_En<=0;
            press_En<=1;
            press_zero<=0;
            count_En<=0;
            fall_En<=0;
            end 
        JUMP: begin
            generate_En<=0;
            jump_En<=1;
            update_En<=0; 
            move_En<=0;
            press_En<=0;
            press_zero<=0;
            count_En<=0;
            fall_En<=0;
            end 
        CHECK: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0; 
            move_En<=0;
            press_En<=0;
            press_zero<=1;
            count_En<=1;
            fall_En<=0;
            end
        UPDATE: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=1; 
            move_En<=0;
            press_En<=0;
            press_zero<=0;
            count_En<=0;
            fall_En<=0;
            end 
        FALL: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0; 
            move_En<=0;
            press_En<=0;
            press_zero<=0;
            count_En<=0;
            fall_En<=1;
            end
        MOVE: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0; 
            move_En<=1;
            press_En<=0;
            press_zero<=0;
            count_En<=0;
            fall_En<=0;
            end 
        DEAD: begin
            generate_En<=0;
            jump_En<=0;
            update_En<=0;
            move_En<=0;
            press_En<=0;
            press_zero<=0; 
            count_En<=0;
            fall_En<=0;
            end 
    endcase
end

assign state = curr_state;

endmodule