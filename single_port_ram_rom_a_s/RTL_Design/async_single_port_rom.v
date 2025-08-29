// -----------------------------------------------------------------------------
// Asynchronous Single-Port ROM (Read-Only Memory)
// Features:
//   - 16 x 8-bit ROM (4-bit address, 8-bit data)
//   - Asynchronous read (data available immediately after address/en change)
//   - Enable control for output
//   - Preloaded with a simple data pattern
//   - Author: Teja Reddy
// -----------------------------------------------------------------------------
module async_single_port_rom(
    input  wire       en,        // ROM enable (1=active, 0=inactive)
    input  wire [3:0] addr,      // 4-bit address input (0-15)
    output reg  [7:0] data_out   // 8-bit data output
);

    // -------------------------------------------------------------------------
    // ROM Memory Declaration and Initialization
    // -------------------------------------------------------------------------
    reg [7:0] rom_memory [0:15]; // 16 locations, 8 bits each

    initial begin
        // Preload ROM with a simple pattern (can be customized)
        rom_memory[0]  = 8'h00; // Address 0: 0x00
        rom_memory[1]  = 8'h11; // Address 1: 0x11
        rom_memory[2]  = 8'h22; // Address 2: 0x22
        rom_memory[3]  = 8'h33; // Address 3: 0x33
        rom_memory[4]  = 8'h44; // Address 4: 0x44
        rom_memory[5]  = 8'h55; // Address 5: 0x55
        rom_memory[6]  = 8'h66; // Address 6: 0x66
        rom_memory[7]  = 8'h77; // Address 7: 0x77
        rom_memory[8]  = 8'h88; // Address 8: 0x88
        rom_memory[9]  = 8'h99; // Address 9: 0x99
        rom_memory[10] = 8'hAA; // Address 10: 0xAA
        rom_memory[11] = 8'hBB; // Address 11: 0xBB
        rom_memory[12] = 8'hCC; // Address 12: 0xCC
        rom_memory[13] = 8'hDD; // Address 13: 0xDD
        rom_memory[14] = 8'hEE; // Address 14: 0xEE
        rom_memory[15] = 8'hFF; // Address 15: 0xFF
        data_out = 8'h00;       // Initialize output to 0
    end

    // -------------------------------------------------------------------------
    // Asynchronous ROM Read Operation
    // Output updates immediately when 'en' or 'addr' changes
    // -------------------------------------------------------------------------
    always @(*) begin
        if (en) begin
            // When enabled, output the data at the given address
            data_out = rom_memory[addr];
            // Uncomment for simulation debug:
            // $display("ASYNC ROM READ: Addr=%h Data=%h", addr, rom_memory[addr]);
        end else begin
            // When not enabled, output is set to 0 (can also hold previous value if preferred)
            data_out = 8'h00;
        end
    end

endmodule