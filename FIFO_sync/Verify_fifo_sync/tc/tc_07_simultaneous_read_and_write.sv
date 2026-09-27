
class tc_07_simultaneous_read_and_write #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);
  rand bit [DATA_WIDTH - 1 : 0] d_in;
  function new(generator #(DATA_WIDTH) gen);
    super.new("tc_07_simultaneous _read_and_write",gen);
  endfunction

  task run();
    $display("T = %0t TC_07 Simultaneous Read and Write", $time);
    gen.reset_fifo();
    gen.write(8'hA7);
    gen.read_write(8'hA2);
  endtask
endclass
