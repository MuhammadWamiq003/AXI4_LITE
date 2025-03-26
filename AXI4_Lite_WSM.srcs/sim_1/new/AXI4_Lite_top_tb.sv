`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 04:58:08 PM
// Design Name: 
// Module Name: AXI4_Lite_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module AXI4_Lite_top_tb;
    
    // Parameters
    parameter AXI_ADDR_WDITH = 32;
    parameter AXI_DATA_WIDTH = 32;
    
    // Testbench signals
    logic AXI_ACLK;
    logic AXI_ARESETN;
    logic write_en;
    logic read_en;
    logic [AXI_ADDR_WDITH-1:0] address;
    logic [AXI_DATA_WIDTH-1:0] data;
    
    // Instantiate DUT
    AXI4_Lite_top uut (
        .AXI_ACLK(AXI_ACLK),
        .AXI_ARESETN(AXI_ARESETN),
        .write_en(write_en),
        .read_en(read_en),
        .address(address),
        .data(data)
    );
    
    // Clock Generation
    always #5 AXI_ACLK = ~AXI_ACLK;  // 100MHz clock

    // Test Sequence
    initial begin
        // Initialize signals
        AXI_ACLK = 0;
        AXI_ARESETN = 0;
        write_en = 0;
        read_en = 0;
        address = 0;
        data = 0;
        
        // Reset sequence
        #20;
        AXI_ARESETN = 1;
        #10;

//         Write Operation Test
        $display("Starting Write Operation...");
        address = 32'h0000_0001;
        data = 32'hDEAD_BEEF;
        write_en = 1;
        #10;
        write_en = 0;
        #20;

//        // Read Operation Test
        $display("Starting Read Operation...");
        address = 32'h0000_0001;
        #40read_en = 1;
        #10;
        read_en = 0;
        #20;
        #100   $finish;
//        // End simulation
//        $display("Test Completed.");
//        $stop;
        
    end
    initial begin
              $dumpfile("AXI4_Lite_top_tb.vcd");
              $dumpvars(0, AXI4_Lite_top_tb);
          end

endmodule
