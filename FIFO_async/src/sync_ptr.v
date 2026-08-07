module sync_ptr #(
    parameter ADD = 4
)(
    input clk,
    input rst_n,
    input [ADD : 0] ptr_in,
    output reg [ADD : 0] ptr_out
);
    reg [ADD : 0] tmp; // tầng flip_fop thứ 1
    always @ ( posedge clk or negedge rst_n) begin
        if ( !rst_n ) begin
            tmp <= 0;
            ptr_out <= 0;
        end
        else begin
            tmp <= ptr_in;
            ptr_out <= tmp;
        end
    end
endmodule