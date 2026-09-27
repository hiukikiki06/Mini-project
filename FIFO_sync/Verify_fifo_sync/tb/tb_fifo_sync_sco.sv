class scoreboard #(parameter int DATA_WIDTH = 8);
  mailbox mbx;
  transaction #(DATA_WIDTH) t;
  int w_process = 0, r_process = 0;
  int rst_process = 0;
  bit [DATA_WIDTH - 1 : 0] q[$];
  int pass_cnt= 0, fail_cnt = 0;
  // expected output 
  bit [DATA_WIDTH - 1 : 0] ex_dout;
  bit ex_empty;
  bit ex_full;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  // DISPLAY
  task display_q();
    $write("T = %0t [SCO] Queue = [ ", $time);
    foreach (q[i]) begin
      $write("%b ", q[i]); 
    end
    $write("]");
    $display("");
    $display("T = %0t [SC0] Size of queue = %0d",$time, q.size());
  endtask

  // COMPARE READ
  task compare_rd();
    if (ex_empty == t.empty && ex_full == t.full && ex_dout == t.dout ) begin
          pass_cnt ++;
          $display("T = %0t [SCO] PASS TEST dout = %b empty = %0b full = %0b",$time, t.dout, t.empty, t.full);
        end
        else begin
          fail_cnt ++;
          $display("T = %0t [SCO] FAIL TEST dout/ex_dout = %b/%b empty/ex_empty = %0b/%0b full/ex_full = %0b/%0b",$time, t.dout, ex_dout, t.full, ex_full, t.empty, ex_full);
        end
  endtask

  // COMPARE WRITE
  task compare_wr();
    if (ex_empty == t.empty && ex_full == t.full) begin
      pass_cnt ++;
      $display("T = %0t [SCO] PASS TEST empty = %0b full = %0b",$time, t.empty, t.full);
    end
    else begin
      fail_cnt ++;
      $display("T = %0t [SCO] FAIL TEST empty/ex_empty = %0b/%0b full/ex_full = %0b/%0b",$time, t.full, ex_full, t.empty, ex_full);
    end
  endtask

  // CHECK FULL EMPTY
  task check_full_empty();
    if (q.size() == 8) ex_full = 1'b1;
    else ex_full = 0;
    if (q.size() == 0) ex_empty = 1'b1;
    else ex_empty = 1'b0;  
  endtask

  // TEST
  task test();
    forever begin
      mbx.get(t);

      // task rst_n
      if (!t.rst_n) begin
        rst_process++;
        q.delete();
        check_full_empty();
        ex_dout = '0;
        compare_rd();
      end

      // task read_write
      else if (t.wr_en && t.rd_en) begin
        check_full_empty();
        if(ex_full) begin
          $display("T = %0t [SCO] Write enable not accept while full size", $time);
          $display("T = %0t [SCO] Read enable accept", $time);
          r_process++;
          ex_dout = q.pop_front();
          display_q();
          check_full_empty();
          compare_rd();
        end
        else if(ex_empty) begin
          $display("T = %0t [SCO] Read enable not accept while empty size", $time);
          $display("T = %0t [SCO] Write enable accept", $time);
          w_process++;
          q.push_back(t.din);
          display_q();
          check_full_empty();
          compare_wr();
        end
        else if(!ex_empty && !ex_full) begin
          $display("T = %0t [SCO] Read and Write enable accept", $time);
          r_process++;
          w_process++;
          q.push_back(t.din);
          ex_dout = q.pop_front();
          display_q();
          check_full_empty();
          compare_rd();
        end
      end

      //  task write
      else if (t.wr_en && !t.rd_en) begin
        ex_dout = 0;
        check_full_empty();
        if (!ex_full) begin
          $display("T = %0t [SCO] Write enable accept", $time);
          w_process++;
          q.push_back(t.din);
          display_q();
          check_full_empty();
        end
        else begin
          $display("T = %0t [SCO] Write enable not accept while full size", $time);
          display_q();
        end
        compare_wr();
      end

      // task read
      else if(t.rd_en && !t.wr_en) begin
        check_full_empty();
        if (!ex_empty) begin
          $display("T = %0t [SCO] Read enable accept", $time);
          r_process++;
          ex_dout = q.pop_front();
          display_q();
          check_full_empty();
        end
        else begin
          $display("T = %0t [SCO] Read enable not accept while empty size", $time);
          display_q();
        end
        compare_rd();
      end
    end
  endtask

  task report();
    $display("============================================");
    $display("            SCOBOARD FINAL REPORT           ");
    $display("============================================");
    $display("   Total Resets processed: %0d",rst_process);
    $display("   Total Writes processed: %0d",w_process);
    $display("   Total Reads processed: %0d",r_process);
    $display("   Total pass cnt: %0d",pass_cnt);
    $display("   Total fail cnt: %0d",fail_cnt);
  endtask
endclass

