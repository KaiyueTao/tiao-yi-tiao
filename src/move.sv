module move(
    input clk,pulse,
    input enable,
    input [9:0] man_x,
    input [9:0] stage_x[0:1],
    output reg move_fin,
    output reg [9:0] new_man_x,
    output reg [9:0] new_stage_x[0:1]
);

initial begin
    new_man_x=0;
end
always @(posedge clk)
begin
    if(enable) begin
        if(pulse)
            if(new_man_x > 60) begin
                new_man_x <= new_man_x-1;
                new_stage_x[0] <= new_stage_x[0] - 1;
                new_stage_x[1] <= new_stage_x[1] - 1;
                move_fin<=0;
            end
            else
                move_fin<=1;
    end
    else begin
        new_man_x <= man_x;
        new_stage_x <= stage_x;
        move_fin <= 0;
    end
end

endmodule


    