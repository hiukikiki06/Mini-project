class tc_base #(parameter int DATA_WIDTH = 8, parameter int DEPTH = 8);
    string name;
    generator #(DATA_WIDTH) gen;

    // Đưa generator lên trước hoặc đặt giá trị mặc định (null) cho generator
    function new(string name = "test_case_base", generator #(DATA_WIDTH) gen  );
        this.name = name;
        this.gen  = gen;
    endfunction
    
endclass