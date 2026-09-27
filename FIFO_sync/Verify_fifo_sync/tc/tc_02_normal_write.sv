class tc_02_normal_write #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8)
extends tc_base #(DATA_WIDTH, DEPTH);


    function new(generator #(DATA_WIDTH) gen);
        super.new("tc_02_normal_write", gen);
    endfunction

    task run();
        $display("T = %0t TC_02 normal write", $time);
        gen.reset_fifo();
        gen.write(8'hA5);
        gen.write(8'hB5);
    endtask
endclass