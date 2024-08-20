`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2024 15:23:58
// Design Name: 
// Module Name: axis_fifo_tb
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

/// Testbench of Synconous fifo 

// timescale precision

`define clk_period 10

module fifo_buffer_tb ();
reg clk;
reg reset;

// write_side pins

reg wr_en_i ;// t_valid
reg [7:0] data_in;
wire fifo_full_wr_o;    // count == DEPTH

// Read side pins

reg rd_en_i;
wire [7:0] data_out;
wire fifo_empty_rd_o;    // count == 0


// crerate DUT (device under test)

fifo_buffer dut (
.clk(clk),
.reset(reset),

.wr_en_i(wr_en_i),
.data_in(data_in),
.fifo_full_wr_o(fifo_full_wr_o),

.rd_en_i(rd_en_i),
.data_out(data_out),
.fifo_empty_rd_o(fifo_empty_rd_o)

);
/// initial block for clk

initial 
clk = 1'b1;
always #(`clk_period/2) clk = ~clk;

// initial blcok for reset , wr_en_i,rd_en_i,data_in
integer i ;

initial begin
reset = 1'b1;    // starting 
wr_en_i = 1'b0;
rd_en_i = 1'b0;
data_in = 8'b0;

#
(`clk_period);
 reset <= 1'b0;

#
(`clk_period) ;
reset <= 1'b1 ;// finish the reset system



// write the data_write (data_in logic)

//initial begin
wr_en_i <= 1'b1;
rd_en_i <= 1'b0;

// using for loop to write the data

for ( i = 0 ; i<8 ; i = i+1) begin
      data_in = i;
     #(`clk_period);
end




// read_data

//initial begin
wr_en_i <= 1'b0;
rd_en_i <= 1'b1;

// using for loop to read the data by accessing the index;

 for (i = 0 ; i<8 ; i= i+1) begin
   #(`clk_period) ;
end



// write the data again to check the control (optional)
//initial begin
wr_en_i <= 1'b1;
rd_en_i <= 1'b0;

// using for loop to write the data

for ( i = 0 ; i<8 ; i = i+1) begin
      data_in = i;
     #(`clk_period);
end




// use three clock period or clk signal to end the process:

#(`clk_period);
#(`clk_period);
#(`clk_period);



$stop ;// stop the simulation


end



endmodule
