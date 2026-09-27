
class tc_08_simutaneous_read_write_while_full #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);
  rand bit [DATA_WIDTH - 1 : 0] d_in;

  function new(generator #(DATA_WIDTH) gen);
    super.new("tc_08_simultaneous _read_and_write while full", gen);
  endfunction

  task run();
    $display("T = %0t TC_08 simutaneous read write while full", $time);
    gen.reset_fifo();
    repeat(DEPTH)
    begin
      d_in = $urandom();
      gen.write(d_in);
    end
    gen.read_write(8'hA5);
  endtask
endclass
