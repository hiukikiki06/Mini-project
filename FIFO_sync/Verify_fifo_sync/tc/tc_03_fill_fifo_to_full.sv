
class tc_03_fill_fifo_to_full #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);
    rand bit [DATA_WIDTH - 1 : 0] d_in;

    function new(generator #(DATA_WIDTH) gen);
        super.new("tc_03_fill_fifo_to_full", gen);
    endfunction
    task run();
        $display("T = %0t TC_03 Write FIFO to full", $time);
        gen.reset_fifo();
        repeat(DEPTH) begin
            d_in = $urandom();
            gen.write(d_in);
        end
    endtask
endclass
