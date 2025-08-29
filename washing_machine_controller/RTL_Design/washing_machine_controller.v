`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Washing Machine Controller (FSM-based)
// Author: Teja Reddy
// Description: Beginner-friendly, feature-rich FSM controller for an automatic
// washing machine. Includes emergency stop, cycle monitoring, and clear comments.
//-----------------------------------------------------------------------------

module washing_machine_controller (
    input  wire       clk,            // System clock
    input  wire       reset,          // Active high reset
    input  wire       start,          // Start button
    input  wire       stop,           // Emergency stop button

    output reg        fill_valve,     // Controls water fill valve
    output reg        motor,          // Controls drum motor (wash/spin)
    output reg        drain_valve,    // Controls drain valve
    output reg        soap_dispenser, // Controls soap dispenser
    output reg        done,           // Indicates wash cycle complete
    output reg [2:0]  state           // Current state (for monitoring/debug)
);

    //-------------------------------------------------------------------------
    // State Definitions (using localparam for readability)
    //-------------------------------------------------------------------------
    localparam IDLE   = 3'b000; // Waiting for start
    localparam FILL   = 3'b001; // Filling water & dispensing soap
    localparam WASH   = 3'b010; // Washing (agitation)
    localparam RINSE  = 3'b011; // Rinsing with clean water
    localparam SPIN   = 3'b100; // Spinning & draining
    localparam DONE   = 3'b101; // Cycle complete

    //-------------------------------------------------------------------------
    // Internal Registers
    //-------------------------------------------------------------------------
    reg [2:0] current_state, next_state; // FSM state registers
    reg [3:0] timer;                     // Timer for state durations

    //-------------------------------------------------------------------------
    // Sequential Logic: State and Timer Update
    //-------------------------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE; // Go to idle on reset
            timer         <= 4'd0; // Reset timer
        end else begin
            current_state <= next_state; // Move to next state
            // Timer increments only if staying in the same active state
            if (current_state == next_state && current_state != IDLE && current_state != DONE)
                timer <= timer + 1;
            else
                timer <= 4'd0; // Reset timer on state change or in IDLE/DONE
        end
    end

    //-------------------------------------------------------------------------
    // Combinational Logic: Next State Logic (FSM transitions)
    //-------------------------------------------------------------------------
    always @(*) begin
        next_state = current_state; // Default: stay in current state
        case (current_state)
            IDLE:   if (start && !stop) next_state = FILL;
            FILL:   if (stop) next_state = IDLE;
                    else if (timer >= 4'd2) next_state = WASH; // 2 cycles for fill
            WASH:   if (stop) next_state = IDLE;
                    else if (timer >= 4'd5) next_state = RINSE; // 5 cycles for wash
            RINSE:  if (stop) next_state = IDLE;
                    else if (timer >= 4'd3) next_state = SPIN; // 3 cycles for rinse
            SPIN:   if (stop) next_state = IDLE;
                    else if (timer >= 4'd2) next_state = DONE; // 2 cycles for spin
            DONE:   next_state = IDLE; // Auto-return to idle after done
            default:next_state = IDLE; // Safety fallback
        endcase
    end

    //-------------------------------------------------------------------------
    // Output Logic: Moore FSM (outputs depend only on state)
    //-------------------------------------------------------------------------
    always @(*) begin
        // Default all outputs to 0 (inactive)
        fill_valve     = 1'b0;
        motor          = 1'b0;
        drain_valve    = 1'b0;
        soap_dispenser = 1'b0;
        done           = 1'b0;
        state          = current_state; // For monitoring/debug

        case (current_state)
            IDLE: begin
                // All outputs off, waiting for start
            end
            FILL: begin
                fill_valve     = 1'b1; // Open water valve
                soap_dispenser = 1'b1; // Dispense soap
            end
            WASH: begin
                motor = 1'b1; // Agitate drum
            end
            RINSE: begin
                fill_valve = 1'b1; // Add clean water
                motor      = 1'b1; // Agitate drum
            end
            SPIN: begin
                motor       = 1'b1; // Spin drum
                drain_valve = 1'b1; // Drain water
            end
            DONE: begin
                done = 1'b1; // Signal completion
            end
            default: begin
                // All outputs off for safety
            end
        endcase
    end

    //-------------------------------------------------------------------------
    // Feature Highlights 
    // - Emergency stop: At any time, pressing 'stop' returns to IDLE.
    // - Each state has a fixed duration (timer-based).
    // - All outputs are safely reset in IDLE and on reset.
    // - 'done' output signals when the cycle is finished.
    // - 'state' output helps with simulation and debugging.
    //-------------------------------------------------------------------------

endmodule