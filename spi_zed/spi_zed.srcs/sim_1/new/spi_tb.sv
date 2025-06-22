`timescale 1ns / 1ps

module spi_tb;

// Testbench signals
reg clk;
reg reset;
reg [7:0] data_in;
reg load_data;
wire done_send;
wire spi_clk;
wire spi_data;

// Instantiate the SPI module
spi uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .load_data(load_data),
    .done_send(done_send),
    .spi_clk(spi_clk),
    .spi_data(spi_data)
);

// Clock generator: 100 MHz
always #5 clk = ~clk;  // 10 ns period = 100 MHz

initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    data_in = 8'b0;
    load_data = 0;

    // Apply reset
    #20;
    reset = 0;

    // Wait a bit, then load data
    #50;
    data_in = 8'b1010_1100;  // Example data
    load_data = 1;

    // Keep load_data high for one clock cycle
    #100;
    load_data = 0;

    // Wait for done_send to go high
    wait(done_send == 1);
    $display("Data sent at time %t", $time);

    // Hold simulation a bit longer
    #200;

    $finish;
end

endmodule
