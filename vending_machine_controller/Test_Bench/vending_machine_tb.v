//testbench for vending machine design
//Author:Teja_Reddy
module vending_machine_tb;
reg clk;
reg reset;
reg coin5,coin10,coin25;
reg select;
wire dispense;
wire[4:0]change;

//dut instantiation
vending_machine dut(
.clk(clk),
.reset(reset),
.coin5(coin5),
.coin10(coin10),
.coin25(coin25),
.select(select),
.dispense(dispense),
.change(change));

//clock generation
initial begin
clk=0;
forever #10 clk=~clk;
end

//stimulus generation
initial  begin
$display("========vending machine testbench started=====");
$monitor("Time=%0t | reset=%b|coins(5,10,25)=(%b%b%b)| Select=%b | State=%b | Dispense=%b | Change=%d",
$time, reset, coin5, coin10, coin25, select, dut.current_state, dispense, change);
// Initialize all inputs to known state
reset = 1; coin5 = 0; coin10 = 0; coin25 = 0; select = 0;
     // Test Case 1: System Reset and Initialization 
        $display("\n--- Test Case 1: Reset Functionality ---"); 
        #20;                          // Wait for 2 clock cycles 
        reset = 0;                    // Release reset 
        #20;                          // Wait to observe idle state 
         
        // Test Case 2: Exact Payment with Single Coin (25 units) 
        $display("\n--- Test Case 2: Exact Payment (25 units) ---"); 
        coin25 = 1;                   // Insert 25-unit coin 
        #20;                          // Wait for state transition 
        coin25 = 0;                   // Release coin signal 
        #20;                          // Observe dispense and return to idle 
         
        // Test Case 3: Multiple Small Coins to Exact Payment 
        $display("\n--- Test Case 3: Multiple Coins - Exact Payment ---"); 
        coin5 = 1;                    // Insert first 5-unit coin 
        #20; 
        coin5 = 0; 
        #20; 
        coin10 = 1;                   // Insert 10-unit coin (total = 15) 
        #20; 
        coin10 = 0;  
        #20; 
        coin10 = 1;                   // Insert another 10-unit coin (total = 25) 
        #20; 
        coin10 = 0; 
        #20;                          // Should automatically dispense (exact payment) 
        // Test Case 4: Overpayment and Change Calculation   
        $display("\n--- Test Case 4: Overpayment Scenario ---"); 
        coin10 = 1;                   // Insert 10-unit coin 
        #20; 
        coin10 = 0; 
        #20; 
        coin25 = 1;                   // Insert 25-unit coin (total = 35, overpayment) 
        #20; 
        coin25 = 0; 
        #20;                          // Should dispense and give 10 units change 
         
        // Test Case 5: Insufficient Funds with Selection Attempt 
        $display("\n--- Test Case 5: Insufficient Funds Test ---"); 
        coin5 = 1;                    // Insert 5-unit coin (insufficient) 
        #20; 
 
 
        coin5 = 0; 
        #20; 
        select = 1;                   // Try to select product 
        #20; 
        select = 0;                   // Should not dispense (insufficient funds) 
        #20; 
         
        // Add more coins to complete transaction 
        coin25 = 1;                   // Add 25-unit coin (total = 30, overpayment) 
        #20; 
        coin25 = 0; 
        #20;                          // Should dispense and give 5 units change 
         
        // Test Case 6: Manual Selection with Sufficient Funds 
        $display("\n--- Test Case 6: Manual Selection Test ---"); 
        coin10 = 1;                   // Insert 10-unit coin 
        #20; 
        coin10 = 0; 
        #20; 
        coin10 = 1;                   // Insert another 10-unit coin (total = 20) 
        #20;  
        coin10 = 0; 
        #20; 
        coin5 = 1;                    // Insert 5-unit coin (total = 25, exact) 
        #20; 
        coin5 = 0; 
        #20; 
        select = 1;                   // Manual selection 
        #20; 
        select = 0; 
        #20;                          // Should dispense with no change 
         
        // Test Case 7: Reset During Transaction 
        $display("\n--- Test Case 7: Reset During Transaction ---"); 
        coin10 = 1;                   // Start inserting coins 
        #20; 
        coin10 = 0; 
        #20; 
        coin5 = 1;                    // Insert more coins 
        #20; 
        coin5 = 0; 
        #20; 
        reset = 1;                    // Reset during transaction 
        #20; 
        reset = 0;                    // Should return to idle, losing accumulated coins 
        #20; 
        // Test Case 8: Rapid Sequential Coins 
        $display("\n--- Test Case 8: Sequential Coin Insertion ---"); 
        coin5 = 1;                    // Quick sequence of coins 
        #20; 
 
 
        coin5 = 0; 
        coin5 = 1; 
        #20; 
        coin5 = 0; 
        coin5 = 1;   
        #20; 
        coin5 = 0; 
        coin5 = 1; 
        #20; 
        coin5 = 0; 
        coin5 = 1;                    // Total should be 25 (exact payment) 
        #20; 
        coin5 = 0; 
        #20; 
        // End simulation 
        $display("\n=== All Test Cases Completed ==="); 
        #50;                          // Wait before ending simulation 
        $finish;                      // End simulation 
    end 
    // Additional monitoring for debugging 
    initial begin 
        // Create waveform dump file for visualization 
        $dumpfile("vending_machine.vcd"); 
        $dumpvars(0, vending_machine_tb); 
         
        // Monitor internal state changes 
        $monitor("Time=%0t | Internal: total_amount=%d | current_state=%b | next_state=%b",  
                 $time, dut.total_amount, dut.current_state, dut.next_state); 
    end 
     
    // Automatic timeout to prevent infinite simulation 
    initial begin 
        #2000;                        // Maximum simulation time 
        $display("Simulation timeout reached"); 
        $finish; 
    end 
endmodule 
