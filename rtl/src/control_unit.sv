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
    
    typedef enum {
        RESET,
        MA_PC, READ_MEMORY_INC_PC, IR_MD, MA_PC_OPERAND, READ_OPERAND, MA_MD, READ_MEMORY,A_MD,AP_MD,
        MA_AP, MA_SP, READ_MEMORY_INC_SP, MD_A, LOAD_DATA, MD_AP, DECREMENT_SP
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
        (i_opcode == 8'h1B) | (i_opcode == 8'h21) | (i_opcode == 8'h23);
    
    wire mov_with_address = (i_opcode == 8'h11) | (i_opcode == 8'h13) | (i_opcode == 8'h21) | (i_opcode == 8'h23) ;
    
    // next state generation logic
    always_comb begin
        case(curr_state)
            RESET: next_state = MA_PC;
            MA_PC: next_state = READ_MEMORY_INC_PC;
            READ_MEMORY_INC_PC: next_state = IR_MD;
            IR_MD: begin
                if (read_operand == 1'b1) 
                    next_state = MA_PC_OPERAND;
                else begin
                    case(i_opcode)
                        8'h14: next_state = MA_AP;
                        8'h1C: next_state = MA_SP;
                        8'h1E: next_state = MA_SP;
                        8'h2C: next_state = DECREMENT_SP;
                        8'h2E: next_state = DECREMENT_SP;
                        default: ;
                    endcase                 
                end
            end
            MA_PC_OPERAND: next_state = READ_OPERAND;
            READ_OPERAND: begin
                if (mov_with_address == 1'b1) 
                    next_state = MA_MD;
                else begin
                    if (i_opcode == 8'h19) 
                        next_state = A_MD;
                    else if (i_opcode == 8'h1b) 
                        next_state = AP_MD;
                end
            end
            MA_MD: begin
                case(i_opcode)
                    8'h21: next_state = MD_A;
                    8'h23: next_state = MD_AP;
                    default: next_state = READ_MEMORY;
                endcase
            end
            READ_MEMORY: begin
                case(i_opcode)
                    8'h11: next_state = A_MD;
                    8'h13: next_state = AP_MD;
                    8'h14: next_state = A_MD;
                    default: ;
                endcase
            end
            A_MD: next_state = MA_PC;
            AP_MD: next_state = MA_PC;
            MA_AP: next_state = READ_MEMORY;
            MA_SP: begin
                case(i_opcode)
                    8'h1C: next_state = READ_MEMORY_INC_SP;
                    8'h1E: next_state = READ_MEMORY_INC_SP;
                    8'h2C: next_state = MD_A;
                    8'h2E: next_state = MD_AP;
                    default: ;
                endcase
            end
            READ_MEMORY_INC_SP: begin
                case(i_opcode)
                    8'h1C: next_state = A_MD;
                    8'h1E: next_state = AP_MD;
                    default: ;
                endcase
            end
            MD_A: next_state = LOAD_DATA;
            MD_AP: next_state = LOAD_DATA;
            LOAD_DATA: next_state = MA_PC;
            DECREMENT_SP: next_state = MA_SP;
        endcase
    end

    
    //combinational output generation for data path
    
    assign next_instr = (curr_state == LOAD_DATA) | (curr_state == A_MD) | (curr_state == AP_MD);
    
endmodule
