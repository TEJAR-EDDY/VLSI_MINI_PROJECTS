// ==========================================================================
// Synchronous Dual-Port ROM
// - REGISTERED_OUT=1 → outputs update on clk edges (recommended for FPGA)
// - INIT_PATTERN: 0=zero, 1=x^2 + x, 2=linear (addr)
// - Prints contents at time 0 (nice for sanity checks)
// - Author: Teja Reddy
// ==========================================================================
module sync_dual_port_rom #(
    parameter DATA_WIDTH     = 8,
    parameter ADDR_WIDTH     = 4,
    parameter MEM_DEPTH      = (1 << ADDR_WIDTH),
    parameter REGISTERED_OUT = 1,  // 1: Registered outputs, 0: Comb outputs
    parameter INIT_PATTERN   = 1   // 0:zeros, 1:x^2+x, 2:linear
)(
    input  wire                     clk,
    input  wire                     reset,

    input  wire [ADDR_WIDTH-1:0]    addr_a,
    output reg  [DATA_WIDTH-1:0]    data_out_a,
    input  wire                     read_en_a,

    input  wire [ADDR_WIDTH-1:0]    addr_b,
    output reg  [DATA_WIDTH-1:0]    data_out_b,
    input  wire                     read_en_b
);
    reg [DATA_WIDTH-1:0] rom [0:MEM_DEPTH-1];

    integer i;
    reg [DATA_WIDTH-1:0] tmp;

    function [DATA_WIDTH-1:0] calc_rom_data;
        input integer a;
        reg [31:0] w;
        begin
            case (INIT_PATTERN)
                0: calc_rom_data = {DATA_WIDTH{1'b0}};
                1: begin w = a*a + a; calc_rom_data = w[DATA_WIDTH-1:0]; end
                2: calc_rom_data = a[DATA_WIDTH-1:0];
                default: calc_rom_data = {DATA_WIDTH{1'b0}};
            endcase
        end
    endfunction

    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            tmp     = calc_rom_data(i);
            rom[i]  = tmp;
        end
        data_out_a = {DATA_WIDTH{1'b0}};
        data_out_b = {DATA_WIDTH{1'b0}};

        // Human-friendly dump of ROM contents
        $display("ROM Contents:");
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            $display("Address %0d: %02h", i, rom[i]);
    end

generate
if (REGISTERED_OUT) begin : G_REG
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_a <= {DATA_WIDTH{1'b0}};
            data_out_b <= {DATA_WIDTH{1'b0}};
        end else begin
            if (read_en_a) data_out_a <= rom[addr_a];
            if (read_en_b) data_out_b <= rom[addr_b];
        end
    end
end else begin : G_COMB
    always @(*) begin
        if (reset) begin
            data_out_a = {DATA_WIDTH{1'b0}};
            data_out_b = {DATA_WIDTH{1'b0}};
        end else begin
            data_out_a = read_en_a ? rom[addr_a] : {DATA_WIDTH{1'b0}};
            data_out_b = read_en_b ? rom[addr_b] : {DATA_WIDTH{1'b0}};
        end
    end
end
endgenerate
endmodule
