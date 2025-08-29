// ============================================================================
// Comprehensive Testbench for Single Port Memory System
// Description: Complete verification environment for RAM/ROM testing
// Includes: Synchronous RAM, Asynchronous RAM, Synchronous ROM, Asynchronous ROM
// Author: Teja Reddy
// ============================================================================

`timescale 1ns/1ps  // Time unit: 1ns, Time precision: 1ps

module tb_memory_system;

    // Clock and Reset signals
    reg clk;                    // System clock for synchronous operations
    reg rst;                    // Global reset signal

    // Control signals
    reg en;                     // Memory enable
    reg we;                     // Write enable for RAM operations

    // Address and Data signals
    reg [3:0] addr;             // 4-bit address (0 to 15)
    reg [7:0] data_in;          // Input data for write operations

    // Output signals from different memory types
    wire [7:0] sync_ram_out;    // Output from synchronous RAM
    wire [7:0] async_ram_out;   // Output from asynchronous RAM
    wire [7:0] rom_out;         // Output from synchronous ROM
    wire [7:0] async_rom_out;   // Output from asynchronous ROM

    // Test control variables
    integer test_count = 0;     // Test case counter
    integer error_count = 0;    // Error counter for verification

    // Instantiate Synchronous RAM
    sync_single_port_ram sync_ram (
        .clk(clk),
        .rst(rst),
        .en(en),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(sync_ram_out)
    );

    // Instantiate Asynchronous RAM
    async_single_port_ram async_ram (
        .rst(rst),
        .en(en),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(async_ram_out)
    );

    // Instantiate Synchronous ROM
    single_port_rom rom (
        .clk(clk),
        .en(en),
        .addr(addr),
        .data_out(rom_out)
    );

    // Instantiate Asynchronous ROM
    async_single_port_rom async_rom (
        .en(en),
        .addr(addr),
        .data_out(async_rom_out)
    );

    // Clock generation: 10ns period (100MHz frequency)
    always #5 clk = ~clk;

    // Main test sequence
    initial begin
        // Initialize simulation environment
        $dumpfile("memory_simulation.vcd");  // Create waveform file
        $dumpvars(0, tb_memory_system);      // Dump all variables

        // Display test start information
        $display("====================================================");
        $display("Starting Single Port Memory System Verification");
        $display("====================================================");

        // Initialize all signals to known values
        clk = 0;
        rst = 1;        // Start with reset active
        en = 0;         // Memory disabled initially
        we = 0;         // Start in read mode
        addr = 4'h0;    // Start with address 0
        data_in = 8'h00;// Initialize input data

        // Wait for initial setup
        #15;

        // Release reset and start testing
        rst = 0;
        #10;

        // Test Case 1: ROM Read Operations
        $display("\n--- Test Case 1: ROM Read Operations ---");
        test_rom_operations();

        // Test Case 2: Synchronous RAM Operations
        $display("\n--- Test Case 2: Synchronous RAM Operations ---");
        test_sync_ram_operations();

        // Test Case 3: Asynchronous RAM Operations
        $display("\n--- Test Case 3: Asynchronous RAM Operations ---");
        test_async_ram_operations();

        // Test Case 4: Asynchronous ROM Operations
        $display("\n--- Test Case 4: Asynchronous ROM Operations ---");
        test_async_rom_operations();

        // Test Case 5: Reset Functionality
        $display("\n--- Test Case 5: Reset Functionality ---");
        test_reset_functionality();

        // Test Case 6: Enable/Disable Control
        $display("\n--- Test Case 6: Enable/Disable Control ---");
        test_enable_control();

        // Display final results
        display_test_results();

        // End simulation
        #50;
        $finish;
    end

    // Task: Test ROM read operations (synchronous ROM)
    task test_rom_operations;
        integer i;
        begin
            $display("Testing synchronous ROM read operations...");
            en = 1;  // Enable ROM
            we = 0;  // ROM is always in read mode

            // Read from all ROM locations
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                #10;  // Wait for clock edge
                @(posedge clk);
                #1;   // Small delay for signal propagation

                // Check if ROM output matches expected pattern
                if (rom_out == (i * 17)) begin  // Expected pattern: 0x00, 0x11, 0x22...
                    $display("ROM Test %2d PASSED: Addr=%h, Data=%h", i, addr, rom_out);
                end else begin
                    $display("ROM Test %2d FAILED: Addr=%h, Expected=%h, Got=%h",
                            i, addr, (i * 17), rom_out);
                    error_count = error_count + 1;
                end
                test_count = test_count + 1;
            end
        end
    endtask

    // Task: Test synchronous RAM operations
       task test_sync_ram_operations;
        integer i;
        reg [7:0] test_data [0:15];
        begin
            $display("Testing Synchronous RAM operations...");
            
            // Initialize RAM with reset
            rst = 1;
            en = 0;
            we = 0;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            
            // Enable RAM and wait for FSM to stabilize
            en = 1;
            @(posedge clk);
            @(posedge clk);

            // Write phase
            $display("Writing test data to Sync RAM...");
            we = 1;
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                test_data[i] = $random & 8'hFF;
                data_in = test_data[i];
                @(posedge clk);
                #2;
                $display("Sync RAM Write: Addr=%h, Data=%h", addr, data_in);
                @(posedge clk); // Additional clock cycle to ensure write completes
            end

            // Switch to read mode with proper FSM state transitions
            we = 0;
            addr = 4'h0;
            repeat(4) @(posedge clk); // Multiple cycles for FSM to stabilize

            // Read phase with extra timing controls
            $display("Reading and verifying Sync RAM data...");
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                repeat(2) @(posedge clk); // Two cycles per read
                
                if (sync_ram_out == test_data[i]) begin
                    $display("Sync RAM Test %2d PASSED: Addr=%h, Data=%h", 
                            i, addr, sync_ram_out);
                end else begin
                    $display("Sync RAM Test %2d FAILED: Addr=%h, Expected=%h, Got=%h",
                            i, addr, test_data[i], sync_ram_out);
                    error_count = error_count + 1;
                end
                test_count = test_count + 1;
            end

            // Reset signals to default state
            we = 0;
            en = 0;
            addr = 4'h0;
            @(posedge clk);
        end
    endtask

    // Task: Test asynchronous RAM operations
    task test_async_ram_operations;
        integer i;
        reg [7:0] test_data [0:15];
        begin
            $display("Testing Asynchronous RAM operations...");
            en = 1;  // Enable RAM

            // Write phase: Write test pattern
            $display("Writing test data to Async RAM...");
            we = 1;  // Enable write mode
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                test_data[i] = 8'hA0 + i;  // Test pattern: A0, A1, A2...AF
                data_in = test_data[i];
                #5;  // Small delay for asynchronous operation
                $display("Async RAM Write: Addr=%h, Data=%h", addr, data_in);
            end

            // Read phase: Read back and verify
            $display("Reading and verifying Async RAM data...");
            we = 0;  // Switch to read mode
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                #5;  // Small delay for asynchronous operation

                // Verify data matches expected pattern
                if (async_ram_out == test_data[i]) begin
                    $display("Async RAM Test %2d PASSED: Addr=%h, Data=%h",
                            i, addr, async_ram_out);
                end else begin
                    $display("Async RAM Test %2d FAILED: Addr=%h, Expected=%h, Got=%h",
                            i, addr, test_data[i], async_ram_out);
                    error_count = error_count + 1;
                end
                test_count = test_count + 1;
            end
        end
    endtask

    // Task: Test asynchronous ROM operations
    task test_async_rom_operations;
        integer i;
        begin
            $display("Testing Asynchronous ROM read operations...");
            en = 1;  // Enable ROM

            // Read from all ROM locations
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                #2;  // Small delay for asynchronous operation

                // Check if ROM output matches expected pattern
                if (async_rom_out == (i * 17)) begin  // Expected pattern: 0x00, 0x11, 0x22...
                    $display("Async ROM Test %2d PASSED: Addr=%h, Data=%h", i, addr, async_rom_out);
                end else begin
                    $display("Async ROM Test %2d FAILED: Addr=%h, Expected=%h, Got=%h",
                            i, addr, (i * 17), async_rom_out);
                    error_count = error_count + 1;
                end
                test_count = test_count + 1;
            end
        end
    endtask

    // Task: Test reset functionality
    task test_reset_functionality;
        begin
            $display("Testing Reset functionality...");

            // Set up some initial conditions
            en = 1;
            we = 0;
            addr = 4'h5;

            // Apply reset
            rst = 1;
            #10;

            // Check if outputs are reset properly
            if (sync_ram_out == 8'h00) begin
                $display("Sync RAM Reset Test PASSED");
            end else begin
                $display("Sync RAM Reset Test FAILED");
                error_count = error_count + 1;
            end

            if (async_ram_out == 8'h00) begin
                $display("Async RAM Reset Test PASSED");
            end else begin
                $display("Async RAM Reset Test FAILED");
                error_count = error_count + 1;
            end

            test_count = test_count + 2;

            // Release reset
            rst = 0;
            #10;
        end
    endtask

    // Task: Test enable/disable control
    task test_enable_control;
        begin
            $display("Testing Enable/Disable control...");

            // Disable all memories
            en = 0;
            addr = 4'h3;
            #10;

            // Try to perform operations (should not work)
            we = 1;
            data_in = 8'hFF;
            #10;

            we = 0;
            #10;

            $display("Enable control test completed");
            test_count = test_count + 1;

            // Re-enable for any subsequent tests
            en = 1;
        end
    endtask

    // Task: Display final test results
    task display_test_results;
        begin
            $display("\n====================================================");
            $display("VERIFICATION RESULTS SUMMARY");
            $display("====================================================");
            $display("Total Tests Run: %d", test_count);
            $display("Tests Failed: %d", error_count);
            $display("Tests Passed: %d", test_count - error_count);

            if (error_count == 0) begin
                $display("STATUS: ALL TESTS PASSED! ");
            end else begin
                $display("STATUS: %d TESTS FAILED! ", error_count);
            end
            $display("====================================================");
        end
    endtask

endmodule

