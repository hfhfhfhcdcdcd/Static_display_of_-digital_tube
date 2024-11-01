`timescale 1ns/1ps
module tb_top;
/*===========Àý»¯topÄ£¿é==============*/
reg  clk  ;
reg  rst  ;
wire stcp ;
wire shcp ;
wire DS   ;
wire OE   ;
top top1(
.clk (clk )           ,   
.rst (rst )           ,
.stcp(stcp)           ,
.shcp(shcp)           ,
.DS  (DS  )           ,
.OE  (OE  )           
);
defparam seg_static_tb.time_50ms = 25;
wire [5:0] sel;
wire [7:0] seg;
seg_static seg_static_tb(
    .rst(rst)         ,
    .clk(clk)         ,
    .sel(sel)         ,
    .seg(seg)
);
/*==================================*/
initial begin
    clk = 1'b0;
    rst = 1'b0;
    #201;
    rst = 1'b1;
    #16000;
    #20;
    $stop;
end
always #10 clk = ~clk;
endmodule