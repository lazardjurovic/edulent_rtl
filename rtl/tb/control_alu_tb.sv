`timescale 1ns / 1ps

module control_alu_tb;
    
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
    logic [7:0] opcodes[] = {8'h31, 8'h41, 8'h39, 8'h49, 8'h3B, 8'h4B,8'h34, 8'h44,
    8'h50, 8'h90, 8'h61, 8'h71, 8'h81, 8'h69, 8'h79, 8'h89, 8'h64, 8'h74, 8'h84};
    
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
