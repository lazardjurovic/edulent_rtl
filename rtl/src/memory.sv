`timescale 1ns / 1ps

module memory (
    input  wire        i_clk,
    input  wire        i_rstn,
    input  wire [7:0]  i_mem_addr,
    input  wire [7:0]  i_mem_data_write,
    input  wire        i_mem_write_enable,
    output reg  [7:0]  o_mem_data_read
);

    // BRAM storage
    reg [7:0] bram [255:0];
    
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            // Optional: Initialize memory to zero
            o_mem_data_read <= 8'b0;
        end else begin
            if (i_mem_write_enable) begin
                bram[i_mem_addr] <= i_mem_data_write; // Write operation
            end
            o_mem_data_read <= bram[i_mem_addr]; // Synchronous Read
        end
    end
endmodule
