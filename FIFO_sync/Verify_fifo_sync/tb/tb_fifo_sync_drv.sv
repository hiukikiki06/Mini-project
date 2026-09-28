
class driver #(parameter int DATA_WIDTH = 8);
  mailbox mbx;
  transaction #(DATA_WIDTH) t;
  event done_drv;
  virtual intf #(DATA_WIDTH) vif;

  function  new(mailbox mbx, virtual intf #(DATA_WIDTH) vif, event done_drv);
    this.mbx = mbx;
    this.vif = vif;
    this.done_drv = done_drv;
  endfunction

  task run();
    forever
    begin
      mbx.get(t);
      @(negedge vif.clk);
      vif.rst_n = t.rst_n;
      vif.wr_en = t.wr_en;
      vif.rd_en = t.rd_en;
      vif.din = t.din;
      t.display("[DRV]");
      @(posedge vif.clk);
      #1;
      -> done_drv;
    end
  endtask

endclass