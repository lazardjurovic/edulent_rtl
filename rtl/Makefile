
yosys: src/edulent.sv
	yosys build.ys
	nextpnr-ecp5 --12k --package CABGA381 --json hardware.json --textcfg hardware.config --lpf ulx3s.lpf --lpf-allow-unconstrained
	ecppack --compress hardware.config hardware.bit
#openFPGALoader --board ulx3s hardware.bit

#xilinx: src/edulent.sv


.PHONY: clean
clean:
	rm -rf *hardware*