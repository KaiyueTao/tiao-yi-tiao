//update
`include "parameter.v"
module update(
    input clk,rst,
    input update_en,generate_en,move_fin,
    input [9:0] moved_stage_x[0:1],
    input [9:0] score,
    output reg [9:0] stage_x[0:1], 
    output reg [9:0] stage_w[0:1],
    output reg [1:0] stage_color[0:1]
);

wire [9:0] new_stage_x, new_stage_w;
wire [1:0] new_stage_color;

create create1(
    .clk(clk),
    .rst(rst),
    .score(score),
    .min(stage_x[1]+stage_w[1]),
    .max(10'd400),
    .new_x(new_stage_x),
    .new_w(new_stage_w),
    .new_color(new_stage_color)
);

always @(posedge clk)
begin
    if(generate_en) begin
        stage_x[0] <= 10'd60;
        stage_color[0] <= `BLUE;
        stage_w[0] <= 60; 
        stage_x[1] <= 200;
        stage_w[1] <= 60;
        stage_color[1] <= 0;
    end
    else if(update_en) begin
        stage_x[0] <= stage_x[1];
        stage_w[0] <= stage_w[1]; 
        stage_color[0] <= stage_color[1];
        stage_x[1] <= new_stage_x;
        stage_w[1] <= new_stage_w; 
        stage_color[1] <= new_stage_color;
    end
    else if(move_fin)
        stage_x <= moved_stage_x;
    else begin
        stage_x<=stage_x;
        stage_w<=stage_w;
        stage_color<=stage_color;
    end
end
endmodule