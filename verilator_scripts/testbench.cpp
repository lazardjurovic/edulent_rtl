#include "obj_dir/Vcontrol_unit.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include <iostream>

int main() {
    Verilated::traceEverOn(true);
    Vcontrol_unit* dut = new Vcontrol_unit;

    // VCD wave dump setup
    VerilatedFstC* tfp = new VerilatedFstC;
    dut->trace(tfp, 99);
    tfp->open("dump.vcd");

    // Simulation loop in nanoseconds
    unsigned long cycle_count = 2000; // Run for 2000 ns
    
    for (int ns = 0; ns < cycle_count; ns++) {
        dut->i_clk = 0;
        dut->eval();
        tfp->dump(ns * 2); // Dump at 0 ps and 500 ps

        dut->i_clk = 1;
        dut->eval();
        tfp->dump(ns * 2 + 1); // Dump at 1000 ps (1 ns)
    }

    tfp->close();
    delete dut;
    return 0;
}
