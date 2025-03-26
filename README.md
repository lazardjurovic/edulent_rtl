# Implementation of Edulent CPU in SystemVerilog
## Architecture
Edulent is an educational CPU that I used as learning example at university. It has a total of 39 instructions which are divided in few subtypes:
 - data movement
 - arithmetic and logic
 - branching
 - instructions for procedures
 - I/O instructions
 - program flow control instructions

Those instructions are grouped int 2 big sections by how much space in memory they take - one and two byte instructions. In the following table two byte instructions are on the left, and one byte ones on the right.

![](https://i.postimg.cc/N05CBgLq/edulent-isa.png)

Architecture of Edulent is shown on following image. Have in mind that bus in the middle doesn't exist in RTL implementation, rather it is a network of multiplexers and control signals for registers.
![](https://i.postimg.cc/4nCCDYX3/edulent-arch.png)

Since Edulent is based on CISC design principles most of It's functionality is implemented in control unit. Other than that it contains data path on which lay all of registers and ALU's combinational circutry.

## Repo structure
SystemVerilog implementation of Edulent CPU is found in  rtl/

```
    rtl/
    |-- constrainst/
    |   `-- vivado.xdc
    |-- src/
    |   |-- control_unit.sv
    |   |-- data_path.sv
    |   |-- edulent.sv
    |   |-- includes
    |   `-- memory.sv
    |-- tb/
    |   |-- control_alu_tb.sv
    |   |-- control_call_tb.sv
    |   |-- control_jmp_tb.sv
    |   |-- control_mov_tb.sv
    |   `-- top_tb.sv
    |-- Makefile
    |-- build.ys
    `-- ulx3s.lpf
```

## Synthesys
Currently Edulent is synthesizable using Xilinx's Vivado or using Yosys. Having in mind that Vivado is much stricter when it comes to what can be synthesized it is mainly used for code development and after that code is also tested with yosys. Yosys is important because this project is meant to go through OpenLane flow when It is finished and Yosys is one of main tools used there. 
To run synthesis with yosys for ecp5 board You first need to get it from [this github link](https://github.com/YosysHQ/yosys) and nextpnr which can be found [here](https://github.com/YosysHQ/nextpnr) and after that just go to rtl/ and run:

    make yosys
   To run synthesis with Vivado for now You must import source files to a project and run it manually. ( TODO tcl script )
