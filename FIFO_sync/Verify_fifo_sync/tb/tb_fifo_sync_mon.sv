
class monitor #(parameter DATA_WIDTH = 8) ;
  transaction #(DATA_WIDTH) t;
  mailbox mbx;
  mailbox mon2cov;
  virtual intf #(DATA_WIDTH) vif;

  function new(mailbox mbx, virtual intf #(DATA_WIDTH) vif, mailbox mon2cov );
    this.mbx = mbx;
    this.vif = vif;
    this.mon2cov = mon2cov;
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
      mon2cov.put(t);
      t.display("[MON]");
    end
  endtask
endclass