`timescale 1ns / 1ps

module control_unit(

    input wire i_clk,
    input wire i_rstn,
    input wire[7:0] i_opcode,

    output reg o_alu_calculate,
    output reg[3:0] o_transfer_cmd,
    output reg o_inc_pc,
    output reg[1:0] o_inc_dec_sp,
    output wire next_instr
    /*
       
       o_transfer_cmd for different commands
       
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
    
    );
    
    typedef enum logic[4:0] {
        RESET,
        MA_PC, READ_MEMORY_INC_PC, IR_MD, MA_PC_OPERAND, READ_OPERAND, MA_MD, READ_MEMORY,A_MD,AP_MD,
        MA_AP, MA_SP, READ_MEMORY_INC_SP, MD_A, STORE_DATA, MD_AP, DECREMENT_SP,
        A_R, AP_R, JMP_MOV, ALU, A_IN, OUT_A, MD_PC, PC_AP
    } state_t;
       
    state_t curr_state, next_state;
    
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn)
            curr_state <= RESET;  // Reset to IDLE state
        else
            curr_state <= next_state;
    end

    wire read_operand = |({
        (i_opcode == 8'h11),
        (i_opcode == 8'h13),
        (i_opcode == 8'h19),
        (i_opcode == 8'h1B),
        (i_opcode == 8'h21),
        (i_opcode == 8'h23),
        (i_opcode == 8'h31),
        (i_opcode == 8'h41),
        (i_opcode == 8'h39),
        (i_opcode == 8'h49),
        (i_opcode == 8'h3B),
        (i_opcode == 8'h4B),
        (i_opcode == 8'h61),
        (i_opcode == 8'h71),
        (i_opcode == 8'h81),
        (i_opcode == 8'h69),
        (i_opcode == 8'h79),
        (i_opcode == 8'h89),
        (i_opcode == 8'hA1),
        (i_opcode == 8'hA5),
        (i_opcode == 8'hA9),
        (i_opcode == 8'hC1)
    });

    wire mov_with_address = |({
    (i_opcode == 8'h11),
    (i_opcode == 8'h13),
    (i_opcode == 8'h21),
    (i_opcode == 8'h23),
    (i_opcode == 8'h31),
    (i_opcode == 8'h41),
    (i_opcode == 8'h61),
    (i_opcode == 8'h71),
    (i_opcode == 8'h81),
    (i_opcode == 8'hA1),
    (i_opcode == 8'hA5),
    (i_opcode == 8'hA9)
});
    
    wire alu_res_to_ap = (i_opcode == 8'h3B) | (i_opcode == 8'h4B);
    
    // next state generation logic
    always_comb begin
        next_state <= RESET;
        case(curr_state)
        
            RESET: next_state <= MA_PC;
            MA_PC: next_state <= READ_MEMORY_INC_PC;
            READ_MEMORY_INC_PC: next_state <= IR_MD;
            IR_MD: // decide if it is instrucion that continues to MA_PC or something else
                begin
                    if(read_operand == 1'b1) 
                        next_state <= MA_PC_OPERAND;
                     else
                        begin
                            case( i_opcode)
                                8'h14: next_state <= MA_AP;
                                8'h1C: next_state <= MA_SP;
                                8'h1E: next_state <= MA_SP;
                                8'h2C: next_state <= DECREMENT_SP;
                                8'h2E: next_state <= DECREMENT_SP;
                                8'h34: next_state <= MA_AP;
                                8'h44: next_state <= MA_AP;
                                8'h50: next_state <= ALU;
                                8'h90: next_state <= ALU;
                                8'h64: next_state <= MA_AP;
                                8'h74: next_state <= MA_AP;
                                8'h84: next_state <= MA_AP;
                                8'hD0: next_state <= A_IN;
                                8'hE0: next_state <= OUT_A;
                                8'hB0: next_state <= MA_SP;
                                8'hC1: ; //CALL impelmentation
                                default: ;                                
                            endcase                 
                        end
                 end
             MA_PC_OPERAND: next_state <= READ_OPERAND;
             READ_OPERAND:
                begin
                    if(mov_with_address == 1'b1) begin
                        
                        next_state <= MA_MD;
                    end else 
                        begin    
                            case (i_opcode)
                                8'h19: next_state <= A_MD;
                                8'h1b: next_state <= AP_MD;
                                8'h39: next_state <= ALU;
                                8'h49: next_state <= ALU;
                                8'h3B: next_state <= ALU;
                                8'h4B: next_state <= ALU;
                                8'h34: next_state <= MA_AP;
                                8'h44: next_state <= MA_AP;
                                8'h69: next_state <= ALU;
                                8'h79: next_state <= ALU;
                                8'h89: next_state <= ALU;
                                8'hC1: next_state <= AP_MD;
                                default: ;
                            endcase
                        end
                end
             MA_MD: 
                begin
                    case (i_opcode)
                        8'h21: next_state <= MD_A;
                        8'h23: next_state <= MD_AP;
                        8'h31: next_state <= STORE_DATA;
                        8'h41: next_state <= STORE_DATA;
                        8'h61: next_state <= STORE_DATA;
                        8'h71: next_state <= STORE_DATA;
                        8'h81: next_state <= STORE_DATA;
                        default: next_state <= READ_MEMORY;
                    endcase
                end
             READ_MEMORY: 
                begin
                    case(i_opcode)
                        8'h11: next_state <= A_MD;
                        8'h13: next_state <= AP_MD;
                        8'h14: next_state <= A_MD;
                        8'h34: next_state <= ALU;
                        8'h44: next_state <= ALU;
                        8'h64: next_state <= ALU;
                        8'h74: next_state <= ALU;
                        8'h84: next_state <= ALU;
                        8'hA1: next_state <= JMP_MOV;
                        8'hA5: next_state <= JMP_MOV;
                        8'hA9: next_state <= JMP_MOV;
                        default: ;
                    endcase
                end
            A_MD: next_state <= MA_PC;
            AP_MD:
                begin
                    if(i_opcode == 8'hC1) begin
                        next_state <= MA_SP;
                    end else begin
                        next_state <= MA_PC;
                    end
                end
            MA_AP: next_state <= READ_MEMORY;
            MA_SP:
                begin
                    case (i_opcode)
                        8'h1C: next_state <= READ_MEMORY_INC_SP;
                        8'h1E: next_state <= READ_MEMORY_INC_SP;
                        8'h2C: next_state <= MD_A;
                        8'h2E: next_state <= MD_AP;
                        8'hC1: next_state <= MD_PC;
                        8'hB0: next_state <= READ_MEMORY_INC_SP;
                        default: ;
                    endcase
                end
            READ_MEMORY_INC_SP: 
                begin
                     case( i_opcode)
                        8'h1C: next_state <= A_MD;
                        8'h1E: next_state <= AP_MD;
                        8'hB0: next_state <= JMP_MOV;
                        default: ;
                     endcase
                end
            MD_A: next_state <= STORE_DATA;
            MD_AP: next_state <= STORE_DATA;
            STORE_DATA: 
                begin
                    case (i_opcode)
                        8'h31: next_state <= ALU;
                        8'h41: next_state <= ALU;
                        8'h61: next_state <= ALU;
                        8'h71: next_state <= ALU;
                        8'h81: next_state <= ALU;
                        8'hC1: next_state <= PC_AP;
                        default: next_state <= MA_PC;
                    endcase
                end
            DECREMENT_SP: next_state <= MA_SP;
            A_R: next_state <= MA_PC;
            AP_R: next_state <= MA_PC;
            ALU:
                begin
                    
                    if( alu_res_to_ap == 1'b1) begin
                        next_state <= AP_R;
                    end else begin // result goes to A
                        next_state <= A_R;
                    end
                    
                end
            
            JMP_MOV: next_state <= MA_PC;
            A_IN: next_state <= MA_PC;
            OUT_A: next_state <= MA_PC;
            MD_PC: next_state <= STORE_DATA;
            PC_AP : next_state <= MA_PC;
        endcase
    
    end
    
    //combinational output generation for data 
    
    always_comb begin
    
        o_alu_calculate <= 1'b1;
        o_transfer_cmd <= 4'h0;
        o_inc_pc <= 1'b0;
        o_inc_dec_sp <= 2'b00;
    
        case(curr_state)
               ALU: o_alu_calculate <= 1'b1; 
               MA_PC: o_transfer_cmd <= 4'h1;
               READ_MEMORY_INC_PC:
                    begin
                        o_transfer_cmd <= 4'h1;
                        o_inc_pc <= 1'b1;
                     end
               IR_MD: o_transfer_cmd <= 4'h3;
               MA_PC_OPERAND: o_transfer_cmd <= 4'h1;
               READ_OPERAND:
                    begin
                        o_transfer_cmd <= 4'h2;
                        o_inc_pc <= 1'b1;
                    end
               MA_MD: o_transfer_cmd <= 4'h4;
               READ_MEMORY: o_transfer_cmd <= 4'h2;
               A_MD: o_transfer_cmd <= 4'h5;
               AP_MD: o_transfer_cmd <= 4'h5;
               MA_AP: o_transfer_cmd <= 4'h6;
               MA_SP: o_transfer_cmd <= 4'h7;
               READ_MEMORY_INC_SP:
                    begin
                        o_transfer_cmd <= 4'h2;
                        o_inc_dec_sp <= 1'b01;
                    end
                MD_A: o_transfer_cmd <= 4'h8;
                STORE_DATA: ; // todo: decode what it is
                MD_AP: o_transfer_cmd <= 4'h8;
                DECREMENT_SP: o_inc_dec_sp <= 1'b10;
                A_R: o_transfer_cmd <= 4'h5;
                AP_R: o_transfer_cmd <= 4'h5;
                JMP_MOV: o_transfer_cmd <= 4'hB;
                A_IN: o_transfer_cmd <= 4'hC;
                OUT_A: o_transfer_cmd <= 4'hD;
                MD_PC: o_transfer_cmd <= 4'hF;
                PC_AP: o_transfer_cmd <= 4'hE;
            default: ;
        
        endcase
    
    end
    
    assign next_instr = (curr_state == JMP_MOV) | (curr_state == PC_AP);
    
    
endmodule
