interface intf #(parameter int DATA_WIDTH = 8) (input clk);
  logic rst_n;
  logic wr_en;
  logic rd_en;
  logic [DATA_WIDTH -1 : 0] din;
  logic [DATA_WIDTH -1 : 0] dout;
  logic full;
  logic empty;
endinterface


