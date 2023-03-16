/*****************/
/***边沿检测逻辑**/
/*input: 
	data,
	data_reg.
  output:
	podge,
	nedge
	以下用与逻辑实现，也可以用或逻辑实现
*/
/*****************/

//posedge
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		pos <= 1'b0;
	else if(data && ~data_reg)//data为高电平，data_reg为低电平时，检测到上升沿
		pos <= 1'b1;
	else	
		pos <= 1'b0;

//negedge
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		nedge <= 1'b0;
	else if(~data && data_reg)//data为高电平，data_reg为低电平时，检测到上升沿
		nedge <= 1'b1;
	else	
		nedge <= 1'b0;
		
		
//组合逻辑实现
//注意组合逻辑实现会使podge和nedge检测到上升沿和下降沿的脉冲提前一拍
assign podge = (data && ~data_reg)? 1'b1 : 1'b0;
assign nedge = (~data && data_reg)? 1'b1 : 1'b0;