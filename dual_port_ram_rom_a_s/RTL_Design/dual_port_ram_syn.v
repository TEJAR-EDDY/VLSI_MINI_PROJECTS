// ==========================================================================
// Synchronous Dual-Port RAM (Verilog-2001, beginner-friendly)
// - Two fully independent ports A and B
// - Synchronous write/read on clk
// - Port-A priority when both write same address in the same cycle
// - conflict_flag is sticky (stays 1 until reset) so testbench can sample it
// - Author: Teja Reddy
// ==========================================================================
module sync_dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)
)(
    input  wire                     clk,
    input  wire                     reset,

    // Port A
    input  wire                     write_en_a,
    input  wire                     read_en_a,
    input  wire [ADDR_WIDTH-1:0]    addr_a,
    input  wire [DATA_WIDTH-1:0]    data_in_a,
    output reg  [DATA_WIDTH-1:0]    data_out_a,

    // Port B
    input  wire                     write_en_b,
    input  wire                     read_en_b,
    input  wire [ADDR_WIDTH-1:0]    addr_b,
    input  wire [DATA_WIDTH-1:0]    data_in_b,
    output reg  [DATA_WIDTH-1:0]    data_out_b,

    // Sticky on first conflict until reset
    output reg                      conflict_flag
);
    // Memory
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    integer i;
    initial begin
        // Initialize with ascending values (handy for debugging)
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            mem[i] = i[DATA_WIDTH-1:0];

        data_out_a   = {DATA_WIDTH{1'b0}};
        data_out_b   = {DATA_WIDTH{1'b0}};
        conflict_flag= 1'b0;
    end

    // Synchronous read/write
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_a    <= {DATA_WIDTH{1'b0}};
            data_out_b    <= {DATA_WIDTH{1'b0}};
            conflict_flag <= 1'b0;
        end else begin
            // Default: keep previous conflict_flag (sticky)
            // conflict_flag <= conflict_flag;  // implied by no assignment

            // Check same-address write conflict
            if (write_en_a && write_en_b && (addr_a == addr_b)) begin
                // Port A priority
                mem[addr_a] <= data_in_a;
                conflict_flag <= 1'b1;

                // Read-after-write semantics: if reading same cycle, return new data
                if (read_en_a) data_out_a <= data_in_a;
                if (read_en_b) data_out_b <= data_in_a;

            end else begin
                // Independent writes
                if (write_en_a) mem[addr_a] <= data_in_a;
                if (write_en_b) mem[addr_b] <= data_in_b;

                // Reads sample memory (new data visible if same-port wrote same addr this cycle)
                if (read_en_a) data_out_a <= mem[addr_a];
                if (read_en_b) data_out_b <= mem[addr_b];
            end
        end
    end
endmodule
