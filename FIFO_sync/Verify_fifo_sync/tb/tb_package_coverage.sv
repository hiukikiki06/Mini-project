class pkg_coverage #(parameter DATA_WIDTH = 8);
    mailbox mon2cov;
    transaction #(DATA_WIDTH) t;

    covergroup cg_ff;
        cp_rst_n : coverpoint t.rst_n {
            bins low = {1'b0};
            bins high = {1'b1};
        }
        cp_wr_en : coverpoint t.wr_en {
            bins low = {1'b0};
            bins high = {1'b1};
        }
        cp_rd_en : coverpoint t.rd_en {
            bins low = {1'b0};
            bins high = {1'b1};
        }
        cp_din : coverpoint t.din {
            bins zezo = {8'h00};
            bins normal = {[8'h01 : 8'hFE]};
            bins max = {8'hFF};
        }
    endgroup

    function new(mailbox mon2cov);
        this.mon2cov = mon2cov;
        cg_ff = new();
    endfunction

    task run ();
    $display("T = %0t cov staring ....", $time);
        forever begin
            mon2cov.get(t);
            cg_ff.sample();
        end
    endtask

endclass //pkg_coverage
