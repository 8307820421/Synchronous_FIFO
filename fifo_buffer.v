`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2024 13:19:31
// Design Name: 
// Module Name: fifo_buffer
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

// syncronous fifo :
module fifo_buffer #(

 parameter data_in_width = 64, // 64 bit            64 64 64 64 64 64 64 64 64
 parameter DEPTH = 8// mem_size // address location 0  1  2  3  4  5  6  7  8
 
)

(
input clk,
input reset,

// write_side pins

input wr_en_i ,// t_valid
input [data_in_width - 1 :0] data_in,
output fifo_full_wr_o, // count == DEPTH

// Read side pins

input rd_en_i,
output reg [7:0] data_out,
output fifo_empty_rd_o// count == 0


    );

// totl data depth = 8bit . indexing upto 8 to write 8bit data at 8 location

//parameter DEPTH = 8; // mem_size
reg [data_in_width - 1 :0]mem[0:DEPTH - 1];

//wr_ptr and rd_ptr depth  is 8 as hence it 2^n : n == 3 bit 

reg [2:0] wr_ptr;
reg [2:0] rd_ptr;

// counter is 4 bit to track the data at what index.

reg [3:0] count=0;

// data flow modelling // fifo_full_out == 1'b1 if count == DEPTH

assign fifo_full_wr_o = (count == (DEPTH)) ? 1'b1 : 0;

// rd side 

assign fifo_empty_rd_o = (count == 0) ? 1'b1 :0;

// handle write pointer (wr_ptr) point to data at index

always @ (posedge clk or negedge reset) begin
if (!reset) begin
  wr_ptr <= 0;
end
else begin

if (wr_en_i == 1'b1) begin
   mem[wr_ptr] <= data_in;
   wr_ptr <= wr_ptr + 1;     // point to next location or address where data write
end

end

end

/// handle the read side ////

always @ (posedge clk or negedge reset) begin
if (!reset) begin
    rd_ptr <= 0;
  end

else begin
    if (rd_en_i == 1'b1) begin
     data_out <= mem[rd_ptr];
     rd_ptr <= rd_ptr + 1;
end
end
end

//// handle the count value ////

always @ (posedge clk or negedge reset) begin
   if (!reset) begin
   count <= 0;
  end
   else begin
   case ({wr_en_i, rd_en_i})
    
 // counter loic 
 
    // wr_en (active open)

    2'b10 : count <= count + 1;  //// wr_en (active open)
    2'b01 : count <= count-1;  // rd_en_ i (counter decrese)
    2'b11 : count <= 0; // (wr_en == rd_en ) (counter set to 0)
    2'b10 : count <= 0;
    
    default : count <= count;
endcase

   end
end

endmodule
