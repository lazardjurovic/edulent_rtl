`ifndef ROM_TABLES_SV
`define ROM_TABLES_SV

logic [0:255]read_operand_rom = { 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0
};

logic [0:255]mov_with_address_rom = { 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b1, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0, 
 1'b0
};

`endif
