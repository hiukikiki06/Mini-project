class enviroment #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8);
  mailbox mbx_gd;
  mailbox mbx_ms;
  mailbox mon2cov;
  generator  #(DATA_WIDTH) gen;
  driver     #(DATA_WIDTH) drv ;
  monitor    #(DATA_WIDTH) mon;
  scoreboard #(DATA_WIDTH) sco;
  pkg_coverage #(DATA_WIDTH) cov;
  virtual intf #(DATA_WIDTH) vif;
  event done_drv;

  function new(virtual intf #(DATA_WIDTH) vif);
    this.vif = vif;
    mbx_gd   = new();
    mbx_ms   = new();
    mon2cov  = new();
    gen = new(mbx_gd, done_drv);
    drv = new(mbx_gd, vif, done_drv);
    mon = new(mbx_ms, vif, mon2cov);
    cov = new(mon2cov);
    sco = new(mbx_ms);

  endfunction

  task display_cov();
    $display("T = %0t [COV] FUNTIONAL COVERAGE of ALL = %0.2f%%", $time, cov.cg_ff.get_inst_coverage());
    $display("T = %0t [COV] FUNTIONAL COVERAGE of rst_n = %0.2f%%", $time, cov.cg_ff.cp_rst_n.get_inst_coverage());
    $display("T = %0t [COV] FUNTIONAL COVERAGE of wr_en = %0.2f%%", $time, cov.cg_ff.cp_wr_en.get_inst_coverage());
    $display("T = %0t [COV] FUNTIONAL COVERAGE of rd_en = %0.2f%%", $time, cov.cg_ff.cp_rd_en.get_inst_coverage());
    $display("T = %0t [COV] FUNTIONAL COVERAGE of din = %0.2f%%", $time, cov.cg_ff.cp_din.get_inst_coverage());
  endtask

  task run();
    $display("T = %0t [ENV] Environment starting components...", $time);
    fork
      drv.run();
      mon.run();
      cov.run();
      sco.test();
    join_none
  
  endtask
endclass