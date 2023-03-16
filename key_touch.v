module key_touch(

	input sys_clk,
	input sys_rst_n,
	input key_in,
	
	output reg led_out//输出控制led
);


/***parameter define*****/
parameter CNT_MAX = 25'd24_999_999;

reg reg_key_in;//信号保持reg
reg key_flag;//下降沿检测脉冲信号
reg led_out_flag;//led闪烁信号
reg [24:0] cnt;//led闪烁计数，不使用count_flag控制counter

//reg cnt_flag;//添加控制counter的信号

/****main code****/

//reg_key_in 信号保持
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		reg_key_in <= 1'b0;
	else
		reg_key_in <= key_in;

//key_flag 下降沿信号检测
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_flag <= 1'b0;
	else if(~key_in &&reg_key_in)//检测下降沿的那一个时钟周期为高，一个脉冲信号
		key_flag <= 1'b1;
	else
	 	key_flag<= 1'b0;
	
//led_out_flag 指示led闪烁信号
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		led_out_flag <= 1'b1;
	else if(key_flag == 1'b1)
		led_out_flag <= ~led_out_flag;
	else	
		led_out_flag <= led_out_flag;


//cnt计数
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt <= 1'b0;
	else if(led_out_flag == 1'b1)
		cnt <= 1'b0;
	else if(cnt == CNT_MAX)
		cnt <= 1'b0;
	else 
		cnt <= cnt + 1'b1;

//cnt_flag
// always@(posedge sys_clk or negedge sys_rst_n)
// 	if(sys_rst_n == 1'b0)
// 		cnt_flag <= 1'b0;
	

/*****给led_out_flag增加一个边沿检测********/
reg led_out_flag_nedge;
reg led_out_flag_reg;

//led_out_flag_reg辅助判断信号赋值
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		led_out_flag_reg <= 1'b0;
	else 
		led_out_flag_reg <= led_out_flag;

//led_out_flag_nedge边沿检测信号赋值
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		led_out_flag_nedge <= 1'b0;
	else if(~led_out_flag && led_out_flag_reg)
		led_out_flag_nedge <= 1'b1;
	else 
		led_out_flag_nedge <= 1'b0;
/******************************************/



//第一个脉冲信号点亮，后面就一直取反就行，点亮的时候是闪烁式点亮
//如何控制led点亮的时候闪烁
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		led_out <= 1'b1;
	else if(led_out_flag == 1'b1)//led输出信号拉高，led不亮
		led_out <= 1'b1;
	// else if(key_flag == 1'b0 && led_out_flag == 1'b0)
	// 	led_out <= 1'b0;
	else if(led_out_flag_nedge == 1'b1)
		led_out <= 1'b0;
	else if(cnt == CNT_MAX)//只会翻转一次又重新为低电平，有问题
		led_out <= ~led_out;
	else 
		led_out <= led_out;
// always@(posedge sys_clk or negedge sys_rst_n)
// 	if(sys_rst_n == 1'b0)
// 		led_out <= 1'b0;
// 	else if(led_flag)
// 		led_out <= 1'b1;
// 	else 
// 		led_out <= 1'b0;
		
endmodule