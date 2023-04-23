`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module Encryptor #(parameter total_width=0, x_size=0, y_size=0, pck_num=0) (
        input wire clk,
        input wire rst,
        input wire [total_width-1:0] i_data,
        input wire i_valid,
        output wire [total_width-1:0] o_data,
        output wire o_valid,
        input wire i_ready,
        output wire o_ready
    );
    
integer x;
integer recvCounter=0;
reg fifoWrEn;
reg [total_width-1:0] inv_data;
assign o_ready = 1'b1;

reg [0:127] round_data;
reg [0:127] mixed_data;
wire [0:127] boxed_data;
reg [total_width-1:0] inputs;

integer round;
integer expand = 1;

wire [0:128*33-1] round_keys;; // 33 * 128b subkeys

reg [0:31] x0;
reg [0:31] x1;
reg [0:31] x2;
reg [0:31] x3;

myFifo fifo (
  .s_axis_aresetn(rst),          // input wire s_axis_aresetn
  .s_axis_aclk(clk),                // input wire s_axis_aclk
  .s_axis_tvalid(fifoWrEn),            // input wire s_axis_tvalid
  .s_axis_tready(),            // output wire s_axis_tready
  .s_axis_tdata(inv_data),              // input wire [15 : 0] s_axis_tdata
  .m_axis_tvalid(o_valid),            // output wire m_axis_tvalid
  .m_axis_tready(i_ready),            // input wire m_axis_tready
  .m_axis_tdata(o_data),              // output wire [15 : 0] m_axis_tdata
  //.axis_data_count(),        // output wire [31 : 0] axis_data_count
  .axis_wr_data_count(),  // output wire [31 : 0] axis_wr_data_count
  .axis_rd_data_count()  // output wire [31 : 0] axis_rd_data_count
);


// instantiate sbox_e_top module
sbox_e_top sboxes (
    .in_bits(mixed_data),
    .out_bits(boxed_data),
    .box_num(round % 8)
);

reg [0:255] key;

key_scheduler keys (.key(key), .round_keys(round_keys), .clk(clk));

always @(posedge clk)
begin
    if(i_valid & o_ready)
    begin
        recvCounter <= recvCounter+1;
        
        inputs = i_data;
        
        key = 255'b0101111101111011001111010101100100011110011010100010110001001000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        // perform key expansion - calculate round keys
        if(expand == 1)
        begin
            repeat (1000) @(posedge clk);
            expand = 0;
        end
        
        
        round_data = inputs[total_width-1: x_size+y_size+pck_num];

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
        inv_data[total_width-1 : x_size+y_size+pck_num] = boxed_data ^ round_keys[32*128 +: 128]; 

        repeat (2) @(posedge clk);  
        
        //inv_data[total_width-1 : x_size+y_size+pck_num] = i_data[total_width-1 : x_size+y_size+pck_num];
        
        inv_data[x_size+y_size-1:0] = 'h0; // set the receiver to (0, 0)          
        inv_data[x_size+y_size+pck_num-1:y_size+x_size]=inputs[x_size+y_size+pck_num-1:y_size+x_size]; // set the packet number
        
        fifoWrEn = 1'b1;
    end 
    else if(fifoWrEn & ~o_ready)
       fifoWrEn <= 1'b1;
    else
       fifoWrEn <= 1'b0;  
    
end
    
endmodule







