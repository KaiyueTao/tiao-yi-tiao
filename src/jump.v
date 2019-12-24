//负责产生小人的坐标，enable=0时固定
//enable时改变小人的坐标，产生跳动效果
module jump(
    input clk,rst,enable,generate_en,pulse,
    input [9:0] tall,
    input [9:0] length,
    input [9:0] moved_man_x,
    output reg jump_fin,
    output reg [9:0] man_x,man_y,
    output reg [9:0] man_tall
);
wire [19:0] x, x_square;
wire [9:0] f;
reg [9:0] start_x;

assign x = {10'b0, {man_x - 60}};
assign x_square = x * x;
assign f = (x - (x_square/length));

always @(posedge clk)
begin
    if(rst | generate_en) begin
        man_x<=60;
        man_y<=500;
        jump_fin<=0;
    end
    else if(enable) begin
        if(pulse)
            if(man_x<(start_x+length/2+length/4)) begin
                man_x <= man_x + 2;
                man_y <= 500 - f;
                jump_fin <= 0;
            end
            // else if(man_x<(start_x+length/4)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y - 3;
            //     jump_fin <= 0;
            // end
            // else if(man_x<(start_x + length/4 + length/8)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y - 2;
            //     jump_fin <= 0;
            // end
            // else if(man_x<(start_x + length/2)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y - 1;
            //     jump_fin <= 0;
            // end
            // else if(man_x<(start_x + length/2 + length/8)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y + 1;
            //     jump_fin <= 0;
            // end            
            // else if(man_x<(start_x + length/2 + length/4)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y + 2;
            //     jump_fin <= 0;
            // end            
            // else if(man_x<(start_x + length/2 + length/4 + length/8)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y + 3;
            //     jump_fin <= 0;
            // end
            // else if(man_x<(start_x + length)) begin
            //     man_x <= man_x + 2;
            //     man_y <= man_y + 4;
            //     jump_fin <= 0;
            // end
            else begin
                man_x <= man_x;
                man_y <= 500;
                jump_fin <= 1;
            end
    end
    else begin
        start_x <= moved_man_x;
        man_x <= moved_man_x;
        man_y <= 500;
        jump_fin <= 0;
    end  
end

always @(posedge clk)
begin
    if(enable) begin
        if(pulse)
            if(man_tall < 80)
                man_tall <= man_tall + 2;
            else
                man_tall <= 80;
    end
    else man_tall <= tall;
end

endmodule
            
        




