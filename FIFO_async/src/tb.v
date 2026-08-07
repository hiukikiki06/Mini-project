`timescale 1ns/1ps // Định nghĩa đơn vị thời gian mô phỏng là 1ns, độ chính xác 1ps

module top_tb;

    // =========================================================================
    // 1. KHAI BÁO CÁC PARAMETER & TÍN HIỆU CONNECT
    // =========================================================================
    parameter WIDTH = 8;
    parameter ADD   = 4;
    localparam DEPTH = 1 << ADD; // 2^4 = 16 ô nhớ

    // Các tín hiệu miền GHI (Khai báo reg để gán giá trị trong khối initial)
    reg              w_clk;
    reg              wrst_n;
    reg              w_en;
    reg  [WIDTH-1:0] w_data;
    wire             w_full;

    // Các tín hiệu miền ĐỌC
    reg              r_clk;
    reg              rrst_n;
    reg              r_en;
    wire [WIDTH-1:0] r_data;
    wire             r_empty;

    // Biến phụ dùng trong vòng lặp testbench
    integer i;

    // =========================================================================
    // 2. KẾT NỐI VÀO MODULE TOP (DUT - Device Under Test)
    // =========================================================================
    top #(
        .WIDTH(WIDTH),
        .ADD(ADD)
    ) uut (
        .w_clk(w_clk),
        .wrst_n(wrst_n),
        .w_en(w_en),
        .w_data(w_data),
        .w_full(w_full),
        
        .r_clk(r_clk),
        .rrst_n(rrst_n),
        .r_en(r_en),
        .r_data(r_data),
        .r_empty(r_empty)
    );

    // =========================================================================
    // 3. TẠO XUNG CLOCK BẤT ĐỒNG BỘ (CLOCK GENERATION)
    // =========================================================================
    
    // Miền GHI: Chu kỳ 10ns => Tần số 100 MHz
    always begin
        w_clk = 1'b0;
        #5;
        w_clk = 1'b1;
        #5;
    end

    // Miền ĐỌC: Chu kỳ 25ns => Tần số 40 MHz (Chậm hơn miền ghi)
    always begin
        r_clk = 1'b0;
        #12.5;
        r_clk = 1'b1;
        #12.5;
    end

    // =========================================================================
    // 4. KỊCH BẢN MÔ PHỎNG (STIMULUS)
    // =========================================================================
    initial begin
        // --- Bước 1: Khởi tạo trạng thái ban đầu ---
        w_en   = 1'b0;
        w_data = 0;
        r_en   = 1'b0;
        
        // Kích hoạt Reset cứng cho cả 2 miền
        wrst_n = 1'b0;
        rrst_n = 1'b0;
        #40; // Chờ 40ns
        
        // Giải phóng Reset (Mạch bắt đầu chạy)
        @(posedge w_clk); wrst_n = 1'b1;
        @(posedge r_clk); rrst_n = 1'b1;
        #20;

        $display("--- THỜI ĐIỂM BẮT ĐẦU SIMULATION ---");
        
        // Kiểm tra xem lúc mới reset xong cờ r_empty có bằng 1 không
        if (r_empty == 1'b1) 
            $display("[OK] FIFO trong rong sau Reset.");
        else 
            $display("[ERROR] FIFO khong rong sau Reset!");

        // --- Bước 2: GHI LIÊN TỤC CHO ĐẾN KHI ĐẦY (Write Burst to Full) ---
        $display("\n---> Kich ban 1: Ghi lien tuc vao FIFO cho den khi FULL...");
        @(posedge w_clk);
        
        // Ghi vào 18 dữ liệu (Dung lượng thực tế chỉ có 16)
        for (i = 0; i < DEPTH + 2; i = i + 1) begin
            if (!w_full) begin
                w_en   = 1'b1;
                w_data = i + 8'hA0; // Dữ liệu mẫu: A0, A1, A2...
                $display("[WRITE] Time=%0t | Data=%h", $time, w_data);
            end else begin
                $display("[WRITE BLOCKED] Time=%0t | FIFO da bi FULL, ko the ghi data=%h", $time, i + 8'hA0);
            end
            @(posedge w_clk);
        end
        w_en = 1'b0; // Tắt lệnh ghi sau khi burst xong
        
        #100; // Chờ một thời gian để tín hiệu đồng bộ hóa truyền qua mạch rclk

        // --- Bước 3: ĐỌC LIÊN TỤC CHO ĐẾN KHI CẠN SẠCH (Read Burst to Empty) ---
        $display("\n---> Kich ban 2: Doc lien tuc khoi FIFO cho den khi EMPTY...");
        @(posedge r_clk);
        
        // Tiến hành đọc 18 lần để xem cờ r_empty hoạt động ra sao
        for (i = 0; i < DEPTH + 2; i = i + 1) begin
            if (!r_empty) begin
                r_en = 1'b1;
                $display("[READ]  Time=%0t | Data_out=%h", $time, r_data);
            end else begin
                r_en = 1'b0;
                $display("[READ BLOCKED]  Time=%0t | FIFO da EMPTY, ko co du lieu de doc!", $time);
            end
            @(posedge r_clk);
        end
        r_en = 1'b0; // Tắt lệnh đọc

        #100;

        // --- Bước 4: VỪA GHI VỪA ĐỌC ĐỒNG THỜI (Simultaneous Write & Read) ---
        $display("\n---> Kich ban 3: Vua ghi vua doc dong thoi voi 2 clock khac nhau...");
        
        // Kích hoạt cả 2 lệnh cùng lúc
        w_en = 1'b1;
        r_en = 1'b1;
        
        // Cho chạy song song trong vòng 200ns
        for (i = 0; i < 20; i = i + 1) begin
            w_data = i + 8'h50; // Dữ liệu mẫu: 50, 51, 52...
            #10;
        end
        
        w_en = 1'b0;
        r_en = 1'b0;

        #200;
        $display("\n--- KẾT THÚC SIMULATION ---");
        $finish; // Kết thúc mô phỏng
    end

endmodule
