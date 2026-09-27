
class monitor ;
  transaction #(8) t;
  mailbox mbx;
  virtual intf #(8) vif;
  int i;
  function  new(mailbox mbx, virtual intf vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task run();
    
    forever
    begin
      t = new();
      @(posedge vif.clk);
      #1;
      t.rst_n = vif.rst_n;
      t.wr_en = vif.wr_en;
      t.rd_en = vif.rd_en;
      t.din = vif.din;
      t.dout = vif.dout;
      t.full = vif.full;
      t.empty = vif.empty;
      mbx.put(t);
      t.display("[MON]");
    end
  endtask
endclass