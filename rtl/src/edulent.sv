`timescale 1ns / 1ps

module edulent(
    input wire i_clk,
    input wire i_rstn,
    input wire [7:0] i_in,
    output wire [7:0] o_out
);

    // Internal signals
    wire [7:0] i_opcode;
    wire o_alu_calculate;
    wire [3:0] o_transfer_cmd;
    wire o_inc_pc;
    wire [1:0] o_inc_dec_sp;
    wire o_alu_res_to_ap;
    wire [7:0] o_mem_addr;
    wire [7:0] i_mem_data_read;
    wire [7:0] o_mem_data_write;
    wire mem_write_enable;
    wire reset_ir;

    // Instantiate the Control Unit
    control_unit control (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_opcode(i_opcode),
        .o_alu_calculate(o_alu_calculate),
        .o_transfer_cmd(o_transfer_cmd),
        .o_inc_pc(o_inc_pc),
        .o_inc_dec_sp(o_inc_dec_sp),
        .o_alu_res_to_ap(o_alu_res_to_ap),
        .o_reset_ir(reset_ir)
    );

    // Instantiate the Data Path
    data_path data (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_alu_calculate(o_alu_calculate),
        .i_transfer_cmd(o_transfer_cmd),
        .i_inc_pc(o_inc_pc),
        .i_inc_dec_sp(o_inc_dec_sp),
        .i_in(i_in),
        .o_out(o_out),
        .i_alu_res_to_ap(o_alu_res_to_ap),
        .o_mem_addr(o_mem_addr),
        .i_mem_data_read(i_mem_data_read),
        .o_mem_data_write(o_mem_data_write),
        .o_IR(i_opcode),
        .i_reset_ir(reset_ir),
        .o_mem_write_enable(mem_write_enable)
    );

    // Instantiate the Memory Module
    memory mem (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_mem_addr(o_mem_addr),
        .i_mem_data_write(o_mem_data_write),
        .o_mem_data_read(i_mem_data_read),
        .i_mem_write_enable(mem_write_enable)
    );

    
endmodule
