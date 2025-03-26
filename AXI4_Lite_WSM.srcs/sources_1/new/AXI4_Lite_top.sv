`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 04:21:16 PM
// Design Name: 
// Module Name: AXI4_Lite_top
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


module AXI4_Lite_top#(
    parameter AXI_ADDR_WDITH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_STRB_WIDTH = 4,
    parameter AXI_RESP_WIDTH = 2
)
(
    // GLOBAL SIGNALS
    input logic AXI_ACLK,
    input logic AXI_ARESETN,

    // Input From Outside
    input  logic                            write_en,
    input  logic                            read_en,
    input  logic [AXI_ADDR_WDITH - 1 : 0]   address,
    input  logic [AXI_DATA_WIDTH - 1 : 0]   data

);

    logic [AXI_ADDR_WDITH - 1 : 0]   M_AWADDR, M_ARADDR;
    logic [AXI_DATA_WIDTH - 1 : 0]   M_WDATA, S_RDATA;
    logic [AXI_STRB_WIDTH - 1 : 0]   M_WSTRB, S_RSTRB;
    logic [AXI_RESP_WIDTH - 1 : 0]   S_BRESP, S_RRESP;
    logic M_AWVALID, S_AWREADY, M_WVALID, S_WREADY, S_BVALID, M_BREADY, M_ARVALID, S_ARREADY, S_RVALID, M_RREADY;

    M_AXI4_Lite uut_M_AXI4_Lite
    (
        .M_AXI_ACLK(AXI_ACLK),
        .M_AXI_ARESETN(AXI_ARESETN),
        .write_en(write_en),
        .read_en(read_en),
        .address(address),
        .data(data),
        .M_AXI_AWADDR(M_AWADDR),
        .M_AXI_AWVALID(M_AWVALID),
        .M_AXI_AWready(S_AWREADY),
        .M_AXI_WDATA(M_WDATA),
        .M_AXI_WSTRB(M_WSTRB),
        .M_AXI_WVALID(M_WVALID),
        .M_AXI_Wready(S_WREADY),
        .M_AXI_Bresp(S_BRESP),
        .M_AXI_Bvalid(S_BVALID),
        .M_AXI_BREADY(M_BREADY),
        .M_AXI_ARADDR(M_ARADDR),
        .M_AXI_ARVALID(M_ARVALID),
        .M_AXI_ARready(S_ARREADY),
        .M_AXI_Rdata(S_RDATA),
        .M_AXI_Rresp(S_RRESP),
        .M_AXI_Rvalid(S_RVALID),
        .M_AXI_RREADY(M_RREADY)
    );

    S_AXI4_Lite uut_S_AXI4_Lite
    (
        .S_AXI_ACLK(AXI_ACLK),
        .S_AXI_ARESETN(AXI_ARESETN),
        .S_AXI_AWaddr(M_AWADDR),
        .S_AXI_AWvalid(M_AWVALID),
        .S_AXI_AWREADY(S_AWREADY),
        .S_AXI_Wdata(M_WDATA),
        .S_AXI_Wstrb(M_WSTRB),
        .S_AXI_Wvalid(M_WVALID),
        .S_AXI_WREADY(S_WREADY),
        .S_AXI_BRESP(S_BRESP),
        .S_AXI_BVALID(S_BVALID),
        .S_AXI_Bready(M_BREADY),
        .S_AXI_ARaddr(M_ARADDR),
        .S_AXI_ARvalid(M_ARVALID),
        .S_AXI_ARREADY(S_ARREADY),
        .S_AXI_RDATA(S_RDATA),
        .S_AXI_RRESP(S_RRESP),
        .S_AXI_RVALID(S_RVALID),
        .S_AXI_Rready(M_RREADY)
    );
endmodule
