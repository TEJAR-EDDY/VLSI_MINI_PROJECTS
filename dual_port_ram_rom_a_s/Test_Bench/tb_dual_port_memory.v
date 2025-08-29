// ==========================================================================
// Comprehensive Testbench for Dual Port Memory Verification (Icarus-friendly)
// - Matches your original flow & messages
// - Parameterized widths/depths
// - Tests: sync RAM (single/dual/conflicts), sync ROM, async RAM, async ROM
// - Author: Teja Reddy
// ==========================================================================
`timescale 1ns/1ps

module dual_port_memory_tb;

    // Parameters (edit here)
    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 4;
    localparam MEM_DEPTH  = (1 << ADDR_WIDTH);

    // Common TB signals
    reg clk;
    reg reset;
    reg [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg [DATA_WIDTH-1:0] data_in_a, data_in_b;
    reg write_en_a, write_en_b;
    reg read_en_a,  read_en_b;

    // DUT outputs
    wire [DATA_WIDTH-1:0] sync_ram_data_out_a, sync_ram_data_out_b;
    wire [DATA_WIDTH-1:0] sync_rom_data_out_a, sync_rom_data_out_b;
    wire [DATA_WIDTH-1:0] async_ram_data_out_a, async_ram_data_out_b;
    wire [DATA_WIDTH-1:0] async_rom_data_out_a, async_rom_data_out_b;
    wire sync_ram_conflict, async_ram_conflict;

    integer test_count, pass_count, fail_count;

    // -----------------------
    // DUT instantiations
    // -----------------------
    sync_dual_port_ram #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH)
    ) u_sync_ram (
        .clk(clk), .reset(reset),
        .write_en_a(write_en_a), .read_en_a(read_en_a),
        .addr_a(addr_a), .data_in_a(data_in_a), .data_out_a(sync_ram_data_out_a),
        .write_en_b(write_en_b), .read_en_b(read_en_b),
        .addr_b(addr_b), .data_in_b(data_in_b), .data_out_b(sync_ram_data_out_b),
        .conflict_flag(sync_ram_conflict)
    );

    sync_dual_port_rom #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH),
        .REGISTERED_OUT(1),
        .INIT_PATTERN(1)
    ) u_sync_rom (
        .clk(clk), .reset(reset),
        .addr_a(addr_a), .data_out_a(sync_rom_data_out_a), .read_en_a(read_en_a),
        .addr_b(addr_b), .data_out_b(sync_rom_data_out_b), .read_en_b(read_en_b)
    );

    async_dual_port_ram #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH),
        .INIT_PATTERN(8'hAA),
        .RESET_VALUE (8'h00),
        .HI_Z_OUTPUT (0),   // hold last value when not reading (easier checks)
        .PORT_A_PRIORITY(1)
    ) u_async_ram (
        .reset(reset),
        .addr_a(addr_a), .data_in_a(data_in_a), .data_out_a(async_ram_data_out_a),
        .write_en_a(write_en_a), .read_en_a(read_en_a),
        .addr_b(addr_b), .data_in_b(data_in_b), .data_out_b(async_ram_data_out_b),
        .write_en_b(write_en_b), .read_en_b(read_en_b),
        .conflict_flag(async_ram_conflict)
    );

    async_dual_port_rom #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .MEM_DEPTH  (MEM_DEPTH),
        .REGISTERED_OUT(0),
        .INIT_PATTERN(1)
    ) u_async_rom (
        .addr_a(addr_a), .read_en_a(read_en_a), .data_out_a(async_rom_data_out_a),
        .addr_b(addr_b), .read_en_b(read_en_b), .data_out_b(async_rom_data_out_b),
        .clk(clk), .reset(reset)  // ignored when REGISTERED_OUT=0
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // -----------------------
    // Helper: idle all
    // -----------------------
    task idle_all;
        begin
            addr_a = {ADDR_WIDTH{1'b0}};
            addr_b = {ADDR_WIDTH{1'b0}};
            data_in_a = {DATA_WIDTH{1'b0}};
            data_in_b = {DATA_WIDTH{1'b0}};
            write_en_a = 1'b0;
            write_en_b = 1'b0;
            read_en_a  = 1'b0;
            read_en_b  = 1'b0;
        end
    endtask

    // -----------------------
    // Suite 1: Single Port Ops (SYNC RAM)
    // -----------------------
    task test_single_port_operations;
        begin
            $display("\n--- Test Suite 1: Single Port Operations ---");

            // Port A write then read
            test_count = test_count + 1;
            @(posedge clk);
            addr_a = 4'h5; data_in_a = 8'hA5; write_en_a = 1; read_en_a = 0;
            @(posedge clk);
            write_en_a = 0; read_en_a = 1;
            @(posedge clk);
            if (sync_ram_data_out_a == 8'hA5) begin
                $display("PASS: Port A Expected A5, Got %02h", sync_ram_data_out_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Port A Expected A5, Got %02h", sync_ram_data_out_a);
                fail_count = fail_count + 1;
            end
            read_en_a = 0;

            // Port B write then read
            test_count = test_count + 1;
            @(posedge clk);
            addr_b = 4'h3; data_in_b = 8'h3C; write_en_b = 1; read_en_b = 0;
            @(posedge clk);
            write_en_b = 0; read_en_b = 1;
            @(posedge clk);
            if (sync_ram_data_out_b == 8'h3C) begin
                $display("PASS: Port B Expected 3C, Got %02h", sync_ram_data_out_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Port B Expected 3C, Got %02h", sync_ram_data_out_b);
                fail_count = fail_count + 1;
            end
            read_en_b = 0;
        end
    endtask

    // -----------------------
    // Suite 2: Dual Port Ops (SYNC RAM)
    // -----------------------
    task test_dual_port_operations;
        begin
            $display("\n--- Test Suite 2: Dual Port Simultaneous Operations ---");

            // 2.1 simultaneous read different addresses (from Suite 1 values)
            test_count = test_count + 1;
            @(posedge clk);
            addr_a = 4'h5; addr_b = 4'h3; read_en_a = 1; read_en_b = 1;
            @(posedge clk);
            if (sync_ram_data_out_a == 8'hA5 && sync_ram_data_out_b == 8'h3C) begin
                $display("PASS: Simul Read A:A5 B:3C");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Simul Read A:%02h B:%02h", sync_ram_data_out_a, sync_ram_data_out_b);
                fail_count = fail_count + 1;
            end
            read_en_a = 0; read_en_b = 0;

            // 2.2 Simultaneous write different addresses then readback
            test_count = test_count + 1;
            @(posedge clk);
            addr_a = 4'h7; addr_b = 4'h9;
            data_in_a = 8'h77; data_in_b = 8'h99;
            write_en_a = 1; write_en_b = 1;
            read_en_a = 0; read_en_b = 0;

            @(posedge clk);
            write_en_a = 0; write_en_b = 0;
            read_en_a = 1; read_en_b = 1;

            @(posedge clk);
            if (sync_ram_data_out_a == 8'h77 && sync_ram_data_out_b == 8'h99) begin
                $display("PASS: Simultaneous Write/Read OK");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Simultaneous Write/Read A:%02h B:%02h",
                         sync_ram_data_out_a, sync_ram_data_out_b);
                fail_count = fail_count + 1;
            end
            read_en_a = 0; read_en_b = 0;
        end
    endtask

    // -----------------------
    // Suite 3: Address Conflict (SYNC RAM, Port A priority)
    // -----------------------
    task test_address_conflicts;
        begin
            $display("\n--- Test Suite 3: Address Conflict ---");

            test_count = test_count + 1;
            @(posedge clk);
            addr_a = 4'hC; addr_b = 4'hC;
            data_in_a = 8'hAA; data_in_b = 8'hBB;
            write_en_a = 1; write_en_b = 1;

            @(posedge clk);
            write_en_a = 0; write_en_b = 0;
            read_en_a  = 1; read_en_b  = 1;

            @(posedge clk);
            if (sync_ram_data_out_a == 8'hAA && sync_ram_data_out_b == 8'hAA && (sync_ram_conflict == 1'b1)) begin
                $display("PASS: Conflict Same Addr Write -> Port A Wins (AA)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Conflict Got A:%02h B:%02h Flag:%b",
                         sync_ram_data_out_a, sync_ram_data_out_b, sync_ram_conflict);
                fail_count = fail_count + 1;
            end
            read_en_a = 0; read_en_b = 0;
        end
    endtask

    // -----------------------
    // Suite 4: ROM Verification (SYNC ROM only, x^2 + x)
    // -----------------------
    task test_rom_functionality;
        begin
            $display("\n--- Test Suite 4: ROM Verification ---");

            test_count = test_count + 1;
            @(posedge clk);
            addr_a = 4'h4; addr_b = 4'h7;
            read_en_a = 1; read_en_b = 1;

            @(posedge clk);
            if (sync_rom_data_out_a == 8'h14 && sync_rom_data_out_b == 8'h38) begin
                $display("PASS: ROM Lookup OK");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: ROM Lookup A:%02h B:%02h",
                         sync_rom_data_out_a, sync_rom_data_out_b);
                fail_count = fail_count + 1;
            end
            read_en_a = 0; read_en_b = 0;
        end
    endtask

    // -----------------------
    // Suite 5: Async Memories (RAM + ROM)
    // -----------------------
    task test_async_memory;
        begin
            $display("\n--- Test Suite 5: Async Memories ---");

            // Async RAM: write then immediate read
            test_count = test_count + 1;
            addr_a = 4'h2; data_in_a = 8'h55; write_en_a = 1;
            #1; write_en_a = 0; read_en_a = 1; #1;
            if (async_ram_data_out_a == 8'h55) begin
                $display("PASS: Async RAM Write/Read OK");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Async RAM Write/Read Expected 55, Got %02h", async_ram_data_out_a);
                fail_count = fail_count + 1;
            end
            read_en_a = 0;

            // Async RAM: conflict test (A wins)
            test_count = test_count + 1;
            addr_a = 4'h6; addr_b = 4'h6;
            data_in_a = 8'h11; data_in_b = 8'h22;
            write_en_a = 1; write_en_b = 1; #1;
            write_en_a = 0; write_en_b = 0;
            read_en_a  = 1; #1;

            if (async_ram_data_out_a == 8'h11 && (async_ram_conflict == 1'b1)) begin
                $display("PASS: Async Conflict -> Port A Wins (11)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Async Conflict Got %02h Flag:%b", async_ram_data_out_a, async_ram_conflict);
                fail_count = fail_count + 1;
            end
            read_en_a = 0;

            // Async ROM: check same addresses as sync ROM
            test_count = test_count + 1;
            addr_a = 4'h4; addr_b = 4'h7; read_en_a = 1; read_en_b = 1; #1;
            if (async_rom_data_out_a == 8'h14 && async_rom_data_out_b == 8'h38) begin
                $display("PASS: Async ROM Lookup OK");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Async ROM Lookup A:%02h B:%02h",
                         async_rom_data_out_a, async_rom_data_out_b);
                fail_count = fail_count + 1;
            end
            read_en_a = 0; read_en_b = 0;
        end
    endtask

    // -----------------------
    // Summary
    // -----------------------
    task display_test_summary;
        begin
            $display("\n==========================================");
            $display(" Verification Summary");
            $display(" Total Tests : %0d", test_count);
            $display(" Passed      : %0d", pass_count);
            $display(" Failed      : %0d", fail_count);
            $display("==========================================");
        end
    endtask

    // -----------------------
    // Run control
    // -----------------------
    initial begin
        $dumpfile("dual_port_memory.vcd");
        $dumpvars(0, dual_port_memory_tb);

        // Init
        clk = 1'b0;
        reset = 1'b1;
        idle_all();
        test_count = 0; pass_count = 0; fail_count = 0;

        $display("==========================================");
        $display("  DUAL PORT MEMORY VERIFICATION STARTED");
        $display("==========================================");

        // Release reset after some clocks (for sync blocks)
        #20 reset = 1'b0;

        // Run suites
        test_single_port_operations();
        test_dual_port_operations();
        test_address_conflicts();
        test_rom_functionality();
        test_async_memory();

        // Summary & finish
        display_test_summary();
        #100 $finish;
    end
endmodule
