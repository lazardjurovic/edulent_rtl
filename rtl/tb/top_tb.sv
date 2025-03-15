`timescale 1ns / 1ps

module top_tb;

    reg i_rstn;
    logic i_clk;
    logic[7:0] i_in;
    logic[7:0] o_out;

    // Instantiate the DUT (Device Under Test)
    edulent uut (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_in(i_in),
        .o_out(o_out)
    );

    // Clock generation (10 ns period -> 100 MHz)
    always #5 i_clk = ~i_clk;
    
    initial begin
        $monitor("Time: %0t | i_rstn: %b", $time, i_rstn);
    end


    initial begin
        i_rstn = 0; // Force reset low initially
        i_clk = 0;
        i_in = 8'h00;
    
        // Hold reset for a few cycles
        #20;
        i_rstn = 1; // Deassert reset after 20 ns
    end

endmodule
