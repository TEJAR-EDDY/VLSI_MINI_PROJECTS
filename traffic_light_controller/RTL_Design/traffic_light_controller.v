// Traffic Light Controller - VLSI Mini Project
// Description: 4-way intersection traffic light controller using Moore FSM
//Author:Teja_Reddy
 

module traffic_light_controller(
    input wire clk,      // System clock (1Hz for real-time simulation)
    input wire reset,    // Active high reset signal
    output reg ns_red,   // North-South Red light
    output reg ns_yellow,// North-South Yellow light 
    output reg ns_green, // North-South Green light
    output reg ew_red,   // East-West Red light
    output reg ew_yellow,// East-West Yellow light
    output reg ew_green  // East-West Green light
);

// State parameter declarations - using binary encoding for simplicity
parameter NS_GREEN   = 3'b000; // North-South green, East-West red
parameter NS_YELLOW  = 3'b001; // North-South yellow, East-West red 
parameter ALL_RED1   = 3'b010; // All red (safety gap 1)
parameter EW_GREEN   = 3'b011; // East-West green, North-South red
parameter EW_YELLOW  = 3'b100; // East-West yellow, North-South red
parameter ALL_RED2   = 3'b101; // All red (safety gap 2)

// Timing parameters - easily configurable for different scenarios
parameter NS_GREEN_TIME  = 6'd30; // 30 seconds North-South green
parameter NS_YELLOW_TIME = 6'd5;  // 5 seconds North-South yellow
parameter ALL_RED1_TIME  = 6'd2;  // 2 seconds safety gap
parameter EW_GREEN_TIME  = 6'd25; // 25 seconds East-West green 
parameter EW_YELLOW_TIME = 6'd5;  // 5 seconds East-West yellow
parameter ALL_RED2_TIME  = 6'd2;  // 2 seconds safety gap

// Internal signal declarations
reg [2:0] current_state; // Current FSM state (3-bit)
reg [2:0] next_state;    // Next FSM state (3-bit)
reg [5:0] timer;         // Timer counter (6-bit for up to 63 counts)

// Sequential Logic Block - State Register and Timer
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset condition - initialize to North-South green state
        current_state <= NS_GREEN;
        timer <= 6'd0;
    end
    else begin
        // Normal operation - update state and increment timer
        current_state <= next_state;
        
        // Timer logic: increment if staying in same state, reset if changing state
        if (current_state == next_state)
            timer <= timer + 1'b1;
        else
            timer <= 6'd0;
    end
end

// Combinational Logic Block - Next State Logic
always @(*) begin
    // Default assignment to avoid latches
    next_state = current_state;
    
    case (current_state)
        NS_GREEN: begin
            if (timer >= NS_GREEN_TIME - 1)
                next_state = NS_YELLOW;
            else
                next_state = NS_GREEN;
        end
        
        NS_YELLOW: begin
            if (timer >= NS_YELLOW_TIME - 1)
                next_state = ALL_RED1;
            else
                next_state = NS_YELLOW;
        end
        
        ALL_RED1: begin
            if (timer >= ALL_RED1_TIME - 1)
                next_state = EW_GREEN;
            else
                next_state = ALL_RED1;
        end
        
        EW_GREEN: begin
            if (timer >= EW_GREEN_TIME - 1)
                next_state = EW_YELLOW;
            else
                next_state = EW_GREEN;
        end
        
        EW_YELLOW: begin
            if (timer >= EW_YELLOW_TIME - 1)
                next_state = ALL_RED2;
            else
                next_state = EW_YELLOW;
        end
        
        ALL_RED2: begin
            if (timer >= ALL_RED2_TIME - 1)
                next_state = NS_GREEN;
            else
                next_state = ALL_RED2;
        end
        
        default: begin
            next_state = NS_GREEN;
        end
    endcase
end

// Output Logic Block - Moore FSM Output Assignment
always @(*) begin
    // Default all lights to OFF to avoid undefined states
    ns_red = 1'b0;
    ns_yellow = 1'b0;
    ns_green = 1'b0;
    ew_red = 1'b0;
    ew_yellow = 1'b0;
    ew_green = 1'b0;
    
    case (current_state)
        NS_GREEN: begin
            ns_green = 1'b1;  // North-South green ON
            ew_red = 1'b1;    // East-West red ON
        end
        
        NS_YELLOW: begin
            ns_yellow = 1'b1; // North-South yellow ON
            ew_red = 1'b1;    // East-West red remains ON
        end
        
        ALL_RED1: begin
            ns_red = 1'b1;    // North-South red ON
            ew_red = 1'b1;    // East-West red ON
        end
        
        EW_GREEN: begin
            ns_red = 1'b1;    // North-South red ON
            ew_green = 1'b1;  // East-West green ON
        end
        
        EW_YELLOW: begin
            ns_red = 1'b1;    // North-South red remains ON
            ew_yellow = 1'b1; // East-West yellow ON
        end
        
        ALL_RED2: begin
            ns_red = 1'b1;    // North-South red ON
            ew_red = 1'b1;    // East-West red ON
        end
        
        default: begin
            ns_red = 1'b1;    // Error condition - all red
            ew_red = 1'b1;
        end
    endcase
end

endmodule