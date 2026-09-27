

class tc_06_read_while_empty #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
  extends tc_base #(DATA_WIDTH, DEPTH);

  function new(generator #(DATA_WIDTH) gen);
    super.new("tc_06_read_while_empty", gen);
  endfunction

  task run();
    $display("T = %0t TC_06 read while empty", $time);
    gen.reset_fifo();
    gen.read();
  endtask
endclass
