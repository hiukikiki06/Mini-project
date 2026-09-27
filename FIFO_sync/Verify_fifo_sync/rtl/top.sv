module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 8
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,
    output logic                  full,
    output logic                  empty
);
    // Độ rộng bit cần thiết cho con trỏ địa chỉ
    localparam int ADDR_WIDTH = $clog2(DEPTH);

    // Mảng bộ nhớ lưu trữ
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Con trỏ đọc/ghi có thêm 1 bit MSB để phân biệt giữa FULL và EMPTY
    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_WIDTH:0] rd_ptr;

    // Phân tích trạng thái Full và Empty
    // Empty: Khi cả con trỏ ghi và đọc trỏ cùng một giá trị (cả MSB và phần địa chỉ)
    assign empty = (wr_ptr == rd_ptr);

    // Full: Khi bit MSB khác nhau nhưng phần địa chỉ bằng nhau (đã ghi giáp 1 vòng)
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // Ghi dữ liệu vào FIFO
    always_ff @(posedge clk ) begin
        if (!rst_n) begin
            wr_ptr <= '0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Đọc dữ liệu từ FIFO (Đọc đồng bộ theo clock)
    always_ff @(posedge clk ) begin
        if (!rst_n) begin
            rd_ptr <= '0;
            dout   <= '0;
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

endmodule