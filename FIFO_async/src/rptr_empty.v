module rptr_empty #(
    parameter ADD = 4
)(
    input r_clk,
    input rst_n,
    input r_en,
    input [ADD:0] w_ptr_sync,

    output [ADD-1:0] r_addr,
    output reg r_empty,
    output reg [ADD:0] r_ptr_gray
);

    reg  [ADD:0] rbin;
    wire [ADD:0] rbin_next;
    wire [ADD:0] r_gray_next;
    wire          r_empty_val;

    assign rbin_next  = rbin + (r_en & ~r_empty);
    assign r_gray_next = rbin_next ^ (rbin_next >> 1);

    assign r_addr = rbin[ADD-1:0];

    assign r_empty_val = (w_ptr_sync == r_gray_next);

    always @(posedge r_clk or negedge rst_n) begin
        if (!rst_n) begin
            rbin       <= 0;
            r_ptr_gray <= 0;
            r_empty    <= 1'b1;
        end
        else begin
            rbin       <= rbin_next;
            r_ptr_gray <= r_gray_next;
            r_empty    <= r_empty_val;
        end
    end

endmodule