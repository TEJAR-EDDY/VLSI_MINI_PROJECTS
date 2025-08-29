// -----------------------------------------------------------------------------
// Synchronous Single-Port RAM with FSM Control
// Features:
//   - 16 x 8-bit memory (4-bit address, 8-bit data)
//   - Synchronous read/write with FSM for safe operation
//   - Resettable, with memory and output initialization
//   - Author: Teja Reddy
// -----------------------------------------------------------------------------
module sync_single_port_ram(
    input  wire        clk,      // System clock (positive edge triggered)
    input  wire        rst,      // Active-high synchronous reset
    input  wire        en,       // Memory enable (1=active, 0=inactive)
    input  wire        we,       // Write enable (1=write, 0=read)
    input  wire [3:0]  addr,     // 4-bit address (0-15)
    input  wire [7:0]  data_in,  // 8-bit data input (for write)
    output reg  [7:0]  data_out  // 8-bit data output (for read)
);

    // -------------------------------------------------------------------------
    // Memory Declaration: 16 locations, each 8 bits wide
    // -------------------------------------------------------------------------
    reg [7:0] memory [0:15];

    // -------------------------------------------------------------------------
    // FSM State Definitions (for readability)
    // -------------------------------------------------------------------------
    localparam IDLE   = 2'b00; // Waiting for enable
    localparam ACTIVE = 2'b01; // Enabled, waiting for operation
    localparam WRITE  = 2'b10; // Write operation
    localparam READ   = 2'b11; // Read operation

    reg [1:0] current_state, next_state; // FSM state registers

    // -------------------------------------------------------------------------
    // Memory and State Initialization (runs once at simulation start)
    // -------------------------------------------------------------------------
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            memory[i] = 8'h00;      // Clear all memory
        data_out = 8'h00;           // Clear output
        current_state = IDLE;       // Start in IDLE
    end

    // -------------------------------------------------------------------------
    // FSM State Register Update (Sequential Logic)
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst)
            current_state <= IDLE;      // Reset to IDLE
        else
            current_state <= next_state;// Move to next state
    end

    // -------------------------------------------------------------------------
    // FSM Next State Logic (Combinational Logic)
    // -------------------------------------------------------------------------
    always @(*) begin
        case (current_state)
            IDLE:    next_state = en ? ACTIVE : IDLE; // Wait for enable
            ACTIVE:  next_state = !en ? IDLE : (we ? WRITE : READ); // Decide op
            WRITE:   next_state = !en ? IDLE : ACTIVE; // After write, go ACTIVE
            READ:    next_state = !en ? IDLE : ACTIVE; // After read, go ACTIVE
            default: next_state = IDLE;
        endcase
    end

    // -------------------------------------------------------------------------
    // Memory Operation Logic (Sequential Logic)
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'h00; // Reset output
        end else begin
            case (current_state)
                WRITE: begin
                    if (en && we) begin
                        memory[addr] <= data_in; // Write data
                        // $display("WRITE: Addr=%h Data=%h", addr, data_in);
                    end
                end
                READ: begin
                    if (en && !we) begin
                        data_out <= memory[addr]; // Read data
                        // $display("READ: Addr=%h Data=%h", addr, memory[addr]);
                    end
                end
                default: ; // No operation in IDLE/ACTIVE
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Optional: Synchronous Memory Clear on Reset (uncomment if needed)
    // -------------------------------------------------------------------------
    /*
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1)
                memory[i] <= 8'h00;
        end
    end
    */

endmodule