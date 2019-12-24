module segdisplay(
    input clk,rst,
    input [9:0] score,
    input [3:0] state,
    output reg [7:0] an,
    output ca,cb,cc,cd,ce,cf,cg,dp
);
//分时复用
reg [20:0] cnt;
reg [3:0] data;

always @(posedge clk)
begin
    if(rst) cnt<=0;
    else cnt<=cnt+1;
end

always @(posedge clk)
begin
    case(cnt[20:18])
        3'b000: an<=8'b1111_1110;
        3'b001: an<=8'b1111_1101;
        3'b010: an<=8'b1111_1011;
        3'b011: an<=8'b1111_0111;
        3'b100: an<=8'b1110_1111;
        3'b101: an<=8'b1101_1111;
        3'b110: an<=8'b1011_1111;
        3'b111: an<=8'b0111_1111;
    endcase
end

wire dead;
assign dead = (state == 3'b111);

always @(posedge clk)
begin
    case(cnt[20:18])
        3'b000: data<=score[3:0];
        3'b001: data<=score[7:4];
        3'b010: data<={2'b00,score[9:8]};
        3'b011: data<=state;
        3'b100: 
            if(dead) data <= 4'b1101;  //D
            else data<=0;//高电平，全不�?
        3'b101: 
            if(dead) data <= 4'b1010;  //A
            else data<=0; //高电平，全不�?
        3'b110:
            if(dead) data <= 4'b1110;  //E
            else data<=0; //高电平，全不�?
        3'b111: 
            if(dead) data <= 4'b1101;  //D
            else data<=0;//高电平，全不�?
    endcase
end

dist_mem_gen_0 rom(
    .a(data),
    .spo({ca,cb,cc,cd,ce,cf,cg,dp})
);

endmodule


