`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module sbox_inv_d(
        input wire [3:0] in_bits,
        output reg [3:0] out_bits,
        input [2:0] box_num
    );
  
    reg [63:0] s_boxes [0:7];
    
    initial begin // defining s-boxes
        s_boxes[0] <= 64'b1011_1000_0101_1111_1101_0010_1010_0001_1100_0111_0110_1001_0000_1110_0011_0100;
        s_boxes[1] <= 64'b1010_1101_1111_1000_0100_1110_0011_0101_0001_0010_0110_1011_0111_1001_1100_0000; 
        s_boxes[2] <= 64'b0011_0000_1101_1010_1111_0110_1000_0101_1001_1100_0111_0001_0010_1011_0100_1110; 
        s_boxes[3] <= 64'b0000_1100_1101_0010_0101_0011_0110_1111_1001_1010_0111_0001_1110_0100_1011_1000; 
        s_boxes[4] <= 64'b1010_0100_0101_0010_0001_1101_1110_1011_0000_0011_1001_1111_1100_0110_0111_1000; 
        s_boxes[5] <= 64'b0001_1101_0010_1110_0100_1010_1011_0101_1111_0110_1000_0011_1001_1100_0111_0000;
        s_boxes[6] <= 64'b1111_0010_1010_0100_1000_0111_0110_0001_0101_1001_1100_0011_1011_1110_0000_1101;
        s_boxes[7] <= 64'b1100_1010_1001_0101_0110_1101_1111_0010_0000_0011_0111_1000_1011_1110_0001_0100;
    end 
    
    always @(in_bits or box_num)
    begin
        // address the s-box and assign the out_bits based on in_bits
        out_bits = s_boxes[box_num][63-in_bits*4 -: 4];
    end

    
endmodule
