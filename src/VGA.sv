module vga800x600(
    input clk,           // clock 
    input rst,           // reset: restarts frame
    output wire o_hs,           // horizontal sync
    output wire o_vs,           // vertical sync
    output wire [9:0] o_x,      // current pixel x position
    output wire [9:0] o_y,       // current pixel y position
    output reg [18:0] rom_addr   //0~479999，故19位
);

localparam HS_STA = 40;              // horizontal sync start
localparam HS_END = 40 + 128;         // horizontal sync end
localparam HA_STA = 40 + 128 + 88;    // horizontal active pixel start
localparam VS_STA = 600 + 1;        // vertical sync start
localparam VS_END = 600 + 1 + 4;    // vertical sync end
localparam VA_END = 600;             // vertical active pixel end
localparam LINE   = 1056;             // complete line (pixels)
localparam SCREEN = 628;             // complete screen (lines)

reg [10:0] h_count;  // line position <=1056
reg [9:0] v_count;  // screen position <=628

// generate sync signals (active low for 640x480)
assign o_hs = ~((h_count >= HS_STA) & (h_count < HS_END));
assign o_vs = ~((v_count >= VS_STA) & (v_count < VS_END));

// keep x and y bound within the active pixels
assign o_x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
assign o_y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

always @(posedge clk)
begin
    if (rst)  // reset to start of frame
    begin
        h_count <= 0;
        v_count <= 0;
    end
    else begin
        if (h_count == LINE)  // end of line
        begin
            h_count <= 0;
            v_count <= v_count + 1;
        end
        else begin
            h_count <= h_count + 1;

        end
        if (v_count == SCREEN)  // end of screen
            v_count <= 0;
    end
end

always @(posedge clk)
begin
    if (rst)
        rom_addr<=0;
    else if (v_count > VA_END)  //当扫描到屏幕下方,则置零等待下一轮扫描
        rom_addr<=0;
    else if(h_count <= HA_STA)  //当在行的左侧不显示部分，则计数停止
        rom_addr<=rom_addr;
    else
        rom_addr<=rom_addr+1;
end
endmodule