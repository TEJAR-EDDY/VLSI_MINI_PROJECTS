//============================================================================= 
// ASYNCHRONOUS FIFO DESIGN 
// Description: 16-deep, 8-bit async FIFO with Gray code pointers 
// Author: Teja Reddy
//============================================================================= 
 
module async_fifo #( 
    parameter DATA_WIDTH = 8,           // Width of data bus 
    parameter FIFO_DEPTH = 16,          // Number of FIFO locations   
    parameter PTR_WIDTH = 5             // Pointer width (log2(DEPTH) + 1) 
)( 
    // Write domain signals 
 
 
    input  wire                    wr_clk,   // Write domain clock 
    input  wire                    wr_rst_n, // Write domain reset 
    input  wire                    wr_en,    // Write enable 
    input  wire [DATA_WIDTH-1:0]   data_in,  // Input data 
    output wire                    full,     // FIFO full flag 
     
    // Read domain signals   
    input  wire                    rd_clk,   // Read domain clock 
    input  wire                    rd_rst_n, // Read domain reset 
    input  wire                    rd_en,    // Read enable 
    output reg  [DATA_WIDTH-1:0]   data_out, // Output data 
    output wire                    empty     // FIFO empty flag 
); 
 
    // Memory array - accessed from both clock domains 
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1]; 
     
    // Gray code counters for write and read pointers 
    reg [PTR_WIDTH-1:0] wr_gray_ptr, wr_gray_next; 
    reg [PTR_WIDTH-1:0] rd_gray_ptr, rd_gray_next; 
     
    // Binary counters (for memory addressing) 
    reg [PTR_WIDTH-1:0] wr_bin_ptr, wr_bin_next; 
    reg [PTR_WIDTH-1:0] rd_bin_ptr, rd_bin_next; 
     
    // Synchronized Gray pointers (cross clock domain) 
    reg [PTR_WIDTH-1:0] wr_gray_sync, wr_gray_sync_ff; 
    reg [PTR_WIDTH-1:0] rd_gray_sync, rd_gray_sync_ff; 
     
    // Memory addresses (binary pointers without MSB) 
    wire [PTR_WIDTH-2:0] wr_addr, rd_addr; 
    assign wr_addr = wr_bin_ptr[PTR_WIDTH-2:0]; 
    assign rd_addr = rd_bin_ptr[PTR_WIDTH-2:0]; 
     
    //------------------------------------------------------------------------- 
    // WRITE DOMAIN LOGIC 
    //------------------------------------------------------------------------- 
     
    // Write pointer generation (binary to Gray code conversion) 
    always @(*) begin 
        wr_bin_next = wr_bin_ptr + (wr_en & ~full); 
        wr_gray_next = (wr_bin_next >> 1) ^ wr_bin_next;  // Binary to Gray 
    end 
     
    // Write pointer registers 
    always @(posedge wr_clk or negedge wr_rst_n) begin 
        if (!wr_rst_n) begin 
            wr_bin_ptr  <= 0; 
            wr_gray_ptr <= 0; 
        end 
 
 
        else begin 
            wr_bin_ptr  <= wr_bin_next; 
            wr_gray_ptr <= wr_gray_next; 
        end 
    end 
     
    // Write operation - store data in memory 
    always @(posedge wr_clk) begin 
        if (wr_en && !full) 
            fifo_mem[wr_addr] <= data_in; 
    end 
     
    // Synchronize read Gray pointer to write clock domain 
    always @(posedge wr_clk or negedge wr_rst_n) begin 
        if (!wr_rst_n) begin 
            rd_gray_sync_ff <= 0; 
            rd_gray_sync    <= 0; 
        end 
        else begin 
            rd_gray_sync_ff <= rd_gray_ptr;      // First FF 
            rd_gray_sync    <= rd_gray_sync_ff;  // Second FF (synchronized) 
        end 
    end 
     
    // Full flag generation - compare write pointer with synchronized read pointer 
    assign full = (wr_gray_next == {~rd_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2],  
                                    rd_gray_sync[PTR_WIDTH-3:0]}); 
     
    //------------------------------------------------------------------------- 
    // READ DOMAIN LOGIC   
    //------------------------------------------------------------------------- 
     
    // Read pointer generation (binary to Gray code conversion) 
    always @(*) begin 
        rd_bin_next = rd_bin_ptr + (rd_en & ~empty); 
        rd_gray_next = (rd_bin_next >> 1) ^ rd_bin_next;  // Binary to Gray 
    end 
     
    // Read pointer registers 
    always @(posedge rd_clk or negedge rd_rst_n) begin 
        if (!rd_rst_n) begin 
            rd_bin_ptr  <= 0; 
            rd_gray_ptr <= 0; 
        end 
        else begin 
            rd_bin_ptr  <= rd_bin_next; 
            rd_gray_ptr <= rd_gray_next; 
        end 
    end 
     
 
 
    // Read operation - output data from memory 
    always @(posedge rd_clk or negedge rd_rst_n) begin 
        if (!rd_rst_n) 
            data_out <= 0; 
        else if (rd_en && !empty) 
            data_out <= fifo_mem[rd_addr]; 
    end 
     
    // Synchronize write Gray pointer to read clock domain 
    always @(posedge rd_clk or negedge rd_rst_n) begin 
        if (!rd_rst_n) begin 
            wr_gray_sync_ff <= 0; 
            wr_gray_sync    <= 0; 
        end 
        else begin 
            wr_gray_sync_ff <= wr_gray_ptr;      // First FF   
            wr_gray_sync    <= wr_gray_sync_ff;  // Second FF (synchronized) 
        end 
    end 
     
    // Empty flag generation - compare read pointer with synchronized write pointer 
    assign empty = (rd_gray_next == wr_gray_sync); 
    
endmodule
