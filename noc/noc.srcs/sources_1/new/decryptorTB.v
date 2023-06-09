`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
`define X 2
`define Y 2
`define data_width 128
`define pck_num 14

`define iter `data_width/8
`define imageSize 16
`timescale 1ns/1ps

`define x_size $clog2(`X)
`define y_size $clog2(`Y)
`define total_width  (`x_size+`y_size+`pck_num+`data_width)



module decryptorTB();

reg  clk;
reg  [127:0] o_data;

wire [127:0] tb_o_data_pci;
wire tb_o_ready_pci ;
reg tb_i_ready_pci=1'b1;
reg tb_i_valid_pci;
wire tb_o_valid_pci;
reg sendDone=0;
integer file;
integer file1;
integer x;
integer counter;
reg[127:0]image_data;
integer rtn;
integer rtn1;
reg rst;

initial
begin
file=$fopen("../../../../data/data_o.txt","rb");
file1=$fopen("../../../../data/plain_d.txt","wb");
if(file == 0)
begin
    $display("Cannot open the data file");
    $fclose(file);
    $fclose(file1);
    $finish;
end
 //for(i=0;i<320;i=i+1)
 //begin
 //  rtn = $fscanf(file,"%c",file_data);
 //  $fwrite(file1,"%c",file_data);  
 // end
    
    clk = 1'b0;
     counter=0;
      forever
      begin
          clk = ~clk;
            #1;
      end
    end
    
    initial
    begin
        rst = 0;
        #10;
        rst = 1;
    end


always@(posedge clk)
begin
    if(tb_o_ready_pci & !sendDone)
    begin
        for(x=0;x<`iter;x=x+1)
            rtn = $fscanf(file,"%c",image_data[x*8+:8]);
        o_data =image_data;
        tb_i_valid_pci=1'b1;
        if($feof(file))
        begin
            $fclose(file);
            sendDone = 1'b1;
        end
        else
        begin
            sendDone=1'b0;
        end
    end
    else if(tb_i_valid_pci & ~tb_o_ready_pci)
    begin
        tb_i_valid_pci<=1'b1;
    end
    else
        tb_i_valid_pci<=1'b0;
 end

 
integer y;
always @(posedge clk)
begin
    if(counter < `imageSize)
    begin
        if(tb_o_valid_pci)
        begin
            for(y=0;y<`iter;y=y+1)
                $fwrite(file1,"%c",tb_o_data_pci[y*8+:8]);
            counter = counter + 16;
        end
    end
    else
    begin
        $fclose(file1);
        $stop;
    end
end

wire [(`X*`Y)-1:0] r_valid_pe;
wire [(`total_width*`X*`Y)-1:0] r_data_pe;
wire [(`X*`Y)-1:0] r_ready_pe;
wire [(`X*`Y)-1:0] w_valid_pe;
wire [(`total_width*`X*`Y)-1:0] w_data_pe;
wire [(`X*`Y)-1:0] w_ready_pe;
    
    openNocTop #(.X(`X),.Y(`Y),.data_width(`data_width),.pkt_no_field_size(`pck_num))
    ON
    (
    .clk(clk),
    .rstn(rst),
    .r_valid_pe(r_valid_pe),
    .r_data_pe(r_data_pe),
    .r_ready_pe(r_ready_pe),
    .w_valid_pe(w_valid_pe),
    .w_data_pe(w_data_pe),
    .w_ready_pe(w_ready_pe)
    );


    procTopD #(.X(`X),.Y(`Y),.data_width(`data_width),.pck_num(`pck_num))
    pT(
    .clk(clk),
    .rstn(rst),
    //PE interfaces
    .r_valid_pe(r_valid_pe),
    .r_data_pe(r_data_pe),
    .r_ready_pe(r_ready_pe),
    .w_valid_pe(w_valid_pe),
    .w_data_pe(w_data_pe),
    .w_ready_pe(w_ready_pe),
    //PCIe interfaces
    .i_valid(tb_i_valid_pci),
    .i_data(o_data),
    .o_ready(tb_o_ready_pci),
    .o_data(tb_o_data_pci),
    .o_valid(tb_o_valid_pci),
    .i_ready(tb_i_ready_pci)
    );

endmodule