
class generator #(parameter int DATA_WIDTH = 8);
  mailbox mbx;
  transaction #(DATA_WIDTH) t;
  event done_drv;

  function new(mailbox mbx, event done_drv);
    this.mbx = mbx;
    this.done_drv = done_drv;
  endfunction

  task send(bit rst_n, bit wr_en, bit rd_en, bit [DATA_WIDTH - 1 : 0] din);
    t = new();
    t.rst_n = rst_n;
    t.wr_en = wr_en;
    t.rd_en = rd_en;
    t.din   = din;
    mbx.put(t);
    t.display("[GEN]");
    @(done_drv);
    #1;
  endtask

  task reset_fifo();
    send(0, 0, 0, 0);
  endtask

  task write(bit [DATA_WIDTH - 1 : 0] din);
    send(1, 1, 0, din);
  endtask

  task read();
    send(1, 0, 1, 0);
  endtask

  task read_write(bit [DATA_WIDTH - 1 : 0] din);
    send(1, 1, 1, din);
  endtask
endclass