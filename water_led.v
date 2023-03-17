module water_led
#(
    parameter  CNT_MAX = 25'd24_999_999
)
(
    input sys_clk,
    input sys_rst_n,

    output wire [3:0] led_out
);

reg [24:0] cnt;
reg cnt_flag;
reg [3:0] led_out_reg;
reg direction;//=1 右移 =0 左移

//cnt计数器工作
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= 25'd0;
    else if(cnt == CNT_MAX)
        cnt <= 25'd0;
    else 
        cnt <= cnt + 25'd1;

//cnt_flag
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_flag <= 1'b0;
    else if(cnt == CNT_MAX - 1'd1)
        cnt_flag <= 1'b1;
    else
        cnt_flag <= 1'b0;

/***
    只需要一个计数器，led_out_flag变化部分相当于状态机
    但是注意初始状态的循环切换需要单独赋值
    单向循环
***/
//led_out_flag
// always@(posedge sys_clk or negedge sys_rst_n)
//     if(sys_rst_n == 1'b0)
//         led_out_reg <= 4'b0001;
//     else if(led_out_reg == 4'b1000 &&  cnt_flag == 1'b1)
//         led_out_reg <= 4'b0001;
//     // else if(led_out_reg == 4'b0010 &&  cnt_flag == 1'b1)
//     //     led_out_reg <= 4'b0100;
//     // else if(led_out_reg == 4'b0100 &&  cnt_flag == 1'b1)
//     //     led_out_reg <= 4'b1000;
//     // else   
//     //     led_out_reg <= 4
//     else if(cnt_flag == 1'b1)
//         led_out_reg <= led_out_reg << 1'b1;
//     else 
//         led_out_reg <= led_out_reg;



/**********************************************/
/**************双向循环模块********************/
/*
    双向循环应该是先左移后右移
    0001->0010->0100->1000->0100->0010->0001
    直接写一个六个状态的循环也可以
*/


//reg direction
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        direction <= 1'b0;
    else if(led_out_reg == 4'b1000 && cnt_flag == 1'b1)
        direction <= 1'b1;
    else if(led_out_reg == 4'b0001 && cnt_flag == 1'b1)
        direction <= 1'b0;
    else 
        direction <= direction;

//led_out_flag
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        led_out_reg <= 4'b0001;//initial state
    else if(led_out_reg == 4'b1000 && cnt_flag == 1'b1)
        led_out_reg <= 4'b0100;
    else if(led_out_reg == 4'b0001 && cnt_flag == 1'b1)
        led_out_reg <= 4'b0010;
    else if(cnt_flag == 1'b1 && direction == 1'b1)//右移
        led_out_reg <= led_out_reg >> 1'b1;
    else if(cnt_flag == 1'b1 && direction == 1'b0)//左移
        led_out_reg <= led_out_reg << 1'b1;
    else 
        led_out_reg <= led_out_reg;

/**********************************************/

assign led_out = ~led_out_reg;

endmodule