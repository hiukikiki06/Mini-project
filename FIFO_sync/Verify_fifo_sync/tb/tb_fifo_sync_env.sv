class enviroment #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8);
  mailbox mbx_gd;
  mailbox mbx_ms;

  generator  #(DATA_WIDTH) gen;
  driver     #(DATA_WIDTH) drv ;
  monitor    mon;
  scoreboard #(DATA_WIDTH) sco;

  virtual intf #(DATA_WIDTH) vif;
  event done_drv;

  function new(virtual intf #(DATA_WIDTH) vif);
    this.vif = vif;
    mbx_gd   = new();
    mbx_ms   = new();

    gen = new(mbx_gd, done_drv);
    drv = new(mbx_gd, vif, done_drv);
    mon = new(mbx_ms, vif);
    sco = new(mbx_ms);
  endfunction

  task run();
    $display("T = %0t [ENV] Environment starting components...", $time);
    fork
      drv.run();
      mon.run();
      sco.test();
    join_none
  endtask
endclass