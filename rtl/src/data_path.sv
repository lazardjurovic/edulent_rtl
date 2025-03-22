`timescale 1ns / 1ps

localparam SP_INIT = 8'h7F;
localparam ZERO_VAL = 8'h00;
localparam MAX_VAL = 8'hFF;

module data_path(
    // Input Signals
    input wire i_clk,
    input wire i_rstn,
    input wire i_alu_calculate,
    input wire [3:0] i_transfer_cmd,
    input wire i_inc_pc,
    input wire [1:0] i_inc_dec_sp,
    input reg [7:0] i_in,
    input wire i_alu_res_to_ap,
    input wire i_reset_ir,
    input reg [7:0] i_mem_data_read,

    // Output Signals
    output reg [7:0] o_out,
    output wire [7:0] o_IR,
    output reg o_mem_write_enable,
    output reg [7:0] o_mem_addr,
    output reg [7:0] o_mem_data_write
);


    // Registers defined in specs
    reg [7:0] PC, IR, MA, MD, A, AP, R, IN, OUT, SP;
    reg [1:0] CZ; // carry and zero flag
    wire [7:0] alu_res;

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            // Reset all registers to zero
            {PC, IR, MA, MD, OUT, IN, A, AP, R, CZ, IN, OUT} <= ZERO_VAL;
            SP <= SP_INIT;
        end 
        else begin
        
        o_mem_data_write <= 0;
        o_mem_write_enable <= 1'b0;
        
        IN <= i_in;
        
       // Drive register transactions
        unique case (i_transfer_cmd)
                4'h1: MA <= PC;
                4'h2: MD <= i_mem_data_read;
                4'h3: IR <= MD;
                4'h4: MA <= MD;
                4'h5:
                    begin
                        case (IR)
                            8'h11, 8'h19, 8'h14: A <= MD;
                            8'h13, 8'h1B, 8'hC1, 8'h1E: AP <= MD;
                        endcase
                    end
                4'h6: MA <= AP;
                4'h7: MA <= SP;
                4'h8:
                    begin
                        case(IR)
                            8'h21, 8'h2C: MD <= A;
                            8'h23, 8'h2E: MD <= AP;
                        endcase
                    end
                4'h9:
                    begin
                        o_mem_write_enable <= 1'b1;
                        o_mem_data_write <= MD; 
                    end 
                4'hA:
                    begin
                        if(i_alu_res_to_ap == 1'b1) begin
                            AP <= R;
                        end else begin
                            A <= R;
                        end
                    end
                4'hB:
                    begin
                        case(IR) 
                            8'hA1: PC <= MD;
                            8'hB0: PC <= MD;
                            8'hA5: if(CZ[0] == 1'b1) PC <= MD;
                            8'hA9: if(CZ[1] == 1'b1) PC <= MD;
                        endcase
                    end
                4'hC: A<= IN;
                4'hD: OUT <= A;
                4'hE: PC <= AP;
                4'hF: MD <= PC;
                
            endcase
            
            if(i_reset_ir == 1'b1) begin
                IR <= 0;
            end
        
            // Drive PC
            if (i_inc_pc) 
                PC <= PC + 1;

            // Drive SP
            case (i_inc_dec_sp)
                2'b01: SP <= SP + 1;
                2'b10: SP <= SP - 1;
            endcase

            if (i_alu_calculate) begin
                R <= alu_res;
               // Carry and zero flag
               CZ[0] <= (alu_res == ZERO_VAL);
               CZ[1] <= (alu_res > 255);
           end

        end
    end
    
    assign o_out = OUT;
    assign o_mem_addr = MA;
    assign o_IR = IR;
    
    // ALU combinational logic
    assign alu_res = (IR[7:4] == 4'h3) ? (i_alu_res_to_ap ? (AP + MD) : (A + MD)) :
                     (IR[7:4] == 4'h4) ? (i_alu_res_to_ap ? (AP - MD) : (A - MD)) :  
                     (IR[7:4] == 4'h5) ? (~A) :
                     (IR[7:4] == 4'h6) ? (A | MD) :
                     (IR[7:4] == 4'h7) ? (A & MD) :
                     (IR[7:4] == 4'h8) ? (A ^ MD) :
                     (IR[7:4] == 4'h9) ? {1'b0, A[7:1]} :
                     MAX_VAL;


endmodule
