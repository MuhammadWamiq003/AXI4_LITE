`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2025 04:18:30 PM
// Design Name: 
// Module Name: M_AXI4_Lite
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


module M_AXI4_Lite#(
    parameter AXI_ADDR_WDITH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_STRB_WIDTH = 4,
    parameter AXI_RESP_WIDTH = 2
)(
    // GLOBAL SIGNALS
    input logic M_AXI_ACLK,
    input logic M_AXI_ARESETN,

    // Input From Outside
    input  logic                            write_en,
    input  logic                            read_en,
    input  logic [AXI_ADDR_WDITH - 1 : 0]   address,
    input  logic [AXI_DATA_WIDTH - 1 : 0]   data,
    
    // WRITE ADDRESS CHANNEL (AW)
    output logic [AXI_ADDR_WDITH - 1 : 0]   M_AXI_AWADDR,
    output logic                            M_AXI_AWVALID,
    input  logic                            M_AXI_AWready,
    
    // WRITE DATA CHANNEL (W)
    output logic [AXI_DATA_WIDTH - 1 : 0]   M_AXI_WDATA,
    output logic [AXI_STRB_WIDTH - 1 : 0]   M_AXI_WSTRB,
    output logic                            M_AXI_WVALID,
    input  logic                            M_AXI_Wready,
    
    // WRITE RESPONSE CHANNEL (B)
    input  logic [AXI_RESP_WIDTH - 1 : 0]   M_AXI_Bresp,
    input  logic                            M_AXI_Bvalid,
    output logic                            M_AXI_BREADY,
    
    // READ ADDRESS CHANNEL (AR)
    output logic [AXI_ADDR_WDITH - 1 : 0]   M_AXI_ARADDR,
    output logic                            M_AXI_ARVALID,
    input  logic                            M_AXI_ARready,
    
    // READ DATA CHANNEL (R)
    input  logic [AXI_DATA_WIDTH - 1 : 0]   M_AXI_Rdata,
    input  logic [AXI_RESP_WIDTH - 1 : 0]   M_AXI_Rresp,
    input  logic                            M_AXI_Rvalid,
    output logic                            M_AXI_RREADY 
);

    typedef enum logic [2:0] {IDLE,WRITE_ADDRESS,WRITE_DATA,WRITE_RESPONSE,READ_ADDRESS,READ_DATA } state_type;
    state_type state, next_state;

    logic w_en, r_en;
    logic [31:0] mem;
    always_ff @( posedge M_AXI_ACLK or negedge M_AXI_ARESETN ) begin
        if (!M_AXI_ARESETN) begin
            state   <=  IDLE;
            M_AXI_AWADDR <= 0;
            M_AXI_AWVALID <= 0;
            w_en    <=  0;
            r_en    <=  0;
        end
        else begin
            state   <=  next_state;
            w_en    <=  write_en;
            r_en    <=  read_en;
        end
    end

    always_comb begin
        case (state)
            IDLE    :   begin
                M_AXI_BREADY    =   0;
                M_AXI_RREADY    =   0;
                if (w_en) begin
                    next_state  =  WRITE_ADDRESS;
                end
                else if (r_en) begin
                    next_state  =  READ_ADDRESS;
                end
                else begin
                    next_state  =  IDLE;
                end
            end 
            
            WRITE_ADDRESS   :   begin
                M_AXI_AWADDR    =   address;
                M_AXI_AWVALID   =   1;
                if (M_AXI_AWVALID && M_AXI_AWready) begin
//                    M_AXI_AWVALID   =   0;
                    next_state  =   WRITE_DATA;
                end
                else begin
                    next_state  =   WRITE_ADDRESS;
                end 
            end
            
            WRITE_DATA  :   begin
                M_AXI_AWVALID   =   0;
                M_AXI_WVALID   =   1;
                M_AXI_WDATA     =   data;
                M_AXI_WSTRB     =   4'b1111;
                M_AXI_BREADY    =   1;
                if (M_AXI_WVALID && M_AXI_Wready) begin
                    next_state  =   WRITE_RESPONSE;
                end
                else begin
                    next_state  =   WRITE_DATA;
                end    
            end
            
            WRITE_RESPONSE  : begin
                M_AXI_WVALID   =   0;
                if (M_AXI_Bvalid && M_AXI_BREADY) begin
                    next_state  =   IDLE;
                end
                else begin
                    next_state  =  WRITE_RESPONSE; 
                end
            end
            
            READ_ADDRESS    :   begin
                M_AXI_ARADDR    =   address;
                M_AXI_ARVALID   =   1;
                M_AXI_RREADY    =   1;
                if(M_AXI_ARVALID && M_AXI_ARready) begin
                    next_state  =  READ_DATA;
                end
                else begin
                    next_state  =  READ_ADDRESS;
                end
            end
            
            READ_DATA    :   begin
                M_AXI_ARVALID   =   0;
                mem             =   M_AXI_Rdata;
                if (M_AXI_RREADY && M_AXI_Rvalid) begin
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
