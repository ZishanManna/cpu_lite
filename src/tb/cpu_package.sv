`include "uvm_macros.svh"
import uvm_pkg::*;
parameter ADD_WIDTH = 4;

`include "cpu_interface.sv"
`include "cpu_sequence_item.sv"
`include "cpu_sequence.sv"
`include "cpu_sequencer.sv"
`include "cpu_driver.sv"
`include "cpu_active_monitor.sv"
`include "cpu_active_agent.sv"
`include "cpu_passive_monitor.sv"
`include "cpu_passive_agent.sv"
`include "cpu_scoreboard.sv"
`include "cpu_environment.sv"
`include "cpu_test.sv"
