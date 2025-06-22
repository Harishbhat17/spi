`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2020 10:55:37 PM
// Design Name: 
// Module Name: spiControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: SPI controller with typedef for FSM states
// 
// Dependencies: None
// 
// Revision:
// Revision 0.03 - Added typedef for FSM states
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi (
    input clk,            // 100 MHz system clock
    input reset,          // Active-high synchronous reset
    input [7:0] data_in,  // Data to send
    input load_data,      // Load new data
    output reg done_send, // Transmission complete flag
    output spi_clk,       // SPI clock (10 MHz max)
    output reg spi_data   // MOSI output
);

reg [2:0] counter;
reg clock_10;
reg CE;

assign spi_clk = (CE) ? clock_10 : 1'b0;  // SPI clock off when CE=0

// Typedef for state machine
typedef enum logic [1:0] {
    IDLE = 2'd0,
    SEND = 2'd1,
    DONE = 2'd2
} state_t;

state_t state;

reg [7:0] shiftReg;
reg [2:0] bitCount;

// Generate 10 MHz clock from 100 MHz
always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        clock_10 <= 0;
    end else begin
        if (counter < 4)
            counter <= counter + 1;
        else begin
            counter <= 0;
            clock_10 <= ~clock_10;
        end
    end
end

// State machine for SPI transmission
always @(negedge clock_10 or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done_send <= 0;
        CE <= 0;
        spi_data <= 1'b1;  // Idle high
        shiftReg <= 0;
        bitCount <= 0;
    end else begin
        case (state)
            IDLE: begin
                done_send <= 0;
                CE <= 0;
                if (load_data) begin
                    shiftReg <= data_in;
                    bitCount <= 0;
                    state <= SEND;
                end
            end

            SEND: begin
                CE <= 1;
                spi_data <= shiftReg[7];
                shiftReg <= {shiftReg[6:0], 1'b0};
                if (bitCount < 7) begin
                    bitCount <= bitCount + 1;
                    state <= SEND; end
                else
                    state <= DONE;
            end

            DONE: begin
                CE <= 0;
                done_send <= 1;
                if (!load_data) begin
                    done_send <= 1;
                    CE<=0;
                    state <= IDLE;
                end
            end

            default: state <= IDLE;  // Safety default
        endcase
    end
end

endmodule
