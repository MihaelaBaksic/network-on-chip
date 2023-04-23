`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module sbox_e_top(
    input [0:127] in_bits,
    output wire[0:127] out_bits,
    input [2:0] box_num
    );
    
    generate
        genvar i;
        for (i=0; i < 32; i=i+1) begin : u
        sbox_e sbox ( .box_num(box_num), .in_bits({in_bits[i], in_bits[32*1+i], in_bits[32*2+i], in_bits[32*3+i]}), 
                                        .out_bits({out_bits[i], out_bits[32*1+i], out_bits[32*2+i], out_bits[32*3+i]}) );
        end
    endgenerate
    
    
endmodule
