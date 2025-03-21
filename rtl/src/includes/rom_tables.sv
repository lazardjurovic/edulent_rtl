`ifndef ROM_TABLES_SV
`define ROM_TABLES_SV

module rom_tables(
    output logic [255:0] read_operand_rom,  // Define as output
    output logic [255:0] mov_with_address_rom // Define as output
);

    // ROM array for read_operand lookup (256 entries)
    genvar i;
    generate
        // Initialize all entries to 0
        for (i = 0; i < 256; i = i + 1) begin : read_operand_gen
            assign read_operand_rom[i] = 1'b0;  // Default is 0
        end

        // Set the specified opcodes to 1
        for (i = 0; i < 256; i = i + 1) begin : read_operand_set
            if (i == 8'h11 || i == 8'h13 || i == 8'h19 || i == 8'h1B || i == 8'h21 || 
                i == 8'h23 || i == 8'h31 || i == 8'h41 || i == 8'h39 || i == 8'h49 ||
                i == 8'h3B || i == 8'h4B || i == 8'h61 || i == 8'h71 || i == 8'h81 ||
                i == 8'h69 || i == 8'h79 || i == 8'h89 || i == 8'hA1 || i == 8'hA5 ||
                i == 8'hA9 || i == 8'hC1) begin
                assign read_operand_rom[i] = 1'b1;  // Set specified opcodes to 1
            end
        end
    endgenerate

    // Generate the ROM for mov_with_address
    generate
        // Initialize all entries to 0
        for (i = 0; i < 256; i = i + 1) begin : mov_with_address_gen
            assign mov_with_address_rom[i] = 1'b0;  // Default is 0
        end

        // Set the specified opcodes to 1
        for (i = 0; i < 256; i = i + 1) begin : mov_with_address_set
            if (i == 8'h11 || i == 8'h13 || i == 8'h21 || i == 8'h23 || i == 8'h31 ||
                i == 8'h41 || i == 8'h61 || i == 8'h71 || i == 8'h81) begin
                assign mov_with_address_rom[i] = 1'b1;  // Set specified opcodes to 1
            end
        end
    endgenerate

endmodule

`endif