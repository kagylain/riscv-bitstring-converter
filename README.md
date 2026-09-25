# RISC-V Assembly Bit String to Signed Decimal Converter

A low-level computer architecture project written in **RISC-V assembly language** that parses data buffers, extracts binary representations, and converts them to signed decimal format using 2's complement logic.

## 🛠️ Key Technical Implementations
* **System Program I/O:** Utilizes environment calls (`ecall`) to open, stream-read, process, and gracefully close file system descriptors safely.
* **Buffer Architecture:** Reads binary inputs into a 1024-byte structural array buffer, managing parsing index offsets manually via register pointers.
* **Low-Level Parsing Filters:** Filters raw string data streams to bypass whitespace, newlines, carriage returns, and tabs efficiently at the CPU level.
* **Bitwise Arithmetic Logic:** Converts 32-character binary digits using arithmetic logical bit-shifts (`slli`) and bitwise OR (`ori`) logic to process 2's complement evaluations.

## 🚀 Environment and Execution
This program is optimized to run on the **MARS (MIPS Assembler and Runtime Simulator)** or the **Venus RISC-V Simulator**.

1. Clone this repository.
2. Ensure an `example2.txt` input file containing 32-bit strings is placed in the local directory.
3. Open `main.s` in your simulator and execute/step-through the registers to see active conversions.
