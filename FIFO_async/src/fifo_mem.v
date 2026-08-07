module fifo_mem #(
    parameter ADD = 4,// 2^4 = 16 
    parameter WIDTH = 8 // do rong bit
)
(
    // mien ghi
    input w_clk,
    input w_full,
    input w_en,
    input [ADD - 1 : 0 ] w_addr,
    input [WIDTH - 1 : 0] data_in,
    // mien doc
    input r_clk,
    input r_empty,
    input r_en,
    input [ADD -1 : 0 ] r_addr,
    output [WIDTH - 1 : 0] data_out 
);
    localparam DEPTH = 1 << ADD;
    reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1];
    assign data_out = mem [ r_addr];
    always @ ( posedge w_clk) begin
        if ( w_en & !w_full) begin
            mem [w_addr] <= data_in;
        end
    end
endmodule