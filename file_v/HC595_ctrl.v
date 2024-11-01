module HC595_ctrl (
    input               rst                 ,
    input               clk                 ,
    input [5:0]         sel                 ,
    input [7:0]         seg                 ,

    output    reg       stcp                ,
    output    reg       shcp                ,
    output    reg       DS                  ,
    output    reg       OE
);
/*------------------freq_12_5M_cnt--------------------*/
 reg [1:0] freq_12_5M_cnt;
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        freq_12_5M_cnt <= 2'd0;
    end
    else if (freq_12_5M_cnt == 2'd3) begin
        freq_12_5M_cnt <= 2'd0;
    end
    else
         freq_12_5M_cnt <= freq_12_5M_cnt + 1'b1;
 end
/*------------------shcp--------------------*/
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
         shcp <= 1'b0;
    end
    else if (freq_12_5M_cnt == 2'd3) begin
        shcp <= ~shcp;
    end
    else
        shcp <= shcp;
 end
/*------------------cnt_bit--------------------*/
 reg [3:0]cnt_bit;
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        cnt_bit <= 4'd0;
    end
    else if((cnt_bit == 4'd13)&&(freq_12_5M_cnt == 2'd3))begin
        cnt_bit <= 4'd0;
    end
    else if (freq_12_5M_cnt == 2'd3) begin
        cnt_bit <= cnt_bit + 1'b1;
    end
    else
        cnt_bit <= cnt_bit;
 end 
/*------------------stcp--------------------*/
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
         stcp <= 1'b0;
    end
    else if ((cnt_bit == 4'd13)&&(freq_12_5M_cnt >= 2'd0)) begin
        stcp <= 1'b1;
    end
    else
        stcp <= 1'b0;
 end
/*------------------data--------------------*/
 reg [13:0] data;
 always @(posedge shcp or negedge rst) begin
    if (!rst) begin
         data <= 14'd0;
    end
    else if (cnt_bit == 6) begin
        data <= {seg[7:0],sel[5:0]};
    end
        
 end
/*------------------DS--------------------*/
 always @(posedge shcp) begin
    if (!rst) begin
        DS <= 1'b0;
    end
    else 
        DS <= data[cnt_bit];
 end
/*------------------OE--------------------*/
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        OE <= 1'b0;
    end
    else if((cnt_bit == 4'd13)&&(freq_12_5M_cnt == 2'd3))begin
        OE <= 1'b1;
    end
    else    
        OE <= 1'b0;
 end
endmodule
