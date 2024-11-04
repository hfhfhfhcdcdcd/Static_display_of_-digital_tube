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
/*--------------seg_cnt-------------------*/
 reg [7:0] seg_cnt;
 always @(posedge clk or negedge rst) begin
     if (!rst) begin
         seg_cnt <= 8'h00;
     end
     else if ((seg_cnt < 8'h0f)&&(cnt == time_50ms - 1)) begin
         seg_cnt <= seg_cnt + 1'b1;
     end
     else if ((seg_cnt == 8'h0f)&&(cnt == time_50ms - 1)) begin
         seg_cnt <=8'h00 ;
     end
     else 
         seg_cnt <=seg_cnt ;
 end
/*--------------seg-------------------*/
always @(posedge clk or negedge rst) begin
     if (!rst) begin
         seg <= 8'h00;
     end
     else case (seg_cnt)
                8'h00:seg <= 8'b1100_0000;
                8'h01:seg <= 8'b1111_1001;
                8'h02:seg <= 8'b1010_0100;
                8'h03:seg <= 8'b1011_0000;
                8'h04:seg <= 8'b1001_1001;
                8'h05:seg <= 8'b1001_0010;
                8'h06:seg <= 8'b1000_0010;
                8'h07:seg <= 8'b1111_1000;
                8'h08:seg <= 8'b1000_0000;
                8'h09:seg <= 8'b1001_0000;
                8'h0a:seg <= 8'b1000_1000;
                8'h0b:seg <= 8'b1000_0011;
                8'h0c:seg <= 8'b1100_0110;
                8'h0d:seg <= 8'b1010_0001;
                8'h0e:seg <= 8'b1000_0110;
                8'h0f:seg <= 8'b1000_1110;
        default:; 
     endcase
 end
endmodule
