
class tc_01_reset #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
  extends tc_base #(DATA_WIDTH, DEPTH);

  function new(generator #(DATA_WIDTH) gen);
    super.new("tc_01_reset", gen);
  endfunction


  task run();
    $display("T = %0t TC_01 reset", $time);
    gen.reset_fifo();
    gen.write(8'hA5);

    // reset fifo again
    gen.reset_fifo();
    gen.read();
  endtask
endclass
