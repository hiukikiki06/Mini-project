
class tc_10_fifo_ordering_and_wrap_around #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);
  rand bit [DATA_WIDTH - 1 : 0] d_in;

  function new(generator #(DATA_WIDTH) gen);
    super.new("TC_10 fifo ordering and wrap around", gen);
  endfunction

  task run();
    $display("\n==================================================");
    $display("  [TESTCASE 10] FIFO Ordering & Pointer Wrap-Around ");
    $display("==================================================");
    gen.reset_fifo();

    // Round 1: Fill and drain
    $display("--- [TC_10] Round 1: Fill and Drain ---");
    repeat (DEPTH)
    begin
      d_in = $urandom();
      gen.write(d_in);
    end
    repeat (DEPTH)
    begin
      gen.read();
    end
    
    // ENTER for easy look 
    repeat(8) $display(""); 
    // Round 2: Fill and drain to wrap pointers around FIFO depth boundary
    $display("--- [TC_10] Round 2: Pointer Wrap-around ---");
    repeat (DEPTH)
    begin
      d_in = $urandom();
      gen.write(d_in);
    end
    repeat (DEPTH)
    begin
      gen.read();
    end

    // ENTER for easy look 
    repeat(8) $display(""); 
    // Round 3: Alternating writes and reads across boundary
    $display("--- [TC_10] Round 3: Alternating Write & Read ---");
    repeat (DEPTH * 2)
    begin
      d_in = $urandom();
      gen.write(d_in);
      gen.read();
      // gen.read_write(d_in);
    end
  endtask
endclass
