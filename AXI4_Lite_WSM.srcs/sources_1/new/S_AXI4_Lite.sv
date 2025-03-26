`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2025 05:02:40 PM
// Design Name: 
// Module Name: S_AXI4_Lite
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


module S_AXI4_Lite#(
    parameter AXI_ADDR_WDITH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_STRB_WIDTH = 4,
    parameter AXI_RESP_WIDTH = 2
)(
    // GLOBAL SIGNALS
    input logic S_AXI_ACLK,
    input logic S_AXI_ARESETN,  
    
    // WRITE ADDRESS CHANNEL (AW)
    input   logic [AXI_ADDR_WDITH - 1 : 0]   S_AXI_AWaddr,
    input   logic                            S_AXI_AWvalid,
    output  logic                            S_AXI_AWREADY,
    
    // WRITE DATA CHANNEL (W)
    input   logic [AXI_DATA_WIDTH - 1 : 0]   S_AXI_Wdata,
    input   logic [AXI_STRB_WIDTH - 1 : 0]   S_AXI_Wstrb,
    input   logic                            S_AXI_Wvalid,
    output  logic                            S_AXI_WREADY,
    
    // WRITE RESPONSE CHANNEL (B)
    output  logic [AXI_RESP_WIDTH - 1 : 0]   S_AXI_BRESP,
    output  logic                            S_AXI_BVALID,
    input   logic                            S_AXI_Bready,
    
    // READ ADDRESS CHANNEL (AR)
    input   logic [AXI_ADDR_WDITH - 1 : 0]   S_AXI_ARaddr,
    input   logic                            S_AXI_ARvalid,
    output  logic                            S_AXI_ARREADY,
    
    // READ DATA CHANNEL (R)
    output  logic [AXI_DATA_WIDTH - 1 : 0]   S_AXI_RDATA,
    output  logic [AXI_RESP_WIDTH - 1 : 0]   S_AXI_RRESP,
    output  logic                            S_AXI_RVALID,
    input   logic                            S_AXI_Rready
);
    integer i;
    logic datarec;
    logic [31:0] register[0:31];
    logic [AXI_ADDR_WDITH - 1 : 0]   awaddr,araddr;

    typedef enum logic [2:0] {IDLE,WRITE_ADDRESS,WRITE_DATA,WRITE_RESPONSE,READ_ADDRESS,READ_DATA } state_type;
    state_type state, next_state;
    
//    assign S_AXI_WREADY = (datarec == 1)? 1:0;
    
    always_ff @( posedge S_AXI_ACLK or negedge S_AXI_ARESETN ) begin
        if (!S_AXI_ARESETN) begin
            state   <=  IDLE;
            S_AXI_AWREADY <= 0;
            S_AXI_BVALID <= 0;
            for (i = 0; i < 32; i++) begin
            register[i] <= 32'b0;
        end
        end
//        else if (state == WRITE_DATA) begin
//            register[awaddr]    <=  S_AXI_Wdata;
//            datarec             <=  1;
//        end
        else begin
            state  <=  next_state;
        end
    end

    always_comb begin
        case (state)
            IDLE    :   begin
                S_AXI_RVALID    =   0;
                S_AXI_BVALID    =   0;
                if (S_AXI_AWvalid) begin
                    S_AXI_BRESP =   0;
                    next_state  =   WRITE_ADDRESS;
                end
                else if (S_AXI_ARvalid) begin
                    S_AXI_RRESP =   0;
                    next_state  =   READ_ADDRESS;
                end
                else begin
                    next_state  =   IDLE;
                end
            end 
            WRITE_ADDRESS   :   begin
                S_AXI_AWREADY   =   1;
                awaddr          =   S_AXI_AWaddr;
                if (S_AXI_AWvalid && S_AXI_AWREADY) begin
//                    S_AXI_AWREADY   =   0;
                    next_state  =   WRITE_DATA;
                end
                else begin
                    next_state  =   WRITE_ADDRESS;
                end 
            end
            
            WRITE_DATA  :   begin
                S_AXI_AWREADY   =   0;
                S_AXI_WREADY    =   1;
                register[awaddr]    =  S_AXI_Wdata;
                if (S_AXI_Wvalid && S_AXI_WREADY) begin
                    next_state  =   WRITE_RESPONSE;
                end
                else begin
                    next_state  =   WRITE_DATA;
                end
            end
            
            WRITE_RESPONSE  :   begin;
                S_AXI_BVALID   =   1;
                S_AXI_BRESP =   2'b00;
                if (S_AXI_BVALID && S_AXI_Bready) begin
                    next_state  =   IDLE;
                end
                else begin
                    next_state  =   WRITE_RESPONSE;
                end
            end
            
            READ_ADDRESS    :   begin
                S_AXI_ARREADY   =   1;
                araddr          =   S_AXI_ARaddr;
                if (S_AXI_ARREADY && S_AXI_ARvalid) begin
                    next_state  =   READ_DATA;
                end
                else begin
                    next_state  =   READ_ADDRESS;
                end
            end
            
            READ_DATA   :   begin
                S_AXI_ARREADY   =   0;
                S_AXI_RVALID    =   1;
                S_AXI_RDATA     =   register[araddr];
                if (S_AXI_Rready && S_AXI_RVALID) begin
                    next_state =   IDLE;
                end
                else begin
                    next_state  =  READ_DATA;
                end
                
            end
            
            default: next_state =   IDLE;
        endcase
        
    end
endmodule
