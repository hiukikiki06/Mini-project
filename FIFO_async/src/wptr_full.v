module wptr_full #(
    parameter ADD = 4
)(
    input w_clk,
    input rst_n,
    input w_en,
    input  [ADD : 0] r_ptr_sync,
    output reg [ADD : 0] wptr_gray, // con tro ghi theo ma gray
    output reg w_full,
    output [ADD - 1 : 0] w_addr // địa chỉ thô gửi thẳng vào cổng ghi của ram
);
    reg [ADD : 0] w_bin;
	wire [ADD : 0] w_bin_next;
    wire [ADD : 0] w_gray_next;
    always @ ( posedge w_clk or negedge rst_n) begin
        if ( !rst_n ) begin
            w_bin <= 0;
            wptr_gray <= 0;
        end
        else begin
            w_bin <= w_bin_next;
            wptr_gray <= w_gray_next;
        end
    end
    
    assign w_bin_next = w_bin + (!w_full & w_en);
    // ĐỔI SANG MÃ GRAY: G = B ^ (B >> 1)
    assign w_gray_next = w_bin_next ^ ( w_bin_next >> 1);
    assign w_addr = w_bin [ADD - 1 : 0];
    // dau hieu nhan biet full : 2 bit dai MSB MSB -1 ngược nhau các bit sau giống nhau
    wire w_full_val = ({~r_ptr_sync [ADD : ADD -1] ,r_ptr_sync [ADD-2 : 0]})== w_gray_next ; 
    // xuất cờ full đồng bộ qua flip flop để tín hiệu đẹp 
    always @ ( posedge w_clk or negedge rst_n) begin
        if ( ! rst_n ) begin
            w_full <= 0;
        end
        else w_full <= w_full_val;
    end
endmodule 