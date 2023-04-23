`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module decryptor_tb();

reg [0:127] round_data;
reg [0:127] lin_inv;
wire [0:127] unboxed_data;
integer round;

wire [0:128*33-1] round_keys; // 33 * 128b subkeys

reg [0:31] x0;
reg [0:31] x1;
reg [0:31] x2;
reg [0:31] x3;

// instantiate sbox_d_top module
sbox_d_top sboxes (
    .in_bits(lin_inv),
    .out_bits(unboxed_data),
    .box_num(round % 8)
);

reg [0:255] key;

integer expand = 1;

key_scheduler keys (.key(key), .round_keys(round_keys)); 

initial
begin

     key = 255'b0101111101111011001111010101100100011110011010100010110001001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        // perform key expansion - calculate round keys
        if(expand == 1)
        begin
            #1000
            expand = 0;
        end
        
        // 32nd round
        round = 31;
        
        round_data = 128'b0;
        lin_inv = round_data ^ round_keys[32*128 +: 128];
        #10 // s-box pass
        round_data = unboxed_data ^ round_keys[31*128 +: 128];
        
        
        for(round = 30; round >=0; round = round-1)
        begin
            
            x0 = round_data[0:31];
            x1 = round_data[32:63];
            x2 = round_data[64:95];
            x3 = round_data[96:127];
            
            x2 = { x2[22:31], x2[0:21]};// x2 = x2 >>> 22
            x0 = {x0[5:31], x0[0:4]};// x0 = x0 >>> 5
            x2 = x2 ^ x3 ^ (x1 >> 7);// x2 = x2 xor x3 xor (x1 << 7)
            x0 = x0 ^ x1 ^ x3; // x0 = x0 xor x1 xor x3
            x3 = {x3[7:31], x3[0:6]};// x3 = x3 >>> 7
            x1 = {x1[1:31], x1[0]};// x1 = x1 >>> 1
            x3 = x3 ^ x2 ^ (x0 >> 3);// x3 = x3 xor x2 xoe (x0 << 3)
            x1 = x1 ^ x0 ^ x2;// x1 = x1 xor x0 xor x2
            x2 = {x2[3:31], x2[0:2]};// x2 = x2 >>> 3
            x0 = {x0[13:31], x0[0:12]};// x0 = x0 >>> 13
            
            // inv linear transformation
            lin_inv = {x0, x1, x2, x3};
            
            #2 // s-box pass
            
            round_data = unboxed_data ^ round_keys[round*128 +: 128];
            
        end
        
        
     #1;
     
end

endmodule
