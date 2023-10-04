`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 04:49:57 PM
// Design Name: 
// Module Name: spitoi2ctb
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


module spitoi2ctb;
reg start;
reg [7:0] data;
reg clk;
reg reset;

wire i2c_scl;
wire i2c_sda;

spitoi2c TB(.start(start),.data(data),.clk(clk),.reset(reset),.i2c_sda(i2c_sda),.i2c_scl(i2c_scl));

initial
begin
    start=0;
    data=8'b10101101;
    clk=0;
    reset=1;
    forever #10 clk=~clk;
end
initial
begin
    #90;
    data=8'b10101101;
    start=1;
    reset=0;
end


endmodule
