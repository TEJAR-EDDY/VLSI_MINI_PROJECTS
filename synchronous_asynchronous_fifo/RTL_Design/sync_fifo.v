//============================================================================= 
// SYNCHRONOUS FIFO DESIGN 
// Description: 16-deep, 8-bit synchronous FIFO with full/empty flags 
// Author: Teja Reddy
//============================================================================= 
 
module sync_fifo #( 
    parameter DATA_WIDTH = 8,           // Width of data bus 
    parameter FIFO_DEPTH = 16,          // Number of FIFO locations 
    parameter PTR_WIDTH = 5             // Pointer width (log2(DEPTH) + 1) 
)( 
    input  wire                    clk,      // System clock 
    input  wire                    rst_n,    // Active low reset 
    input  wire                    wr_en,    // Write enable signal 
    input  wire                    rd_en,    // Read enable signal 
    input  wire [DATA_WIDTH-1:0]   data_in,  // Input data 
    output reg  [DATA_WIDTH-1:0]   data_out, // Output data 
    output wire                    full,     // FIFO full flag 
    output wire                    empty     // FIFO empty flag 
); 
 
    // Internal memory array - dual port for simultaneous access 
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1]; 
     
    // Read and write pointers - extra bit for full/empty detection 
    reg [PTR_WIDTH-1:0] wr_ptr;  // Write pointer 
    reg [PTR_WIDTH-1:0] rd_ptr;  // Read pointer 
     
    // Internal signals for pointer manipulation 
 
 
    wire [PTR_WIDTH-2:0] wr_addr;  // Write address (pointer without MSB) 
    wire [PTR_WIDTH-2:0] rd_addr;  // Read address (pointer without MSB) 
     
    // Extract addresses from pointers (remove MSB) 
    assign wr_addr = wr_ptr[PTR_WIDTH-2:0]; 
    assign rd_addr = rd_ptr[PTR_WIDTH-2:0]; 
     
    // Flag generation logic 
    assign full  = (wr_ptr == {~rd_ptr[PTR_WIDTH-1], rd_ptr[PTR_WIDTH-2:0]}); 
    assign empty = (wr_ptr == rd_ptr); 
     
    // Write operation - stores data when write enabled and FIFO not full 
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            wr_ptr <= 0;                    // Reset write pointer 
        end 
        else if (wr_en && !full) begin 
            fifo_mem[wr_addr] <= data_in;   // Store data in memory 
            wr_ptr <= wr_ptr + 1;           // Increment write pointer 
        end 
    end 
     
    // Read operation - outputs data when read enabled and FIFO not empty 
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            rd_ptr <= 0;                    // Reset read pointer 
            data_out <= 0;                  // Clear output data 
        end 
        else if (rd_en && !empty) begin 
            data_out <= fifo_mem[rd_addr];  // Output data from memory 
            rd_ptr <= rd_ptr + 1;           // Increment read pointer 
        end 
    end 
     
endmodule 
