package tc_fifo_sync_pkg;
  import tb_fifo_sync_pkg::*;
  parameter int DATA_WIDTH = 8;
  parameter int DEPTH      = 8;

  `include "tc_base.sv"
  `include "tc_01_reset.sv"
  `include "tc_02_normal_write.sv"
  `include "tc_03_fill_fifo_to_full.sv"
  `include "tc_04_write_while_full.sv"
  `include "tc_05_normal_read.sv"
  `include "tc_06_read_while_empty.sv"
  `include "tc_07_simultaneous_read_and_write.sv"
  `include "tc_08_simutaneous_read_write_while_full.sv"
  `include "tc_09_simultaneous_read_and_write_while_empty.sv"
  `include "tc_10_fifo_ordering_and_wrap_around.sv"

endpackage : tc_fifo_sync_pkg