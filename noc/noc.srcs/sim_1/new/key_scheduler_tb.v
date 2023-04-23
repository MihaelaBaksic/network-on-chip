`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 06:22:55 PM
// Design Name: 
// Module Name: key_scheduler_tb
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


module key_scheduler_tb();

    reg [255:0] key;
    reg clk;
    
    wire [0:128*33-1] round_keys;
    
    key_scheduler UUT (.key(key), .round_keys(round_keys), .clk(clk));
    
    initial
    begin
       clk = 1'b0;
      forever
      begin
          clk = ~clk;
            #1;
      end
    end

    
    initial
    begin
    
        key <= 256'b0101111101111011001111010101100100011110011010100010110001001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        
        #1;
    end

endmodule
