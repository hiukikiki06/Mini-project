module top # ( 
    parameter WIDTH = 8,    
    parameter ADD = 4
)( 
    // mien clock ghi
    input w_clk,
    input wrst_n,
    input w_en,
    input [WIDTH - 1: 0] w_data,
    output w_full,
    // mien clock doc
    input r_clk,
    input rrst_n,
    input r_en,
    output [WIDTH - 1 : 0] r_data,
    output r_empty
);
    // internal wire
    // Địa chỉ thực tế nạp vào bộ nhớ Dual-Port RAM (Chỉ cần ADDR_WIDTH bit)
    wire [ADD -1 : 0] w_addr, r_addr;
    // Con trỏ mã Gray (Dư ra 1 bit so với ADDR_WIDTH để kiểm tra vòng lặp Full/Empty)
    wire [ADD : 0]  w_ptr_gray, r_ptr_gray;
    wire [ADD : 0]  w_ptr_sync, r_ptr_sync;
    sync_ptr # ( .ADD(ADD)) sync_r2w (
        .clk(w_clk), // theo mien clock dich
        .rst_n(wrst_n),
        .ptr_in(r_ptr_gray),
        .ptr_out(r_ptr_sync)
    );
    sync_ptr # ( .ADD(ADD)) sync_w2r (
        .clk(r_clk), // theo mien clock dich
        .rst_n(rrst_n),
        .ptr_in(w_ptr_gray),
        .ptr_out(w_ptr_sync)
    );
    fifo_mem # (.WIDTH(WIDTH),.ADD(ADD)) mem(
        //mien ghi
        .w_clk(w_clk),
        .w_full(w_full),
        .w_en(w_en),
        .w_addr(w_addr),
        .data_in(w_data),
        // mien doc
        .r_clk(r_clk),
        .r_empty(r_empty),
        .r_en(r_en),
        .r_addr(r_addr),
        .data_out(r_data)
    );
    wptr_full #(.ADD(ADD)) wptr_logic(
        .w_clk(w_clk),
        .rst_n(wrst_n),
        .w_en(w_en),
        .r_ptr_sync(r_ptr_sync),
        .w_full(w_full),
        .w_addr(w_addr),
        .wptr_gray(w_ptr_gray)
    );
    rptr_empty #(.ADD(ADD)) rptr_logic(
        .r_clk(r_clk),
        .rst_n(rrst_n),
        .r_en(r_en),
        .w_ptr_sync(w_ptr_sync),
        .r_empty(r_empty),
        .r_addr(r_addr),
        .r_ptr_gray(r_ptr_gray)
    );
endmodule  