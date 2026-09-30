
module top_module_tb;
import tb_fifo_sync_pkg::*;
import tc_fifo_sync_pkg::*;

  parameter int DATA_WIDTH = 8;
  parameter int DEPTH      = 8;

  // Clock và Reset
  logic clk;

  // Tạo clock 100MHz (chu kỳ 10ns)
  initial
    clk = 0;
  always #5 clk = ~clk;

  // Khởi tạo Interface nối với DUT
  intf #(DATA_WIDTH) vif(clk);

  // Kết nối DUT (RTL)
  sync_fifo # (
              .DATA_WIDTH(DATA_WIDTH),
              .DEPTH(DEPTH)
            )
            sync_fifo_inst (
              .clk(clk),
              .rst_n(vif.rst_n),
              .wr_en(vif.wr_en),
              .rd_en(vif.rd_en),
              .din(vif.din),
              .dout(vif.dout),
              .full(vif.full),
              .empty(vif.empty)
            );

  // Khai báo Environment
  enviroment #(DATA_WIDTH, DEPTH) env;
  string test_name;

  // Task lựa chọn và thực thi Testcase
  task automatic run_testcase(string name);
    case (name)
      "all", "run_all": begin
        run_all();
      end
      "tc_01", "tc_01_reset":
      begin
        tc_01_reset #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_02", "tc_02_normal_write":
      begin
        tc_02_normal_write #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_03", "tc_03_fill_fifo_to_full":
      begin
        tc_03_fill_fifo_to_full #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_04", "tc_04_write_while_full":
      begin
        tc_04_write_while_full #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_05", "tc_05_normal_read":
      begin
        tc_05_normal_read #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_06", "tc_06_read_while_empty":
      begin
        tc_06_read_while_empty #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_07", "tc_07_simultaneous_read_and_write":
      begin
        tc_07_simultaneous_read_and_write #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_08", "tc_08_simutaneous_read_write_while_full":
      begin
        tc_08_simutaneous_read_write_while_full #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_09", "tc_09_simultaneous_read_and_write_while_empty":
      begin
        tc_09_simultaneous_read_and_write_while_empty #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      "tc_10", "tc_10_fifo_ordering_and_wrap_around":
      begin
        tc_10_fifo_ordering_and_wrap_around #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
      default:
      begin
        // $display("T = %0t [TB] Testcase '%s' khong ton tai! Chay mac dinh tc_01_reset...", $time, name);
        tc_01_reset #(DATA_WIDTH, DEPTH) tc = new(env.gen);
        tc.run();
      end
    endcase
  endtask

  task automatic run_all();

    tc_01_reset                                   #(DATA_WIDTH, DEPTH) tc1;
    tc_02_normal_write                            #(DATA_WIDTH, DEPTH) tc2;
    tc_03_fill_fifo_to_full                       #(DATA_WIDTH, DEPTH) tc3;
    tc_04_write_while_full                        #(DATA_WIDTH, DEPTH) tc4;
    tc_05_normal_read                             #(DATA_WIDTH, DEPTH) tc5;
    tc_06_read_while_empty                        #(DATA_WIDTH, DEPTH) tc6;
    tc_07_simultaneous_read_and_write             #(DATA_WIDTH, DEPTH) tc7;
    tc_08_simutaneous_read_write_while_full       #(DATA_WIDTH, DEPTH) tc8;
    tc_09_simultaneous_read_and_write_while_empty #(DATA_WIDTH, DEPTH) tc9;
    tc_10_fifo_ordering_and_wrap_around           #(DATA_WIDTH, DEPTH) tc10;

    $display("\n=======================================================");
    $display("       BAT DAU CHAY TOAN BO TEST SUITE (TC01 -> TC10)   ");
    $display("=======================================================");

    tc1  = new(env.gen); tc1.run();
    tc2  = new(env.gen); tc2.run();
    tc3  = new(env.gen); tc3.run();
    tc4  = new(env.gen); tc4.run();
    tc5  = new(env.gen); tc5.run();
    tc6  = new(env.gen); tc6.run();
    tc7  = new(env.gen); tc7.run();
    tc8  = new(env.gen); tc8.run();
    tc9  = new(env.gen); tc9.run();
    tc10 = new(env.gen); tc10.run();
  endtask
  // Quá trình chạy mô phỏng chính
  initial
  begin
    env = new(vif);
      env.run();
      // Nhận testcase từ tham số dòng lệnh: vsim ... +TESTNAME=tc_02
      if ($value$plusargs("TESTNAME=%s", test_name))
      begin
        $display("T = %0t [TB] Chay testcase chi dinh: %s", $time, test_name);
        repeat(100) begin
        run_testcase(test_name);
        end
      end
      else
      begin
        $display("T = %0t [TB] Khong co +TESTNAME, chay mac dinh tc_01_reset", $time);
        repeat(100) begin
        run_testcase("tc_01_reset");
        end 
      end
    env.sco.report();
    env.display_cov();
    $display("T = %0t [TB] Ket thuc mo phong!", $time);
    $finish;
  end

endmodule
