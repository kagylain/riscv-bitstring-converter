

.globl __start

.rodata
  FILE_READ_MODE: .word 0b0000100
  input_path: .string "C:\\Users\\ASUS\\Downloads\\HW2\\example2.txt"
  descriptor_msg: .string "** The file descriptor number: "
  bytes_read_msg: .string "The number of bytes read: "
  string_count_msg: .string "The total number of bit strings is: "
  termination_msg: .string "** Program is terminated normally."
  line_break: .string "\n"
  separator: .string " "
  negative_sign: .string "-"

.data
  fileBuffer: .zero 1024
  binaryString: .space 33    # Storage for 32-bit string plus null terminator
  total_strings: .word 0     # Counter for processed bit strings

.text

__start:
  # File opening operation
  li a0, 13
  la a1, input_path
  lw a2, FILE_READ_MODE
  ecall
  mv s0, a0                  # Store file descriptor in s0

  # Display file descriptor information
  li a0, 4
  la a1, descriptor_msg
  ecall
  mv a1, s0
  li a0, 1
  ecall
  li a0, 4
  la a1, line_break
  ecall

  # Read file contents into buffer
  li a0, 14
  mv a1, s0
  la a2, fileBuffer
  li a3, 1024
  ecall
  mv s1, a0                  # Store number of bytes read in s1

  # Display bytes read information
  li a0, 4
  la a1, bytes_read_msg
  ecall
  mv a1, s1
  li a0, 1
  ecall
  li a0, 4
  la a1, line_break
  ecall

  # Initialize processing variables
  li s2, 0                   # Current position in file buffer
  li s3, 0                   # Current bit position in string (0-32)
  la s4, binaryString        # Pointer to binary string buffer
  li s7, 0                   # Total count of processed strings

parse_characters:
  beq s2, s1, display_final_count    # Check if we've reached end of buffer

  # Extract current character from buffer
  la t0, fileBuffer
  add t0, t0, s2
  lbu t1, 0(t0)
  addi s2, s2, 1

  # Filter out whitespace characters
  li t2, ' '                 # Space character
  beq t1, t2, parse_characters
  li t2, 10                  # Newline character
  beq t1, t2, parse_characters
  li t2, 13                  # Carriage return
  beq t1, t2, parse_characters
  li t2, 9                   # Tab character
  beq t1, t2, parse_characters

  # Store valid bit character in string buffer
  sb t1, 0(s4)
  addi s4, s4, 1
  addi s3, s3, 1

  # Check if we have collected 32 bits
  li t2, 32
  bne s3, t2, parse_characters

  # Add null terminator to complete the string
  li t2, 0
  sb t2, 0(s4)

  # Output the binary string
  li a0, 4
  la a1, binaryString
  ecall

  # Output separator
  li a0, 4
  la a1, separator
  ecall

  # Convert binary string to decimal and display
  la a0, binaryString
  jal convert_to_decimal
  mv a1, a0
  li a0, 1
  ecall

  # Output line break
  li a0, 4
  la a1, line_break
  ecall

  # Prepare for next string processing
  la s4, binaryString
  li s3, 0
  addi s7, s7, 1             # Increment string counter
  j parse_characters

display_final_count:
  # Output total string count
  li a0, 4
  la a1, string_count_msg
  ecall
  mv a1, s7
  li a0, 1
  ecall
  li a0, 4
  la a1, line_break
  ecall

  # Close the file
  li a0, 16
  mv a1, s0
  ecall

  # Display program termination message
  li a0, 4
  la a1, termination_msg
  ecall
  li a0, 4
  la a1, line_break
  ecall

  # Exit program
  li a0, 10
  ecall

# Function: Convert binary string to signed decimal (2's complement)
# Input: a0 = memory address of binary string
# Output: a0 = converted signed decimal value
convert_to_decimal:
  addi sp, sp, -12
  sw ra, 8(sp)
  sw s8, 4(sp)
  sw s9, 0(sp)
  
  mv s8, a0                  # Save string address
  li t0, 0                   # Initialize result accumulator
  li t1, 0                   # Initialize bit position counter

convert_bits:
  li t2, 32
  bge t1, t2, conversion_complete

  # Get bit character at current position
  add t3, s8, t1
  lb t2, 0(t3)
  
  # Left shift the accumulator
  slli t0, t0, 1
  
  # Set LSB if current bit is '1'
  li t3, '1'
  bne t2, t3, advance_position
  ori t0, t0, 1

advance_position:
  addi t1, t1, 1
  j convert_bits

conversion_complete:
  # Result is now in t0 as 32-bit 2's complement value
  mv a0, t0                  # Return the converted value
  
  lw s9, 0(sp)
  lw s8, 4(sp)
  lw ra, 8(sp)
  addi sp, sp, 12
  ret