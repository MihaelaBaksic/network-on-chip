`timescale 1ns / 1ps


module encryptor_tb();

reg [0:127] round_data;
reg [0:127] mixed_data;
wire [0:127] boxed_data;
reg [0:127] inv_data;

integer round;
integer expand = 1;

//reg [127:0] round_keys [0:32]; // 33 * 128b subkeys
wire [0:128*33-1] round_keys;

reg [0:31] x0;
reg [0:31] x1;
reg [0:31] x2;
reg [0:31] x3;

// instantiate sbox_e_top module
sbox_e_top sboxes (
    .in_bits(mixed_data),
    .out_bits(boxed_data),
    .box_num(round % 8)
);

reg [0:255] key;

reg clk;

key_scheduler keys (.key(key), .round_keys(round_keys), .clk(clk));

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

    key = 255'b0101111101111011001111010101100100011110011010100010110001001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    
    if(expand == 1)
        begin
            repeat (1000) @(posedge clk);
            expand = 0;
        end
    
    round_data = 128'h0000_0000_0000_0000_0000_0000_0000_0000; 
    

        for(round=0; round < 31; round = round+1)
        begin
        
            // key mixing
            mixed_data = round_data ^ round_keys[round*128 +: 128]; // data = data xor subkey
            
            // s-box pass will happen here 
            repeat (2) @(posedge clk);
            
            // prepare boxed data for linear transformation    
            x0 = boxed_data[0:31];
            x1 = boxed_data[32:63];
            x2 = boxed_data[64:95];
            x3 = boxed_data[96:127];
            
            //linear transformation          
            x0 = {x0[32-13: 31], x0[0:31-13]}; // x0 = x0 <<< 13
            x2 = {x2[32-3:31], x2[0:31-3]}; // x2 = x2 <<< 3
            x1 = x1 ^ x0 ^ x2;
            x3 = x3 ^ x2 ^ (x0 >> 3);
            x1 = {x1[31], x1[0:31-1]}; // x1 = x1 <<< 1
            x3 = {x3[32-7: 31], x3[0:31-7]}; // x3 = x3 <<< 7
            x0 = x0 ^ x1 ^ x3;
            x2 = x2 ^ x3 ^ (x1 >> 7);
            x0 = {x0[32-5:31], x0[0:31-5]}; // x0 = x0 <<< 5
            x2 = {x2[32-22: 31], x2[0: 31-22]}; // x2 = x2 <<< 22
             
            round_data = {x0, x1, x2, x3};   
          
        end
        
        // Final round
        repeat (2) @(posedge clk);
        mixed_data = round_data ^ round_keys[31*128 +: 128];
        round = 31;
        //s-box pass happens here;
        repeat (2) @(posedge clk);
        inv_data = boxed_data ^ round_keys[32*128 +: 128]; 

        repeat (2) @(posedge clk);
end


endmodule
