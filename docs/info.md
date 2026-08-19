## How it works

This project combines UART communication with a 3-tap FIR filter. The system receives three 8-bit samples followed by three 8-bit coefficients through UART at a baud rate of 9600.

The six values are sent in the following order:

Sample0 Sample1 Sample2 Coefficient0 Coefficient1 Coefficient2

Each value must be between 0 and 255.

The FIR filter multiplies each sample by its corresponding coefficient and adds the three products together. The result is limited to an 8-bit value and transmitted back through UART.

The project can communicate with a personal computer using a UART-to-USB adapter or with a microcontroller that supports UART communication.


## How to test

You can use HTerm or another serial terminal program capable of sending 8-bit values through UART.

1. Connect the UART-to-USB adapter's TX pin to the Tiny Tapeout board's UART RX (`ui[0]`).

2. Connect the UART-to-USB adapter's RX pin to the Tiny Tapeout board's UART TX (`uo[0]`).

3. Connect the ground (GND) of the UART-to-USB adapter to the ground (GND) of the Tiny Tapeout board.

4. Open HTerm and configure the serial connection with the following settings:

   - Baud rate: 9600
   - Data bits: 8
   - Stop bits: 1
   - Parity: None
   - Select the appropriate COM port

<img width="923" height="114" alt="Screenshot 2026-08-19 125006" src="https://github.com/user-attachments/assets/57d2f4aa-22f4-493a-bdd4-8e7b07bde2af" />


5. Connect to the serial port.

6. Send six values in the following order:

   Sample0 Sample1 Sample2 Coefficient0 Coefficient1 Coefficient2

   Each value must be between 0 and 255.

<img width="978" height="216" alt="Screenshot 2026-08-19 125017" src="https://github.com/user-attachments/assets/4799122b-89a3-42b6-9aea-4fc4a4739dc0" />

8. After the six values are received, the FIR filter calculates the result and transmits it through UART. The result will appear in the terminal's received data section.


<img width="986" height="399" alt="Screenshot 2026-08-19 125026" src="https://github.com/user-attachments/assets/fb258809-8adc-4876-b350-b9e1363b1a97" />


### Using a Microcontroller

Configure the microcontroller's UART interface for a baud rate of 9600.

Connect the microcontroller's TX pin to the Tiny Tapeout board's UART RX (`ui[0]`).

Connect the microcontroller's RX pin to the Tiny Tapeout board's UART TX (`uo[0]`).

Connect the ground (GND) of the microcontroller to the ground (GND) of the Tiny Tapeout board.

Program the microcontroller to send three 8-bit samples followed by three 8-bit coefficients. Each value must be between 0 and 255.

The microcontroller can then receive the resulting 8-bit FIR output through its UART RX pin.


## External hardware

- UART-to-USB adapter
- Jumper wires
- Computer running HTerm or another UART serial terminal

A microcontroller with UART support can also be used instead of a UART-to-USB adapter.
