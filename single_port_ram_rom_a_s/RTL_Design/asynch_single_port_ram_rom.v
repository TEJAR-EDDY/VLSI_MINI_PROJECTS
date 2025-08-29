// -----------------------------------------------------------------------------
// Asynchronous Single-Port RAM (16 x 8-bit)
// Features:
//   - 16 memory locations, each 8 bits wide (4-bit address)
//   - Asynchronous read and write (no clock required)
//   - Resettable output and memory initialization
//   - Author: Teja Reddy
// -----------------------------------------------------------------------------
module async_single_port_ram(
    input  wire       rst,      // Active-high reset
    input  wire       en,       // Memory enable (1=active, 0=inactive)
    input  wire       we,       // Write enable (1=write, 0=read)
    input  wire [3:0] addr,     // 4-bit address input (0-15)
    input  wire [7:0] data_in,  // 8-bit data input (for write)
    output reg  [7:0] data_out  // 8-bit data output (for read)
);

    // -------------------------------------------------------------------------
    // Memory Array Declaration: 16 locations, each 8 bits wide
    // -------------------------------------------------------------------------
    reg [7:0] memory [0:15];

    // -------------------------------------------------------------------------
    // Memory Initialization (runs once at simulation start)
    // -------------------------------------------------------------------------
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            memory[i] = 8'h00; // Clear all memory locations
        data_out = 8'h00;      // Clear output
    end

    // -------------------------------------------------------------------------
    // Asynchronous Memory Operation
    // Responds immediately to input changes (no clock)
    // -------------------------------------------------------------------------
    always @(*) begin
        if (rst) begin
            // Reset: clear output (memory remains unchanged)
            data_out = 8'h00;
        end else if (en) begin
            if (we) begin
                // Write operation: store data at address
                memory[addr] = data_in;
                // Uncomment for simulation debug:
                // $display("ASYNC WRITE: Addr=%h Data=%h", addr, data_in);
                data_out = data_in; // Optional: show written data on output
            end else begin
                // Read operation: output data from memory
                data_out = memory[addr];
                // Uncomment for simulation debug:
                // $display("ASYNC READ: Addr=%h Data=%h", addr, memory[addr]);
            end
        end else begin
            // Memory disabled: hold previous output
            // No action needed, data_out keeps its value
        end
    end

endmodule