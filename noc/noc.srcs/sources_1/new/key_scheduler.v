`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module key_scheduler (
    input wire [0 : 255] key,
    output reg [0 : 128*33 -1] round_keys,
    input wire clk
    );
    
    reg [0:31] prekey [-8:131];
    
    integer i;
    integer k;
    wire [31:0] i_little_endian;
    
    generate for(genvar k=0; k<32; k = k+1) assign i_little_endian[k]=i[32-k-1]; endgenerate
    
    integer j;
    reg [0:31] fi = 32'b10011101100111101110110001111001;
    reg [0:31] tmp;
    
    reg [0:127] round_k [0:32];
    
    reg [0:127] s_box_in;
    wire [0:127] s_box_out;
    
    sbox_e_top s_box (
        .in_bits(s_box_in),
        .out_bits(s_box_out),
        .box_num((32 + 3-j)%8) /// FIX THIS
    );
    
    always @(key)
    begin
    
        //key to prekey
        prekey[-8] = key[0 +: 32];
        prekey[-7] = key[32 +: 32];
        prekey[-6] = key[64 +: 32];
        prekey[-5] = key[96 +: 32];
        prekey[-4] = key[128 +: 32];
        prekey[-3] = key[160 +: 32];
        prekey[-2] = key[192 +: 32];
        prekey[-1] = key[224 +: 32];
        
        repeat (2) @(posedge clk);
        //generating prekey
        for( i=0; i<=131; i=i+1)
        begin         
            repeat (2) @(posedge clk);
            tmp = (prekey[i-8] ^ prekey[i-5] ^ prekey[i-3] ^ prekey[i-1] ^ fi ^ i_little_endian);
            prekey[i] = {tmp[21:31], tmp[0:20]}; // prekey = tmp <<< 11;
        end   
        
        // generate keys from prekey - pass through s-boxes
        for(j=0; j<33; j=j+1)
        begin
            s_box_in = { prekey[j*4], prekey[j*4+1], prekey[j*4+2], prekey[j*4+3] };
            repeat (2) @(posedge clk);
            round_k[j] = s_box_out;
            round_keys[j*128 +: 128] = s_box_out;            
        end        
        
        repeat (2) @(posedge clk);
    end    
    
endmodule
