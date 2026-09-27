
class transaction #(parameter int DATA_WIDTH = 8);
  bit rst_n;
  bit wr_en;
  bit rd_en;
  bit [DATA_WIDTH -1 : 0] din;
  bit [DATA_WIDTH -1 : 0] dout;
  bit full;
  bit empty;

  function void display(string tag);
    $display("T = %0t %s rst_n = %0b, wr_en = %0b, rd_en = %0b, din = %b, dout = %b, full = %0b, empty = %0b", $time, tag, rst_n, wr_en, rd_en, din, dout, full, empty);
  endfunction
endclass