# Variables
VERILATOR = verilator
VTOP = control_unit          # Top-level Verilog module
SRC_FILES = tb/control_mov_tb.sv src/control_unit.sv
VCD_FILE = dump.vcd
EXE_FILE = sim.out

# Default target (compile, run, and view waveform)
all: build run view

# Compile Verilog into a C++ executable
build: $(SRC_FILES)
	$(VERILATOR) --cc --exe --build --trace --trace-fst --top-module $(VTOP) $(SRC_FILES) testbench.cpp -o $(EXE_FILE)

# Run the simulation
run: build
	./obj_dir/$(EXE_FILE)

# Open the waveform in GTKWave automatically
view: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

# Clean generated files
clean:
	rm -rf obj_dir $(EXE_FILE) $(VCD_FILE) verilator_bin verilator_cpp verilated.o
