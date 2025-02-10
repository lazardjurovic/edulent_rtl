`timescale 1ns / 1ps

module control_call_tb;
    
    logic i_clk;
    logic i_rstn;
    logic [7:0] i_opcode;
    
    logic next_instr;
    
    control_unit uut (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_opcode(i_opcode),
        
        .next_instr(next_instr)
    );
    
    // Clock generation
    always #20 i_clk = ~i_clk;
    
    // Opcodes found in the design
    logic [7:0] opcodes[] = '{8'hC1, 8'hB0};
    
    initial begin
        i_clk = 0;
        i_rstn = 0;
        i_opcode = 8'h00;
        #20 i_rstn = 1; // Release reset
        
        foreach (opcodes[i]) begin
            i_opcode = opcodes[i];
            #80; // ADD_A a delay to ensure the next cycle has passed
            wait (next_instr == 1'b1); // Wait for the next_instr to be asserted
        end
        
        $display("Testbench completed");
        $finish;
    end
    
endmodule
