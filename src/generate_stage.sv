`include "parameter.v"
module generate_stage(
    input clk,rst,
    input enable,
    output reg [9:0] stage_x[0:1],
    output reg [9:0] stage_w[0:1],
    output reg [1:0] stage_color[0:1]
);

reg [9:0] new_stage_x;
reg [9:0] new_stage_w;
reg [1:0] new_stage_color;

create create1(
    .clk(clk),
    .min(250),
    .max(350),
    .new_x(new_stage_x),
    .new_w(new_stage_w),
    .color(new_stage_color)
);

always @(posedge clk)
begin
    if(enable) begin
        stage_x[0] <= 10'd60;
        stage_color[0] <= `BLUE;
        stage_w[0] <= 60; 
        stage_x[1] <= new_stage_x;
        stage_w[1] <= new_stage_w;
        stage_color[1] <= new_stage_color;
    end
end

endmodule