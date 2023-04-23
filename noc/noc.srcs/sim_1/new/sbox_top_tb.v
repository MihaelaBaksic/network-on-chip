`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 06:53:05 PM
// Design Name: 
// Module Name: sbox_top_tb
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


module sbox_top_tb();

    reg [0:127] inputs;
    wire [0:127] outputs;
    wire [0:2] num = 3'b000;
    
    sbox_e_top UUT ( .in_bits(inputs), .out_bits(outputs), .box_num(num));
    

    initial
    begin
    
        //inputs <= 128'h0fd3_612e_f49e_a45c_8a6a_718c_33d9_3f8f;
        //#1
        inputs <= 128'h0fd1_612e_f49e_a45c_8a6a_718c_33d9_3f8f;
        
        #1
        
        inputs <= 128'h0000_612e_f49e_a45c_8a6a_718c_33d9_3f8f;
    end
    
endmodule
