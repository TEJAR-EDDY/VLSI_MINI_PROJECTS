// ==========================================================================
// Asynchronous Dual-Port RAM (behavioral, for simulation/learning)
// - Fully async read/write (no clk)
// - Port-A priority if both write same address
// - HI_Z_OUTPUT=1 → drive 'bz when read_en=0; else hold last value
// - conflict_flag is sticky (stays 1 until reset) so TB can sample it later
// - Reset clears memory to RESET_VALUE
//	- Author: Teja Reddy
// ==========================================================================
module async_dual_port_ram #(
    parameter DATA_WIDTH      = 8,
    parameter ADDR_WIDTH      = 4,
    parameter MEM_DEPTH       = (1 << ADDR_WIDTH),
    parameter INIT_PATTERN    = 8'hAA,
    parameter RESET_VALUE     = 8'h00,
    parameter HI_Z_OUTPUT     = 1,
    parameter PORT_A_PRIORITY = 1
)(
    input  wire                     reset,

    // Port A
    input  wire [ADDR_WIDTH-1:0]    addr_a,
    input  wire [DATA_WIDTH-1:0]    data_in_a,
    output reg  [DATA_WIDTH-1:0]    data_out_a,
    input  wire                     write_en_a,
    input  wire                     read_en_a,

    // Port B
    input  wire [ADDR_WIDTH-1:0]    addr_b,
    input  wire [DATA_WIDTH-1:0]    data_in_b,
    output reg  [DATA_WIDTH-1:0]    data_out_b,
    input  wire                     write_en_b,
    input  wire                     read_en_b,

    output reg                      conflict_flag
);
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    integer i;

    // Power-up init
    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) mem[i] = INIT_PATTERN;
        data_out_a   = {DATA_WIDTH{1'b0}};
        data_out_b   = {DATA_WIDTH{1'b0}};
        conflict_flag= 1'b0;
    end

    // Async reset: clear memory & flags
    always @(posedge reset) begin
        if (reset) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) mem[i] = RESET_VALUE;
            data_out_a    = {DATA_WIDTH{1'b0}};
            data_out_b    = {DATA_WIDTH{1'b0}};
            conflict_flag = 1'b0;
        end
    end

    // Async writes + sticky conflict flag
    always @(*) begin
        if (!reset) begin
            // Default: keep previous conflict_flag (sticky)
            // conflict_flag = conflict_flag; // implied

            if (write_en_a && write_en_b && (addr_a == addr_b)) begin
                conflict_flag = 1'b1;
                if (PORT_A_PRIORITY)
                    mem[addr_a] = data_in_a;  // A wins
                else
                    mem[addr_b] = data_in_b;  // B wins
            end else begin
                if (write_en_a) mem[addr_a] = data_in_a;
                if (write_en_b) mem[addr_b] = data_in_b;
            end
        end
    end

    // Async reads
    always @(*) begin
        if (reset) begin
            data_out_a = {DATA_WIDTH{1'b0}};
        end else if (read_en_a) begin
            data_out_a = mem[addr_a];
        end else if (HI_Z_OUTPUT) begin
            data_out_a = {DATA_WIDTH{1'bz}};
        end
        // else: hold last value (no assignment)
    end

    always @(*) begin
        if (reset) begin
            data_out_b = {DATA_WIDTH{1'b0}};
        end else if (read_en_b) begin
            data_out_b = mem[addr_b];
        end else if (HI_Z_OUTPUT) begin
            data_out_b = {DATA_WIDTH{1'bz}};
        end
        // else: hold last value (no assignment)
    end

    // Simulation-only warnings
    // synthesis translate_off
    always @(*) begin
        if (!reset && write_en_a && write_en_b && (addr_a == addr_b)) begin
            $display("Warning: Write conflict detected at time %0t", $time);
            $display("Address: %0h, Port A Data: %0h, Port B Data: %0h",
                     addr_a, data_in_a, data_in_b);
        end
    end
    // synthesis translate_on
endmodule
