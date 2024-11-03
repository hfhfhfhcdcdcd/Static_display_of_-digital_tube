module seg_static (
    input               rst         ,
    input               clk         ,
    output     [5:0]    sel         ,
    output reg [7:0]    seg
);
/*--------------sel-------------------*/
 assign sel = 6'b111_111;
/*--------------cnt-------------------*/
 reg [21:0] cnt ;
 parameter time_50ms = 250;
 always @(posedge clk or negedge rst) begin
     if (!rst) begin
        cnt <= 22'd0;
     end
     else if (cnt == time_50ms - 1) begin
        cnt <= 22'd0;
     end
     else
        cnt <= cnt + 1'b1;
 end
/*--------------seg-------------------*/
 always @(posedge clk or negedge rst) begin
     if (!rst) begin
         seg <= 8'h00;
     end
     else if ((seg < 8'h0f)&&(cnt == time_50ms - 1)) begin
         seg <= seg + 1'b1;
     end
     else if ((seg == 8'h0f)&&(cnt == time_50ms - 1)) begin
         seg <=8'h00 ;
     end
     else 
         seg <=seg ;
 end
endmodule
