SHELL := /bin/sh

RTL_DIR := rtl/single_cycle
TB_DIR := tb/single_cycle

SIM_TOP := tb_basic
SV_SOURCES := $(wildcard $(RTL_DIR)/*.sv) $(TB_DIR)/tb_basic.sv

.PHONY: sim clean

sim:
	vlib work
	vlog -sv $(SV_SOURCES)
	vsim -c work.$(SIM_TOP) -do "run -all; quit"

clean:
	rm -rf work transcript
