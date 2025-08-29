// ==========================================================================
// Asynchronous Dual-Port ROM
// - REGISTERED_OUT=0 here → pure combinational read
// - INIT_PATTERN: 0=zero, 1=x^2 + x, 2=linear
// - Prints contents at time 0 (for easy verification)
// - Author: Teja Reddy
// ==========================================================================
module async_dual_port_rom #(
    parameter DATA_WIDTH     = 8,
    parameter ADDR_WIDTH     = 4,
    parameter MEM_DEPTH      = (1 << ADDR_WIDTH),
    parameter INIT_PATTERN   = 1,  // 1 = x^2 + x
    parameter REGISTERED_OUT = 0   // keep 0 for pure async
)(
    input  wire [ADDR_WIDTH-1:0]    addr_a,
    input  wire                     read_en_a,
    output reg  [DATA_WIDTH-1:0]    data_out_a,

    input  wire [ADDR_WIDTH-1:0]    addr_b,
    input  wire                     read_en_b,
    output reg  [DATA_WIDTH-1:0]    data_out_b,

    // These are ignored when REGISTERED_OUT=0 (kept for interface symmetry)
    input  wire                     clk,
    input  wire                     reset
);
    reg [DATA_WIDTH-1:0] rom [0:MEM_DEPTH-1];

    integer i;
    reg [DATA_WIDTH-1:0] tmp;
    reg [31:0] w;

    function [DATA_WIDTH-1:0] calc_rom_data;
        input integer a;
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

        $display("---- Asynchronous Dual-Port ROM Contents ----");
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            $display("Address %0d : %02h", i, rom[i]);
    end

generate
if (REGISTERED_OUT == 0) begin : G_ASYNC
    always @(*) begin
        if (reset) begin
            data_out_a = {DATA_WIDTH{1'b0}};
        end else begin
            data_out_a = read_en_a ? rom[addr_a] : {DATA_WIDTH{1'b0}};
        end
    end

    always @(*) begin
        if (reset) begin
            data_out_b = {DATA_WIDTH{1'b0}};
        end else begin
            data_out_b = read_en_b ? rom[addr_b] : {DATA_WIDTH{1'b0}};
        end
    end
end else begin : G_SYNC  // not used in this TB, but provided for completeness
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_a <= {DATA_WIDTH{1'b0}};
            data_out_b <= {DATA_WIDTH{1'b0}};
        end else begin
            if (read_en_a) data_out_a <= rom[addr_a];
            if (read_en_b) data_out_b <= rom[addr_b];
        end
    end
end
endgenerate
endmodule
