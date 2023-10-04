`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 03:44:23 PM
// Design Name: 
// Module Name: spi_fsm
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


module spi_fsm(
    input clk,
    input reset,
    input start,
    input miso,
    input [7:0] data,
    output reg mosi,
    output reg ss,
    output reg done
    );
    
    reg [2:0] state;
    parameter idle=0,send=1,finish=2;
    reg [2:0] count,countr;
    reg [7:0] tdata,rdata;
    
    initial begin
        ss=1'b1;
        done=1'b1;
        tdata<=rdata;
        count<=3'b111;
        countr<=3'b111;
    end
    
    always @(posedge clk)
    begin
        if(reset==1)
        begin
            state<=0;
            mosi=1'b0;
        end
        else
            begin
                case(state)
                    idle:begin
                         ss=1'b1;
                         done=1'b1;
                         tdata<=data;
                         if(start==1)
                            state<=send;
                         else
                            state<=idle;
                         end
                    send:begin
                              ss=1'b0;
                              mosi=tdata[count];
                              rdata[countr]<=miso;
                              if((countr==0) && (count==0))
                                state<=finish;
                              else
                                begin
                                    countr<=countr-1;
                                    count<=count-1;
                                end
                              end
                    idle:begin
                               done=1'b0;
                               ss=1'b1;
                               mosi=1'b0;
                                   end
                endcase
            end
    end
endmodule
