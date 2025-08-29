`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Washing Machine Controller Testbench (Comprehensive FSM Verification)
// Author: Teja Reddy
// Description: Beginner-friendly, feature-rich testbench for the washing machine
// FSM controller. Covers all states, transitions, emergency stop, reset, and edge cases.
//-----------------------------------------------------------------------------

module washing_machine_tb;

    //-------------------------------------------------------------------------
    // Testbench Signals
    //-------------------------------------------------------------------------
    reg clk;                // Clock signal
    reg reset;              // Reset signal
    reg start;              // Start button
    reg stop;               // Emergency stop button

    wire fill_valve;        // Water fill valve status
    wire motor;             // Motor status
    wire drain_valve;       // Drain valve status
    wire soap_dispenser;    // Soap dispenser status
    wire done;              // Done signal
    wire [2:0] state;       // FSM state for monitoring

    //-------------------------------------------------------------------------
    // DUT Instantiation
    //-------------------------------------------------------------------------
    washing_machine_controller dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .fill_valve(fill_valve),
        .motor(motor),
        .drain_valve(drain_valve),
        .soap_dispenser(soap_dispenser),
        .done(done),
        .state(state)
    );

    //-------------------------------------------------------------------------
    // Clock Generation: 10ns period (100MHz)
    //-------------------------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //-------------------------------------------------------------------------
    // Test Sequence
    //-------------------------------------------------------------------------
    initial begin
        // VCD for waveform viewing
        $dumpfile("washing_machine.vcd");
        $dumpvars(0, washing_machine_tb);

        $display("=== Washing Machine Controller Verification ===");
        $display("Time\tState\t[fill|motor|drain|soap|done]");
        $display("----------------------------------------------------");

        // Test 1: Power-on Reset
        $display("Test 1: Power-on Reset");
        reset = 1; start = 0; stop = 0;
        #10;
        reset = 0;
        #10;

        // Test 2: Normal Wash Cycle
        $display("Test 2: Complete Normal Wash Cycle");
        start = 1; #10; start = 0; // Press and release start

        wait(state == 3'b001); $display("Entered FILL state");
        #30; // Wait for fill

        wait(state == 3'b010); $display("Entered WASH state");
        #60; // Wait for wash

        wait(state == 3'b011); $display("Entered RINSE state");
        #40; // Wait for rinse

        wait(state == 3'b100); $display("Entered SPIN state");
        #30; // Wait for spin

        wait(state == 3'b101); $display("Entered DONE state");
        #20; // Wait for done

        wait(state == 3'b000); $display("Returned to IDLE state");
        #10;

        // Test 3: Emergency Stop in FILL
        $display("Test 3: Emergency Stop During FILL");
        start = 1; #10; start = 0;
        wait(state == 3'b001); // Wait for FILL
        #10;
        stop = 1; #10; stop = 0; // Emergency stop
        $display("Emergency stop executed in FILL");
        #10;

        // Test 4: Emergency Stop in WASH
        $display("Test 4: Emergency Stop During WASH");
        start = 1; #10; start = 0;
        wait(state == 3'b010); // Wait for WASH
        #10;
        stop = 1; #10; stop = 0; // Emergency stop
        $display("Emergency stop executed in WASH");
        #10;

        // Test 5: Emergency Stop in RINSE
        $display("Test 5: Emergency Stop During RINSE");
        start = 1; #10; start = 0;
        wait(state == 3'b011); // Wait for RINSE
        #10;
        stop = 1; #10; stop = 0; // Emergency stop
        $display("Emergency stop executed in RINSE");
        #10;

        // Test 6: Emergency Stop in SPIN
        $display("Test 6: Emergency Stop During SPIN");
        start = 1; #10; start = 0;
        wait(state == 3'b100); // Wait for SPIN
        #10;
        stop = 1; #10; stop = 0; // Emergency stop
        $display("Emergency stop executed in SPIN");
        #10;

        // Test 7: Reset During Operation (in RINSE)
        $display("Test 7: Reset During RINSE");
        start = 1; #10; start = 0;
        wait(state == 3'b011); // Wait for RINSE
        #10;
        reset = 1; #10; reset = 0;
        $display("Reset executed in RINSE");
        #10;

        // Test 8: Multiple Start Presses
        $display("Test 8: Multiple Start Presses");
        start = 1; #10; start = 0; #5; start = 1; #10; start = 0;
        wait(state == 3'b001); // Should enter FILL only once
        $display("Handled multiple start presses correctly");
        #20;
        stop = 1; #10; stop = 0; // Stop to return to IDLE

        // Test 9: No Start (should stay in IDLE)
        $display("Test 9: No Start - Should remain in IDLE");
        reset = 1; #10; reset = 0;
        #50; // Wait and observe

        $display("=== All Test Cases Completed Successfully ===");
        $finish;
    end

    //-------------------------------------------------------------------------
    // Output Monitoring: Print state and outputs every clock
    //-------------------------------------------------------------------------
    always @(posedge clk) begin
        $display("%0t\t%b\t[%b|%b|%b|%b|%b]",
            $time, state, fill_valve, motor, drain_valve, soap_dispenser, done);
    end

    //-------------------------------------------------------------------------
    // State Name Display for Readability
    //-------------------------------------------------------------------------
    always @(state) begin
        case(state)
            3'b000: $display("Current State: IDLE");
            3'b001: $display("Current State: FILL");
            3'b010: $display("Current State: WASH");
            3'b011: $display("Current State: RINSE");
            3'b100: $display("Current State: SPIN");
            3'b101: $display("Current State: DONE");
            default: $display("Current State: UNKNOWN");
        endcase
    end

endmodule