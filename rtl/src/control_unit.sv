`timescale 1ns / 1ps

module control_unit(

    input wire i_clk,
    input wire i_rstn,
    input wire[7:0] i_opcode,
    
//    output reg o_ma_in,
//    output reg o_ma_out,
//    output reg o_pc_out,
//    output reg o_pc_in,
//    output reg o_pc_increment,
//    output reg o_md_in,
//    output reg o_md_out,
//    output reg o_ir_in,
    
    output reg next_instr
    
    );
    
    /* 
    TODO: optimize number of sttate by just making one alu state and from it output ALU code
    */
    
    typedef enum logic[4:0] {
        RESET,
        MA_PC, READ_MEMORY_INC_PC, IR_MD, MA_PC_OPERAND, READ_OPERAND, MA_MD, READ_MEMORY,A_MD,AP_MD,
        MA_AP, MA_SP, READ_MEMORY_INC_SP, MD_A, LOAD_DATA, MD_AP, DECREMENT_SP,
        ADD_A, SUB_A, A_R, ADD_AP, SUB_AP, AP_R, NOT_A, SHR, OR_A, AND_A, XOR_A
    } state_t;
       
    state_t curr_state, next_state;
    
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn)
            curr_state <= RESET;  // Reset to IDLE state
        else
            curr_state <= next_state;
    end
    
    
    wire read_operand = 
        (i_opcode == 8'h11) | (i_opcode == 8'h13) | (i_opcode == 8'h19) |
        (i_opcode == 8'h1B) | (i_opcode == 8'h21) | (i_opcode == 8'h23) | 
        (i_opcode == 8'h31) | (i_opcode == 8'h41) | (i_opcode == 8'h39) | 
        (i_opcode == 8'h49) | (i_opcode == 8'h3B) | (i_opcode == 8'h4B) |
        (i_opcode == 8'h61) | (i_opcode == 8'h71) | (i_opcode == 8'h81) |
        (i_opcode == 8'h69) | (i_opcode == 8'h79) | (i_opcode == 8'h89); 
    
    wire mov_with_address = 
        (i_opcode == 8'h11) | (i_opcode == 8'h13) | (i_opcode == 8'h21) | (i_opcode == 8'h23) |
        (i_opcode == 8'h31) | (i_opcode == 8'h41) | (i_opcode == 8'h61) | (i_opcode == 8'h71) | 
        (i_opcode == 8'h81);
    
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
                                8'h50: next_state <= NOT_A;
                                8'h90: next_state <= SHR;
                                8'h64: next_state <= MA_AP;
                                8'h74: next_state <= MA_AP;
                                8'h84: next_state <= MA_AP;
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
                                8'h39: next_state <= ADD_A;
                                8'h49: next_state <= SUB_A;
                                8'h3B: next_state <= ADD_AP;
                                8'h4B: next_state <= SUB_AP;
                                8'h34: next_state <= MA_AP;
                                8'h44: next_state <= MA_AP;
                                8'h69: next_state <= OR_A;
                                8'h79: next_state <= AND_A;
                                8'h89: next_state <= XOR_A;
                                default: ;
                            endcase
                        end
                end
             MA_MD: 
                begin
                    case (i_opcode)
                        8'h21: next_state <= MD_A;
                        8'h23: next_state <= MD_AP;
                        8'h31: next_state <= LOAD_DATA;
                        8'h41: next_state <= LOAD_DATA;
                        8'h61: next_state <= LOAD_DATA;
                        8'h71: next_state <= LOAD_DATA;
                        8'h81: next_state <= LOAD_DATA;
                        default: next_state <= READ_MEMORY;
                    endcase
                end
             READ_MEMORY: 
                begin
                    case(i_opcode)
                        8'h11: next_state <= A_MD;
                        8'h13: next_state <= AP_MD;
                        8'h14: next_state <= A_MD;
                        8'h34: next_state <= ADD_A;
                        8'h44: next_state <= SUB_A;
                        8'h64: next_state <= OR_A;
                        8'h74: next_state <= AND_A;
                        8'h84: next_state <= XOR_A;
                        default: ;
                    endcase
                end
            A_MD: next_state <= MA_PC;
            AP_MD: next_state <= MA_PC;
            MA_AP: next_state <= READ_MEMORY;
            MA_SP:
                begin
                    case (i_opcode)
                        8'h1C: next_state <= READ_MEMORY_INC_SP;
                        8'h1E: next_state <= READ_MEMORY_INC_SP;
                        8'h2C: next_state <= MD_A;
                        8'h2E: next_state <= MD_AP;
                        default: ;
                    endcase
                end
            READ_MEMORY_INC_SP: 
                begin
                     case( i_opcode)
                        8'h1C: next_state <= A_MD;
                        8'h1E: next_state <= AP_MD;
                        default: ;
                     endcase
                end
            MD_A: next_state <= LOAD_DATA;
            MD_AP: next_state <= LOAD_DATA;
            LOAD_DATA: 
                begin
                    case (i_opcode)
                        8'h31: next_state <= ADD_A;
                        8'h41: next_state <= SUB_A;
                        8'h61: next_state <= OR_A;
                        8'h71: next_state <= AND_A;
                        8'h81: next_state <= XOR_A;
                        default: next_state <= MA_PC;
                    endcase
                end
            DECREMENT_SP: next_state <= MA_SP;
            ADD_A: next_state <= A_R;
            SUB_A: next_state <= A_R;
            A_R: next_state <= MA_PC;
            ADD_AP: next_state <= AP_R;
            SUB_AP: next_state <= AP_R;
            AP_R: next_state <= MA_PC;
            NOT_A: next_state <= A_R;
            SHR: next_state <= A_R;
            OR_A: next_state <= A_R;
            AND_A: next_state <= A_R;
            XOR_A: next_state <= A_R;
        endcase
    
    
    
    end
    
    //combinational output generation for data path
    
    assign next_instr = | (curr_state == A_MD) | (curr_state == AP_MD) |
    (curr_state == A_R) | (curr_state == AP_R) ;
    
endmodule
