`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 04:04:23 PM
// Design Name: 
// Module Name: i2cslave
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


module i2cslave(
    inout i2c_sda,
    input i2c_scl
    );
    parameter addr=1,rw=2,wack=3,data=4,wack2=5,stop=6;
    reg [6:0] addrs,radds;
    reg direction,temp,dis,en,rw1;
    reg [2:0] state;
    reg [2:0] counta,countd;
    
    initial begin
        addrs<=7'b0001000;
        direction<=1;
        state<=1;
        counta<=3'b110;
        countd<=3'b111;
        temp<=0;
    end 
    
    assign i2c_sda = direction?1'bz:temp;
    
    always @ (negedge i2c_sda)
    begin
        if(i2c_scl==1)
            en<=1;
        else
            en<=0;
    end
    
    always @(posedge i2c_sda)
    begin
        if(i2c_scl==1)
        dis<=1;
    else
        dis<=0;
    end
    
    always @(posedge i2c_scl)
    begin
        case(state)
            addr: begin
                  direction<=1;
                  radds[counta]<=i2c_sda;
			      if(counta==0) state<=rw;
                  else counta<=counta-1;
                  end
            addr: begin
                        rw1<=i2c_sda;
                        if(radds==addrs) temp<=0;
                        else temp<=1;
                        state<=wack;
                        end
            wack: begin
                  direction<=0;
                  if(temp==0)
                  begin
                    direction<=1;
                    state<=data;
                  end 
                  else
                    state<=addr;
                  end     
            data: begin
                  direction<=1;
                  temp<=data[countd];
                  if(countd==0)
                    state<=wack2;
                  else
                    countd<=countd-1;
                  end
            wack: begin
                        direction<=0;
                        if(temp==0)
                        begin
                          direction<=1;
                          state<=stop;
                        end 
                        else
                          state<=data;
                        end  
            stop: begin
                    direction<=1;
                    #5 temp<=1;
                  end
        endcase
    end
endmodule
