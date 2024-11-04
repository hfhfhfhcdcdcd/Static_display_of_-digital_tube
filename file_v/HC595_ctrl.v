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
    else if (freq_12_5M_cnt == 2'd2) begin
        shcp <= ~shcp;
    end
    else if (freq_12_5M_cnt == 2'd0) begin
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
 always @(posedge shcp or negedge rst) begin
    if (!rst) begin
         stcp <= 1'b0;
    end
    else if (cnt_bit == 4'd13) begin
        stcp <= 1'b1;
    end
    else
        stcp <= 1'b0;
 end
/*------------------data--------------------*/
 reg [13:0] data;
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
         data <= 14'd0;
    end
    else begin case (seg[7:0])
                 8'b1100_0000,8'b1111_1001
                ,8'b1010_0100,8'b1011_0000
                ,8'b1001_1001,8'b1001_0010
                ,8'b1000_0010,8'b1111_1000
                ,8'b1000_0000,8'b1001_0000
                ,8'b1000_1000,8'b1000_0011
                ,8'b1100_0110,8'b1010_0001
                ,8'b1000_0110,8'b1000_1110:
                    data <= {seg[7:0],sel[5:0]};
                    default:;
    endcase  
    end
 end
/*------------------DS--------------------*/
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        DS <= 1'b0;
    end
    else if (freq_12_5M_cnt == 2'd0) begin
        DS <= data[cnt_bit];
    end
    else
        DS <= DS;
 end
/*------------------OE--------------------*/
 always @(posedge clk or negedge rst) begin
    if (!rst) begin
        OE <= 1'b1;
    end
    else    
        OE <= 1'b0;
 end
endmodule
