module top_module #(
    parameter W = 8, // độ rộng thanh ghi
    parameter L = 8, // độ sâu thanh ghi
    parameter ADD = 3 // số lượng bit chọn địa chỉ
)(
    input clk,
    input rst,
    input [W-1 : 0] din,
    input wri,
    input rea,
    output full,
    output empty,
    output reg [W -1 : 0] dout
);
    // con trở địa chỉ ram
    reg [ADD-1 : 0] wri_ptr; // con trỏ ghi
    reg [ADD-1 : 0] rea_ptr; // con trỏ đọc

    reg [W-1 : 0] mem [0 : L-1]; // thanh ghi lưu trữ
    reg [ADD : 0] status_cnt; // trang thai dem xem day fifo chua
    wire rea_ena, wri_ena; 
    // logic cho phép đọc, ghi
    assign rea_ena = rea && !empty; 
    assign wri_ena = wri && !full;
    // logic gán cờ trạng thái
    assign empty = (status_cnt == 0);
    assign full = (status_cnt == L);
    // logic ghi du lieu va cap nhat con tro ghi
    always @ ( posedge clk ) begin
        if ( rst ) begin
            wri_ptr <= 0;
        end
        else if ( wri_ena ) begin
            mem [ wri_ptr] <= din;
            wri_ptr <= wri_ptr + 1;
        end   
    end
    // logic doc du lieu va cap nhat con tro doc
    always @ ( posedge clk ) begin
        if ( rst ) begin
            rea_ptr <= 0;
            dout <= 0;
        end
        else if ( rea_ena ) begin
            dout <= mem[rea_ptr];
            rea_ptr <= rea_ptr + 1;
        end
    end
    // logic quản lý bộ đếm số lượng
    always @ ( posedge clk ) begin
        if ( rst ) begin
            status_cnt <= 0;
        end
        else begin
            case ({wri_ena, rea_ena}) 
                2'b00 : status_cnt <= status_cnt; // k thao tác
                2'b01 : status_cnt <= status_cnt - 1; // chỉ đọc
                2'b10 : status_cnt <= status_cnt + 1; // chỉ ghi
                2'b11 : status_cnt <= status_cnt; // k thao tác
            endcase
        end
    end
endmodule