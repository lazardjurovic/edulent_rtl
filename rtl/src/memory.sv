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
    
    // Initialize BRAM with 0xFF, and set first 10 addresses manually
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            bram[i] = 8'hFF; // Default initialization
        end
        // Logic instructions test
        bram[0]  = 8'h19;
        bram[1]  = 8'h01;
        bram[2]  = 8'h50;
        bram[3]  = 8'h21;
        bram[4]  = 8'h15;
        bram[5]  = 8'h79;
        bram[6]  = 8'h0D;
        bram[7]  = 8'h21;
        bram[8]  = 8'h16;
        bram[9]  = 8'h69;
        bram[10]  = 8'h02;
        bram[11]  = 8'h21;
        bram[12]  = 8'h17;
        bram[13]  = 8'h89;
        bram[14]  = 8'h03;
        bram[15]  = 8'h90;
        bram[16]  = 8'h21;
        bram[17]  = 8'h18;
        bram[18]  = 8'h02;
        bram[19]  = 8'h01;
        bram[20]  = 8'h0A;
        bram[21]  = 8'h00;
        bram[22]  = 8'h00;
        bram[23]  = 8'h00;
        bram[24]  = 8'h00;
        
    end
    
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
