`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2021 01:33:40 PM
// Design Name: 
// Module Name: sbox_e_tb
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


module sbox_inv_d_tb();

    reg [3:0] in_bits;
    wire [3:0] out_bits;
    reg [2:0] box_num;
    
    sbox_inv_d UUT (.in_bits(in_bits), .out_bits(out_bits), .box_num(box_num));
    
    integer i;
    localparam data = 64'h0123456789abcdef;
    integer box; 
    localparam box_data = 24'o01234567;
    
    initial 
    begin        
                
        for(box=0; box<8; box = box+1)
        begin
            box_num = box_data[23 - box*3 -: 3];
            for(i=0; i<16; i = i+1)
            begin
                in_bits = data[63 - i*4 -: 4];
                #5;
            end
            
            #10;        
        end
             
    
    end

endmodule
