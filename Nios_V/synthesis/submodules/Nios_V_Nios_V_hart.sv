// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ns / 1 ns

// Following localparams are created as a result of hammer failures for quartus_tlg
// quartus_tlg does not process encrypted files & if opcode_def is imported here it does not work.
// MXLEN will be a user parameter when we have 64 bit core implementation
//   localparam MXLEN_LOCAL  = 32;
//   localparam ADDR_W_LOCAL = MXLEN_LOCAL;
//   localparam DATA_W_LOCAL = MXLEN_LOCAL;
// Commenting out above param declarations as it causes redeclarations compile errors in case
// the design has 2 niosv cores instantiated, hardcoding values for 32 bit core now : TODO

module Nios_V_Nios_V_hart #(
   parameter DBG_EXPN_VECTOR = 32'h80000000,
   parameter RESET_VECTOR = 32'h00000000,
   parameter CORE_EXTN = 26'h0000100, // RV32I
   parameter HARTID = 32'h00000000,
   parameter DEBUG_ENABLED = 1'b0,
   parameter DEVICE_FAMILY = "Stratix 10",
   parameter DBG_PARK_LOOP_OFFSET = 32'd24,
   parameter USE_RESET_REQ = 1'b0,
   parameter SMALL_CORE = 1'b0,
   parameter ECC_EN = 1'b0 
) (
   input wire clk,
   input wire reset,
   input wire reset_req,
   output wire reset_req_ack,


   // ================== Instruction Interface ==================
 
   // write command
   //    address
   output wire [31:0]       instr_awaddr,
   output wire [2:0]        instr_awprot,
   output wire              instr_awvalid,
   output wire [2:0]        instr_awsize,
   input                    instr_awready,
   input                    instr_arready,
   //  data
   output wire              instr_wvalid,
   output wire [31:0]       instr_wdata,
   output wire [3:0]        instr_wstrb,
   output wire              instr_wlast,
   input                    instr_wready,
 
   //write response
   input                    instr_bvalid,
   input [1:0]              instr_bresp,
   output wire              instr_bready,
 
   //read command
   output wire [31:0]       instr_araddr,             
   output wire              instr_arvalid,            
   output wire [2:0]        instr_arprot,
   output wire [2:0]        instr_arsize,
 
   //read response
   input [31:0]             instr_rdata,              
   input                    instr_rvalid,             
   input [1:0]              instr_rresp,              
   output wire              instr_rready,
   

   // ===================== Data Interface ======================

   // write command
   //    address
   output wire [31:0]       data_awaddr,
   output wire [2:0]        data_awprot,
   output wire [2:0]        data_awsize,
   output wire              data_awvalid,             
   input                    data_awready,
   //  data
   output wire [31:0]       data_wdata,               
   output wire [3:0]        data_wstrb,               
   output wire              data_wvalid,
   output wire              data_wlast,
   input                    data_wready,
 
   //write response
   input                    data_bvalid,              
   output wire              data_bready,
   input       [1:0]        data_bresp,
 
   //read command
   output wire [31:0]       data_araddr,              
   output wire [2:0]        data_arprot,
   output wire [2:0]        data_arsize,
   output wire              data_arvalid,             
   input                    data_arready,
 
   //read response
   input [31:0]             data_rdata,               
   input                    data_rvalid,              
   input [1:0]              data_rresp,               
   output wire              data_rready,

   input wire        irq_timer,
   input wire        irq_sw,
   input wire [15:0] irq_plat_vec,
   input wire        irq_ext,

   input wire        irq_debug,

   output wire [1:0] core_ecc_status,
   output wire [3:0] core_ecc_src
);




   generate 
      if(SMALL_CORE == 1'b0) begin : m_core
         niosv_m_core # (
            .DBG_EXPN_VECTOR (DBG_EXPN_VECTOR),
            .RESET_VECTOR (RESET_VECTOR),
            .CORE_EXTN (CORE_EXTN),
            .HARTID(HARTID),
            .DEBUG_ENABLED (DEBUG_ENABLED),
            .DEVICE_FAMILY (DEVICE_FAMILY),
            .DBG_PARK_LOOP_OFFSET (DBG_PARK_LOOP_OFFSET),
            .USE_RESET_REQ (USE_RESET_REQ),
            .ECC_EN (ECC_EN)
         ) niosv_m_full_inst (
               //.*       // for axi-4 lite connect top level to core level directly without the shim
               .instr_awready (instr_awready),
               .instr_wready  (instr_wready), 
               .instr_bvalid  (instr_bvalid),
               .instr_bresp   (instr_bresp),
               .instr_arready (instr_arready),

               .data_arready  (data_arready),
               .data_awready  (data_awready), 
               .data_wready   (data_wready), 
               .data_bresp    (data_bresp),

               .clk           (clk),
               .reset         (reset),
               .reset_req     (reset_req),
               .reset_req_ack (reset_req_ack),

               .instr_awaddr  (instr_awaddr),   
               .instr_awprot  (instr_awprot),   
               .instr_awvalid (instr_awvalid),   
               .instr_awsize  (instr_awsize),   

               .instr_wvalid  (instr_wvalid),   
               .instr_wdata   (instr_wdata),   
               .instr_wstrb   (instr_wstrb),   
               .instr_wlast   (instr_wlast),   

               .instr_bready  (instr_bready),   

               .instr_araddr  (instr_araddr),
               .instr_arprot  (instr_arprot),   
               .instr_arvalid (instr_arvalid),
               .instr_arsize  (instr_arsize),   

               .instr_rdata   (instr_rdata),
               .instr_rvalid  (instr_rvalid),
               .instr_rresp   (instr_rresp),
               .instr_rready  (instr_rready),   

               .data_awaddr   (data_awaddr),   
               .data_awprot   (data_awprot),   
               .data_awvalid  (data_awvalid),
               .data_awsize   (data_awsize),   

               .data_wvalid   (data_wvalid),   
               .data_wdata    (data_wdata),
               .data_wstrb    (data_wstrb),
               .data_wlast    (data_wlast),   

               .data_bvalid   (data_bvalid),
               .data_bready   (data_bready),   

               .data_araddr   (data_araddr),
               .data_arprot   (data_arprot),   
               .data_arvalid  (data_arvalid),
               .data_arsize   (data_arsize),   

               .data_rdata    (data_rdata),
               .data_rvalid   (data_rvalid),
               .data_rresp    (data_rresp),
               .data_rready   (data_rready),   

               .irq_timer     (irq_timer),
               .irq_sw        (irq_sw),
               .irq_plat_vec  (irq_plat_vec),
               .irq_ext       (irq_ext),
               .irq_debug     (irq_debug),

               .core_ecc_status  (core_ecc_status),
               .core_ecc_src     (core_ecc_src)
         );
      end
      else begin : s_core
         niosv_c_core # (
            .DBG_EXPN_VECTOR (DBG_EXPN_VECTOR),
            .RESET_VECTOR (RESET_VECTOR),
            .CORE_EXTN (CORE_EXTN),
            .HARTID(HARTID),
            .DEBUG_ENABLED (DEBUG_ENABLED),
            .DEVICE_FAMILY (DEVICE_FAMILY),
            .DBG_PARK_LOOP_OFFSET (DBG_PARK_LOOP_OFFSET),
            .USE_RESET_REQ (USE_RESET_REQ),
            .CSR_ENABLED (1'b1),
            .ECC_EN (ECC_EN)
         ) niosv_m_small_inst (
               //.*       // for axi-4 lite connect top level to core level directly without the shim
               .instr_awready (instr_awready),
               .instr_wready  (instr_wready), 
               .instr_bvalid  (instr_bvalid),
               .instr_bresp   (instr_bresp),
               .instr_arready (instr_arready),

               .data_arready  (data_arready),
               .data_awready  (data_awready), 
               .data_wready   (data_wready), 
               .data_bresp    (data_bresp),

               .clk           (clk),
               .reset         (reset),
               .reset_req     (reset_req),
               .reset_req_ack (reset_req_ack),

               .instr_awaddr  (instr_awaddr),   
               .instr_awprot  (instr_awprot),   
               .instr_awvalid (instr_awvalid),   
               .instr_awsize  (instr_awsize),   

               .instr_wvalid  (instr_wvalid),   
               .instr_wdata   (instr_wdata),   
               .instr_wstrb   (instr_wstrb),   
               .instr_wlast   (instr_wlast),   

               .instr_bready  (instr_bready),   

               .instr_araddr  (instr_araddr),
               .instr_arprot  (instr_arprot),   
               .instr_arvalid (instr_arvalid),
               .instr_arsize  (instr_arsize),   

               .instr_rdata   (instr_rdata),
               .instr_rvalid  (instr_rvalid),
               .instr_rresp   (instr_rresp),
               .instr_rready  (instr_rready),   

               .data_awaddr   (data_awaddr),   
               .data_awprot   (data_awprot),   
               .data_awvalid  (data_awvalid),
               .data_awsize   (data_awsize),   

               .data_wvalid   (data_wvalid),   
               .data_wdata    (data_wdata),
               .data_wstrb    (data_wstrb),
               .data_wlast    (data_wlast),   

               .data_bvalid   (data_bvalid),
               .data_bready   (data_bready),   

               .data_araddr   (data_araddr),
               .data_arprot   (data_arprot),   
               .data_arvalid  (data_arvalid),
               .data_arsize   (data_arsize),   

               .data_rdata    (data_rdata),
               .data_rvalid   (data_rvalid),
               .data_rresp    (data_rresp),
               .data_rready   (data_rready),   

               .irq_timer     (irq_timer),
               .irq_sw        (irq_sw),
               .irq_plat_vec  (irq_plat_vec),
               .irq_ext       (irq_ext),
               .irq_debug     (irq_debug),

               .core_ecc_status  (core_ecc_status),
               .core_ecc_src     (core_ecc_src)
         );
      end
   endgenerate


endmodule

