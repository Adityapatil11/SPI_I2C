`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 04:28:13 PM
// Design Name: 
// Module Name: i2cmaster
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


module i2cmaster(
    input clk,
    input reset,
    input [7:0] in,
    output i2c_scl,
    inout i2c_sda
    );
    
    reg [7:0] data;
    reg direction,temp,a,ack;
    reg [6:0] addr;
    reg [2:0] count, countd;
    reg [2:0] state;
    
    parameter idle=0,start=1,add=2,rw=3,wack=4,datas=5,wack2=6,stop=7;
    
    i2cslave mod4(.i2c_sda(i2c_sda),.i2c_scl(i2c_scl));
    
    always @(*)
    begin
        data<=in;
    end
    
    assign i2c_sda = direction?temp:1'bz;
    assign i2c_scl = (reset||a)?1'b1:clk;
    
    always @(posedge clk)
    begin
        if(reset==1)
        begin
            direction<=1;
            state<=0;
            temp<=1;
            addr<=7'b0001000;
            count<=3'b110;
            countd<=3'b111;
            a<=1;
        end
        else
        begin
            case(state)
                idle:
                begin
                    direction<=1;
                    temp<=1;
                    a<=1;
                    state<=start;
                end
                
                start:
                begin
                    direction<=1;
                    temp<=0;
                    #5 a<=0;
                    state<=add;
                end
                
                add:
                begin
                    a<=0;
                    temp<=addr[count];
                    if(count==0)
                        state<=rw;
                    else
                        count<=count-1;
                end
                
                rw:
                begin
                    temp<=0;
                    state<=wack;
                end
                
                wack:
                begin
                    direction<=0;
                    ack<=i2c_sda;
                    if(ack==0)
                      begin
                        a<=0;
                        state<=datas;
                      end
                    else if(ack==1)
                        begin
                            a<=0;
                            state<=add;
                        end
                    else
                        a<=1;
                end
                
                datas:
                begin
                    direction<=1;
                    temp<=data[countd];
                    if(countd==0)
                        state<=wack2;
                    else
                        countd<=countd-1;
                end
                
                wack2:
                begin
                    direction<=0;
                ack<=i2c_sda;
                if(ack==0)
                  begin
                    a<=0;
                    state<=stop;
                  end
                else if(ack==1)
                    begin
                        a<=0;
                        state<=datas;
                    end
                else
                    a<=1;
                end
                
                stop:
                begin
                    direction<=1;
                    a<=1;
                    #5 temp<=1;
                end
            endcase
        end
        
    end
    
endmodule
