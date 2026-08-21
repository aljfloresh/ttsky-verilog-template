![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# UART 3-Tap FIR Filter for Tiny Tapeout

A Verilog implementation of a **3-tap Finite Impulse Response (FIR) filter with UART communication**, designed for the Tiny Tapeout platform.

- [Project documentation and testing instructions](docs/info.md)

## Project Overview

The design receives three 8-bit samples followed by three 8-bit coefficients through UART at **9600 baud**.

The values are received in the following order:

`Sample0 Sample1 Sample2 Coefficient0 Coefficient1 Coefficient2`

The FIR filter calculates:

`Output = (Sample0 × Coefficient0) + (Sample1 × Coefficient1) + (Sample2 × Coefficient2)`

The result is limited to an 8-bit value. Results greater than 255 are saturated to **255** and transmitted back through UART.

## Design Architecture

The project consists of five main Verilog modules:

- `tt_um_UART.v` — Tiny Tapeout top-level module
- `UART_RX.v` — UART receiver
- `input_counter.v` — Tracks the six received input values
- `_3tap_fir.v` — Performs the FIR calculation
- `UART_TX.v` — Transmits the calculated result

Data flow:

`UART RX → Input Counter → 3-Tap FIR → UART TX`

## Tiny Tapeout Interface

| Pin | Function |
|---|---|
| `ui[0]` | UART RX |
| `uo[0]` | UART TX |

The design uses a **66 MHz clock** and UART communication at **9600 baud**.

## Testing

The design can communicate with:

- A computer using a UART-to-USB adapter and serial terminal such as HTerm
- A microcontroller with UART support

UART configuration:

- Baud rate: **9600**
- Data bits: **8**
- Stop bits: **1**
- Parity: **None**

Detailed connection diagrams, testing instructions, and examples are available in [docs/info.md](docs/info.md).

## Project Structure

```text
src/
├── tt_um_UART.v
├── UART_RX.v
├── UART_TX.v
├── input_counter.v
└── _3tap_fir.v

test/
├── test.py
└── tb.v

docs/
└── info.md

info.yaml
