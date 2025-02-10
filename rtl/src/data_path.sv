`timescale 1ns / 1ps

module data_path(
    input wire i_clk,
    input wire i_rstn,

    input wire i_alu_calculate,
    input wire [3:0] i_transfer_cmd,
    input wire i_inc_pc,
    input wire [1:0] i_inc_dec_sp,
    input wire next_instr,
    input reg[7:0] i_in,
    output reg[7:0] o_out,
    input wire i_alu_res_to_ap,

    output reg [7:0] o_mem_addr,
    input reg [7:0] i_mem_data_read,
    input reg [7:0] o_mem_data_write
);

    // Registers defined in specs
    reg [7:0] PC, IR, SP, MA, MD, A, AP, R, STATUS, IN, OUT;

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            // Reset all registers to zero
            {PC, IR, SP, MA, MD, OUT, IN, A, AP, R, STATUS, IN, OUT} <= 0;
        end 
        else begin
        /*
       
       0 => nothing
       1 => MA <- PC
       2 => MD <- M[MA]
       3 => IR <- MD
       4 => MA <- MD
       5 => A/AP <- MD
       6 => MA <- AP
       7 => MA <- SP
       8 => MD <- A/AP
       9 => M[MA] <- MD
       A => A/AP <- R
       B => PC <- MD
       C => A <- IN
       D => OUT <- A
       E => PC <- AP
       F => MD <- PC
       
       */
       // Drive register transactions
            case (i_transfer_cmd)
                4'h1: MA <= PC;
                4'h2: MD <= i_mem_data_read;
                4'h3: IR <= MD;
                4'h4: MA <= MD;
                4'h5:
                    begin
                        case (IR)
                            8'h11: A <= MD;
                            8'h13: AP <= MD;
                            8'h19: A <= MD;
                            8'h1B: AP <= MD;
                            8'h14: A <= MD;
                            8'h1C: AP <= MD;
                            8'h1E: AP <= MD; 
                        endcase
                    end
                4'h6: MA <= AP;
                4'h7: MA <= SP;
                4'h8:
                    begin
                        case(IR)
                            8'h21: MD <= A;
                            8'h23: MD <= AP;
                            8'h2C: MD <= A;
                            8'h2E: MD <= AP;
                        endcase
                    end
                4'h9: o_mem_data_write <= MD; 
                4'hA:
                    begin
                        if(i_alu_res_to_ap == 1'b1) begin
                            AP <= R;
                        end else begin
                            A <= R;
                        end
                    end
                4'hB: PC <= MD;
                4'hC: A<= IN;
                4'hD: OUT <= A;
                4'hE: PC <= AP;
                4'hF: MD <= PC;
                
            endcase
        
            // Drive PC
            if (i_inc_pc) 
                PC <= PC + 1;

            // Drive SP
            case (i_inc_dec_sp)
                2'b01: SP <= SP + 1;
                2'b10: SP <= SP - 1;
            endcase
            

            if (i_alu_calculate) begin
                case (IR[7:4])
                    4'h3: R <= A+MD;
                    4'h4: R <= A-MD;
                    4'h5: R <= ~A;
                    4'h6: R <= A | MD;
                    4'h7: R <= A & MD;
                    4'h8: R <= A ^ MD;
                    4'h9: R <= {1'b0,A[7:0]};
                    default: ;
                endcase
            end

        end
    end
    
    assign o_out = OUT;
    assign IN = i_in;
    
endmodule
