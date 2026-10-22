`timescale 1ns/1ps

module tb_mult;

reg        clk;
reg        rst_n;
reg  [3:0] a, b;
wire [7:0] p;

integer    i, j;
integer    errors;
reg  [7:0] expected;

mult_array dut (
    .clk   (clk),
    .rst_n (rst_n),
    .a     (a),
    .b     (b),
    .p     (p)
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    $dumpfile("mult.vcd");
    $dumpvars(0, tb_mult);
end

initial begin
    rst_n  = 1'b0;
    a      = 4'd0;
    b      = 4'd0;
    errors = 0;

    repeat (2) @(posedge clk);
    rst_n = 1'b1;

    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            a        = i[3:0];
            b        = j[3:0];
            expected = i * j;

            @(posedge clk);
            @(posedge clk);
            #1;

            if (p !== expected) begin
                errors = errors + 1;
                $display("MISMATCH: a=%0d b=%0d expected=%0d got=%0d", i, j, expected, p);
            end
        end
    end

    if (errors == 0)
        $display("PASS: 256 vectors checked, 0 errors");
    else
        $display("FAIL: 256 vectors checked, %0d errors", errors);

    $finish;
end

endmodule
