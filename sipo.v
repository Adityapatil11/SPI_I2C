`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 03:57:40 PM
// Design Name: 
// Module Name: sipo
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


module sipo(
    input din,
    input clk,
    input ss,
    output reg miso,
    output reg [7:0] dout
    );
    
    reg [7:0] s;
    
    initial 
        begin
            s<=8'b01111110;
        end
        
    always @(posedge clk)
    begin
        if(ss==0)
        begin
            miso<=s[7];
            s<={s[6:0],din};
        end
        else
            dout<=s;
    end
endmodule
