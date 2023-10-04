`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 04:43:39 PM
// Design Name: 
// Module Name: spitoi2c
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spitoi2c(
    input [7:0] data,
    input start,
    input clk,
    input reset,
    output i2c_scl,
    output i2c_sda
    );
    
    wire ss,din,i2cmreset,miso;
    wire [7:0] in;
    
    spi_fsm mod1(.clk(clk),.reset(reset),.data(data),.start(start),.mosi(din),.ss(ss),.done(i2cmreset),.miso(miso));
    
    sipo mod2(.clk(clk),.din(din),.ss(ss),.dout(in),.miso(miso));
    
    i2cmaster mod3(.clk(clk),.reset(i2cmreset),.in(in),.i2c_sda(i2c_sda),.i2c_scl(i2c_scl));
    
endmodule
