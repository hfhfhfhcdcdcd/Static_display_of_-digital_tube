module top(
input sys_clk,
input rst_n,
output uart_tx
);

reg  [13:0]  sel_seg       ;
reg          send_go    ;
wire         tx_done    ;

rw_74HC595 r1(   
.sys_clk      (sys_clk )    ,
.rst_n        (rst_n   )    ,
.time_set     (2)           ,
.sel_seg      (sel_seg )    ,                            
.send_go      (send_go )    ,
.uart_tx      (uart_tx )    ,
.tx_done      (tx_done)     
);
/*--------------变量的声明-------------------*/
reg [31:0] cnt_10ms;
parameter time_10ms = 500_000;
/*-------------- 1 0 ms ---------------*/
always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_10ms<=0;
    end
    else if (cnt_10ms==time_10ms-1) begin
        cnt_10ms<=0;
    end
    else
        cnt_10ms<=cnt_10ms+1;
end
/*--------------send_en--------------*/
always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        send_go<=0;
    end
    else if (cnt_10ms == 1) begin
        send_go<=1'b1;
    end
    else
        send_go<=0;   
end
/*--------------sel_seg--------------*/
always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        sel_seg<=0;
    end
    else if (tx_done) begin
        sel_seg<=sel_seg+1;
    end
    else
        sel_seg<=sel_seg;
end
endmodule
