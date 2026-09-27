
class tc_09_simultaneous_read_and_write_while_empty #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);

  function new(generator #(DATA_WIDTH) gen);
    super.new("TC_09 Simultaneous Read and Write While empty", gen);
  endfunction

  task run();
    $display("T = %0t TC_09 Simultaneous Read and Write While empty", $time);
    gen.reset_fifo();
    gen.read_write(8'hB6);
  endtask
endclass
