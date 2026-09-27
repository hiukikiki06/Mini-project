
class tc_05_normal_read #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
  extends tc_base #(DATA_WIDTH, DEPTH);
  rand bit [DATA_WIDTH - 1 : 0] d_in;

  function new(generator #(DATA_WIDTH) gen);
    super.new("tc_05_normal_read", gen);
  endfunction

  task run();
    $display("T = %0t TC_05 normal read", $time);
    gen.reset_fifo();
    repeat(DEPTH)
    begin
      d_in = $urandom();
      gen.write(d_in);
    end
    repeat(DEPTH - 2)
    begin
      gen.read();
    end
  endtask
endclass
