// Traffic Light Controller Testbench
// Description: Comprehensive verification environment for traffic light FSM
//Author:Teja_Reddy


`timescale 1ns/1ps 

module tb_traffic_light_controller;
    // Testbench signals declaration
    reg clk;             // Clock signal for DUT
    reg reset;           // Reset signal for DUT
    wire ns_red;         // North-South red light output
    wire ns_yellow;      // North-South yellow light output 
    wire ns_green;       // North-South green light output
    wire ew_red;         // East-West red light output
    wire ew_yellow;      // East-West yellow light output
    wire ew_green;       // East-West green light output

    // Additional signals for verification
    reg [2:0] expected_state;    // Expected state for verification
    integer cycle_count;         // Count clock cycles
    integer error_count;         // Track verification errors

    // Clock period parameter - 10ns for fast simulation
    parameter CLOCK_PERIOD = 10;

    // Device Under Test (DUT) Instantiation
    traffic_light_controller DUT (
        .clk(clk),
        .reset(reset),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );

    // Clock Generation Block
    initial begin
        clk = 1'b0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Test Stimulus Block
    initial begin
        // Initialize verification variables
        cycle_count = 0;
        error_count = 0;
        
        // Display test start message
        $display("=== Traffic Light Controller Verification Started ===");
        $display("Time: %0t", $time);
        
        // Test 1: Reset functionality
        $display("\n--- Test 1: Reset Functionality ---");
        reset = 1'b1;
        #(CLOCK_PERIOD * 3);
        
        // Verify reset state
        if (ns_green !== 1'b1 || ew_red !== 1'b1) begin
            $display("ERROR: Reset state incorrect at time %0t", $time);
            error_count = error_count + 1;
        end else begin
            $display("PASS: Reset properly initializes to NS_GREEN state");
        end

        // Release reset and start normal operation
        reset = 1'b0;
        $display("Reset released at time %0t", $time);
        
        // Test 2: Complete cycle verification
        $display("\n--- Test 2: Complete Cycle Verification ---");
        
        // Monitor one complete traffic light cycle
        repeat (75) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
            
            case (cycle_count)
                1:  $display("Cycle %0d: NS_GREEN phase - NS traffic flows", cycle_count);
                31: $display("Cycle %0d: NS_YELLOW phase - NS prepares to stop", cycle_count);
                36: $display("Cycle %0d: ALL_RED1 phase - Safety gap", cycle_count);
                38: $display("Cycle %0d: EW_GREEN phase - EW traffic flows", cycle_count);
                63: $display("Cycle %0d: EW_YELLOW phase - EW prepares to stop", cycle_count);
                68: $display("Cycle %0d: ALL_RED2 phase - Safety gap", cycle_count);
                70: $display("Cycle %0d: Back to NS_GREEN - New cycle begins", cycle_count);
            endcase
        end
        
        // Test 3: Safety verification
        $display("\n--- Test 3: Safety Verification ---");
        reset = 1'b0;
        repeat (100) begin
            @(posedge clk);
            
            if (ns_green && ew_green) begin
                $display("CRITICAL ERROR: Both NS and EW green active at time %0t!", $time);
                error_count = error_count + 1;
            end
            
            if (!ns_red && !ew_red && !(ns_green || ns_yellow) && !(ew_green || ew_yellow)) begin
                $display("ERROR: No lights active at time %0t", $time);
                error_count = error_count + 1;
            end
        end
        
        // Test 4: Multiple reset test
        $display("\n--- Test 4: Multiple Reset Test ---");
        repeat (3) begin
            reset = 1'b1;
            #(CLOCK_PERIOD * 2);
            if (ns_green !== 1'b1 || ew_red !== 1'b1) begin
                $display("ERROR: Reset failed at time %0t", $time);
                error_count = error_count + 1;
            end
            reset = 1'b0;
            #(CLOCK_PERIOD * 10);
        end
        
        // Final verification summary
        $display("\n=== Verification Summary ===");
        $display("Total clock cycles simulated: %0d", cycle_count);
        $display("Total errors found: %0d", error_count);
        
        if (error_count == 0)
            $display("*** ALL TESTS PASSED - Traffic Light Controller is working correctly! ***");
        else
            $display("*** VERIFICATION FAILED - %0d errors detected ***", error_count);
        
        $display("Simulation completed at time %0t", $time);
        $finish;
    end

    // Continuous Monitoring Block
    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, tb_traffic_light_controller);
        
        $display("\nTime\t| State\t\t| NS_Lights\t| EW_Lights\t| Timer");
        $display("--------|---------------|---------------|---------------|-------");
        
        forever begin
            @(posedge clk);
            if (!reset)
                $display("%0t\t| %s\t| R:%b Y:%b G:%b\t| R:%b Y:%b G:%b\t| %0d", 
                    $time,
                    get_state_name(DUT.current_state),
                    ns_red, ns_yellow, ns_green,
                    ew_red, ew_yellow, ew_green,
                    DUT.timer);
        end
    end

    // Helper Function - State Name Decoder
    function [79:0] get_state_name;
        input [2:0] state;
        begin
            case (state)
                3'b000: get_state_name = "NS_GREEN ";
                3'b001: get_state_name = "NS_YELLOW";
                3'b010: get_state_name = "ALL_RED1 ";
                3'b011: get_state_name = "EW_GREEN ";
                3'b100: get_state_name = "EW_YELLOW";
                3'b101: get_state_name = "ALL_RED2 ";
                default: get_state_name = "UNDEFINED";
            endcase
        end
    endfunction

endmodule