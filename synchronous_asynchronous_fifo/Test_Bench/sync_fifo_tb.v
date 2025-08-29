//============================================================================= 
// SYNCHRONOUS FIFO TESTBENCH 
// Description: Comprehensive testbench for synchronous FIFO verification 
// Author: Teja Reddy
//============================================================================= 
 
`timescale 1ns/1ps 
 
module sync_fifo_tb; 
 
    // Testbench parameters 
    parameter DATA_WIDTH = 8; 
    parameter FIFO_DEPTH = 16; 
    parameter PTR_WIDTH = 5; 
    parameter CLK_PERIOD = 10;  // 100MHz clock 
     
    // Testbench signals 
    reg                    clk; 
    reg                    rst_n; 
    reg                    wr_en; 
    reg                    rd_en; 
    reg  [DATA_WIDTH-1:0]  data_in; 
    wire [DATA_WIDTH-1:0]  data_out; 
    wire                   full; 
    wire                   empty; 
     
    // Test control variables 
    reg [DATA_WIDTH-1:0] write_data; 
    reg [DATA_WIDTH-1:0] expected_data; 
    integer i, error_count; 
     
    // Instantiate DUT (Device Under Test) 
    sync_fifo #( 
        .DATA_WIDTH(DATA_WIDTH), 
        .FIFO_DEPTH(FIFO_DEPTH),  
        .PTR_WIDTH(PTR_WIDTH) 
    ) dut ( 
        .clk(clk), 
        .rst_n(rst_n), 
        .wr_en(wr_en), 
 
 
        .rd_en(rd_en), 
        .data_in(data_in), 
        .data_out(data_out), 
        .full(full), 
        .empty(empty) 
    ); 
     
    // Clock generation - 100MHz system clock 
    initial begin 
        clk = 0; 
        forever #(CLK_PERIOD/2) clk = ~clk; 
    end 
     
    // Main test sequence 
    initial begin 
        // Initialize signals 
        rst_n = 0; 
        wr_en = 0; 
        rd_en = 0; 
        data_in = 0; 
        write_data = 8'h00; 
        error_count = 0; 
         
        $display("=== SYNCHRONOUS FIFO TESTBENCH STARTED ==="); 
        $display("Time\t\tOperation\tData_in\tData_out\tFull\tEmpty"); 
         
        // Reset sequence 
        #(CLK_PERIOD * 2); 
        rst_n = 1; 
        #(CLK_PERIOD); 
         
        // Test 1: Verify initial empty condition 
        $display("%0t\tRESET\t\t%02h\t%02h\t%b\t%b",  
                 $time, data_in, data_out, full, empty); 
        if (!empty) begin 
            $display("ERROR: FIFO should be empty after reset"); 
            error_count = error_count + 1; 
        end 
         
        // Test 2: Fill FIFO completely (test full condition) 
        $display("\n--- Test 2: Filling FIFO ---"); 
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin 
            @(posedge clk); 
            wr_en = 1; 
            data_in = i + 1;  // Write data 1,2,3...16 
            @(posedge clk); 
            wr_en = 0; 
            $display("%0t\tWRITE\t\t%02h\t%02h\t%b\t%b",  
                     $time, data_in, data_out, full, empty); 
        end 
 
 
         
        // Verify full condition 
        if (!full) begin 
            $display("ERROR: FIFO should be full after 16 writes"); 
            error_count = error_count + 1; 
        end 
         
        // Test 3: Try writing to full FIFO (should be ignored) 
        @(posedge clk); 
        wr_en = 1; 
        data_in = 8'hFF;  // This should not be written 
        @(posedge clk); 
        wr_en = 0; 
        $display("%0t\tWRITE(FULL)\t%02h\t%02h\t%b\t%b",  
                 $time, data_in, data_out, full, empty); 
         
        // Test 4: Read all data from FIFO (verify FIFO order) 
        $display("\n--- Test 4: Reading FIFO ---"); 
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin 
            expected_data = i + 1;  // Expected data 1,2,3...16 
            @(posedge clk); 
            rd_en = 1; 
            @(posedge clk); 
            rd_en = 0; 
            $display("%0t\tREAD\t\t%02h\t%02h\t%b\t%b",  
                     $time, data_in, data_out, full, empty); 
                      
            // Verify read data 
            if (data_out !== expected_data) begin 
                $display("ERROR: Expected %02h, got %02h", expected_data, data_out); 
                error_count = error_count + 1; 
            end 
        end 
         
        // Verify empty condition 
        if (!empty) begin 
            $display("ERROR: FIFO should be empty after 16 reads"); 
            error_count = error_count + 1; 
        end 
         
        // Test 5: Try reading from empty FIFO 
        @(posedge clk); 
        rd_en = 1; 
        @(posedge clk); 
        rd_en = 0; 
        $display("%0t\tREAD(EMPTY)\t%02h\t%02h\t%b\t%b",  
                 $time, data_in, data_out, full, empty); 
         
        // Test 6: Simultaneous read/write operations   
        $display("\n--- Test 6: Simultaneous Read/Write ---"); 
 
 
         
        // Write some initial data 
        for (i = 0; i < 8; i = i + 1) begin 
            @(posedge clk); 
            wr_en = 1; 
            data_in = 8'hA0 + i; 
            @(posedge clk); 
            wr_en = 0; 
        end 
         
        // Simultaneous read/write 
        for (i = 0; i < 5; i = i + 1) begin 
            @(posedge clk); 
            wr_en = 1; 
            rd_en = 1; 
            data_in = 8'hB0 + i; 
            @(posedge clk); 
            wr_en = 0; 
            rd_en = 0; 
            $display("%0t\tRD/WR\t\t%02h\t%02h\t%b\t%b",  
                     $time, data_in, data_out, full, empty); 
        end 
         
        // Final test summary 
        #(CLK_PERIOD * 5); 
        $display("\n=== TESTBENCH COMPLETED ==="); 
        $display("Total Errors: %0d", error_count); 
         
        if (error_count == 0) 
            $display("*** ALL TESTS PASSED ***"); 
        else 
            $display("*** TESTS FAILED ***"); 
             
        $finish; 
    end 
     
    // Optional: Generate VCD waveform file 
    initial begin 
        $dumpfile("sync_fifo_tb.vcd"); 
        $dumpvars(0, sync_fifo_tb); 
    end 
     
endmodule
