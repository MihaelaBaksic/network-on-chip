`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module sbox_e(
        input wire [3:0] in_bits,
        output reg [3:0] out_bits,
        input [2:0] box_num
    );
  
    reg [63:0] s_boxes [0:7];
    
    initial begin // defining s-boxes
        s_boxes[0] <= 64'b1100_0111_0101_1110_1111_0010_1010_1001_0001_1011_0110_0000_1000_0100_1101_0011;// 38f1a65bed42709c; original
        s_boxes[1] <= 64'b1111_1000_1001_0110_0100_0111_1010_1100_0011_1101_0000_1011_1110_0001_0101_0010; // fc27905a1be86d34; original
        s_boxes[2] <= 64'b0001_1011_1100_0000_1110_0111_0101_1010_0110_1000_0011_1101_1001_0010_1111_0100; // 86793cafd1e40b52; original
        s_boxes[3] <= 64'b0000_1011_0011_0101_1101_0100_0110_1010_1111_1000_1001_1110_0001_0010_1100_0111; // 0fb8c963d124a75e; original
        s_boxes[4] <= 64'b1000_0100_0011_1001_0001_0010_1101_1110_1111_1010_0000_0111_1100_0101_0110_1011; // 1f83c0b6254a9e7d; original
        s_boxes[5] <= 64'b1111_0000_0010_1011_0100_0111_1001_1110_1010_1100_0101_0110_1101_0001_0011_1000; // f52b4a9c03e8d671; original
        s_boxes[6] <= 64'b1110_0111_0001_1011_0011_1000_0110_0101_0100_1001_0010_1100_1010_1111_1101_0000; // 72c5846be91fd3a0; original
        s_boxes[7] <= 64'b1000_1110_0111_1001_1111_0011_0100_1010_1011_0010_0001_1100_0000_0101_1101_0110; // 1df0e82b74ca9356; original
    end 
    
    always @(in_bits or box_num)
    begin
        // address the s-box and assign the out_bits based on in_bits
        out_bits = s_boxes[box_num][63-in_bits*4 -: 4];
    end

    
endmodule
