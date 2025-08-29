//============================================================================= 
// ASYNCHRONOUS FIFO TESTBENCH 
// Description: Testbench with independent clock domains for async FIFO 
// Author: Teja Reddy
//============================================================================= 
 
 
 
`timescale 1ns/1ps 
 
module async_fifo_tb; 
 
    // Testbench parameters 
    parameter DATA_WIDTH = 8; 
    parameter FIFO_DEPTH = 16; 
    parameter PTR_WIDTH = 5; 
    parameter WR_CLK_PERIOD = 8;   // 125MHz write clock 
    parameter RD_CLK_PERIOD = 12;  // 83.3MHz read clock 
     
    // Testbench signals 
    reg                    wr_clk, rd_clk; 
    reg                    wr_rst_n, rd_rst_n; 
    reg                    wr_en, rd_en; 
    reg  [DATA_WIDTH-1:0]  data_in; 
    wire [DATA_WIDTH-1:0]  data_out; 
    wire                   full, empty; 
     
    // Test control variables 
    integer wr_count, rd_count, error_count; 
    reg [DATA_WIDTH-1:0] test_pattern; 
     
    // Instantiate DUT (Device Under Test) 
    async_fifo #( 
        .DATA_WIDTH(DATA_WIDTH), 
        .FIFO_DEPTH(FIFO_DEPTH), 
        .PTR_WIDTH(PTR_WIDTH) 
    ) dut ( 
        .wr_clk(wr_clk), 
        .wr_rst_n(wr_rst_n), 
        .wr_en(wr_en), 
        .data_in(data_in), 
        .full(full), 
        .rd_clk(rd_clk), 
        .rd_rst_n(rd_rst_n), 
        .rd_en(rd_en), 
        .data_out(data_out), 
        .empty(empty) 
    ); 
     
    // Write clock generation (125MHz) 
    initial begin 
        wr_clk = 0; 
        forever #(WR_CLK_PERIOD/2) wr_clk = ~wr_clk; 
    end 
     
    // Read clock generation (83.3MHz)  
    initial begin 
 
 
        rd_clk = 0; 
        forever #(RD_CLK_PERIOD/2) rd_clk = ~rd_clk; 
    end 
     
    // Write domain test process 
    initial begin 
        wr_rst_n = 0; 
        wr_en = 0; 
        data_in = 0; 
        wr_count = 0; 
         
        // Reset sequence 
        #(WR_CLK_PERIOD * 5); 
        wr_rst_n = 1; 
        #(WR_CLK_PERIOD * 2); 
         
        $display("=== ASYNC FIFO WRITE PROCESS STARTED ==="); 
         
        // Write data continuously 
        repeat(50) begin 
            @(posedge wr_clk); 
            if (!full) begin 
                wr_en = 1; 
                data_in = wr_count[7:0];  // Write incrementing pattern 
                wr_count = wr_count + 1; 
                $display("Write: %0t - Data=%02h, Count=%0d, Full=%b",  
                         $time, data_in, wr_count, full); 
            end else begin 
                wr_en = 0; 
                $display("Write: %0t - FIFO FULL, waiting...", $time); 
            end 
            @(posedge wr_clk); 
            wr_en = 0; 
             
            // Add random delays 
            repeat($random % 3) @(posedge wr_clk); 
        end 
         
        $display("=== WRITE PROCESS COMPLETED ==="); 
    end 
     
    // Read domain test process   
    initial begin 
        rd_rst_n = 0; 
        rd_en = 0; 
        rd_count = 0; 
        error_count = 0; 
         
        // Reset sequence 
        #(RD_CLK_PERIOD * 8); 
 
 
        rd_rst_n = 1; 
        #(RD_CLK_PERIOD * 3); 
         
        $display("=== ASYNC FIFO READ PROCESS STARTED ==="); 
         
        // Read data continuously 
        repeat(60) begin 
            @(posedge rd_clk); 
            if (!empty) begin 
                rd_en = 1; 
                @(posedge rd_clk); 
                rd_en = 0; 
                 
                // Verify data integrity 
                if (data_out == rd_count[7:0]) begin 
                    $display("Read:  %0t - Data=%02h, Count=%0d, Empty=%b ",  
                             $time, data_out, rd_count, empty); 
                end else begin 
                    $display("Read:  %0t - Data=%02h, Expected=%02h, ERROR!",  
                             $time, data_out, rd_count[7:0]); 
                    error_count = error_count + 1; 
                end 
                rd_count = rd_count + 1; 
            end else begin 
                $display("Read:  %0t - FIFO EMPTY, waiting...", $time); 
                rd_en = 0; 
            end 
             
            // Add random delays 
            repeat($random % 4) @(posedge rd_clk); 
        end 
         
        $display("=== READ PROCESS COMPLETED ==="); 
       
                // Final results 
        #(RD_CLK_PERIOD * 10); 
        $display("\n=== ASYNC FIFO TESTBENCH COMPLETED ==="); 
        $display("Total Errors: %0d", error_count); 
         
        if (error_count == 0) 
            $display("*** ALL ASYNC FIFO TESTS PASSED ***"); 
        else 
            $display("*** ASYNC FIFO TESTS FAILED ***"); 
             
        $finish; 
    end 
    // Optional: Generate waveform for visualization 
    initial begin 
        $dumpfile("async_fifo_tb.vcd"); 
 
 
        $dumpvars(0, async_fifo_tb); 
    end 
endmodule 
