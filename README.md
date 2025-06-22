# SPI Master Controller in Verilog

## Overview

This project implements a simple SPI (Serial Peripheral Interface) master controller using Verilog HDL. The module supports 8-bit data transmission over the MOSI line and generates a 10 MHz SPI clock from a 100 MHz system clock. It includes a finite state machine (FSM) with clear state transitions, controlled data loading, and a `done_send` flag to signal the end of transmission.

## Features

- Designed for 100 MHz system clock input
- SPI clock output (MOSI) at 10 MHz
- Finite State Machine using `typedef enum`
- 8-bit serial data transmission
- Clean edge detection using `negedge` of SPI clock
- Transmission complete flag (`done_send`)

## Module: `spi`

### Ports

| Name       | Direction | Width | Description                              |
|------------|-----------|-------|------------------------------------------|
| `clk`      | Input     | 1     | 100 MHz system clock                     |
| `reset`    | Input     | 1     | Active-high synchronous reset            |
| `data_in`  | Input     | 8     | 8-bit parallel data to be transmitted    |
| `load_data`| Input     | 1     | Loads new data when high                 |
| `done_send`| Output    | 1     | Goes high when data transmission is done |
| `spi_clk`  | Output    | 1     | SPI clock output (10 MHz)                |
| `spi_data` | Output    | 1     | MOSI data line                           |

### FSM States

| State | Description                     |
|-------|---------------------------------|
| `IDLE` | Waits for `load_data` signal   |
| `SEND` | Transmits data bit-by-bit      |
| `DONE` | Waits for `load_data` to go low|

## SPI Clock Generation

A clock divider is implemented to divide the 100 MHz system clock to generate a 10 MHz SPI clock. The `spi_clk` signal is only active when the chip enable (`CE`) is high during transmission.

## How to Use

1. Load your 8-bit data into `data_in`.
2. Assert `load_data` high for one system clock cycle.
3. Monitor `done_send` to determine when transmission completes.
4. Deassert `load_data` to reset the FSM back to IDLE.

## Simulation & Testing

To test this module:
- Create a testbench that drives `clk`, `reset`, and `load_data`.
- Observe `spi_data` and `spi_clk` on a waveform viewer.
- Verify that 8 bits are transmitted with correct timing.

## Future Improvements

- Add MISO (Master In Slave Out) support for bidirectional communication.
- Parameterize SPI clock frequency.
- Add support for SPI modes (CPOL/CPHA).

## License

This project is open source under the MIT License.

## Author

- Developed by: *[Your Name]*
- Date: January 29, 2020

---

**Note:** This design assumes SPI Mode 0 (CPOL=0, CPHA=0) and only supports master-to-slave data transmission via MOSI.


