module pressing(
    input clk,enable,press,clean,
    output [9:0] length,
    output [9:0] man_tall
);
reg [28:0] press_count;
always @(posedge clk)
begin
    if(clean)
        press_count<=0;
    else if(enable)
        if(press)
            press_count<=press_count+1;
    else
        press_count<=press_count;
end

assign length = (press_count[28:19] > 10'd800)? 10'd800: press_count[28:19] ;
assign man_tall = 10'd80 - length/10;

endmodule





