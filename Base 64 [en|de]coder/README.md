# Base 64 [En|De]coder in ASM64
*Computer Estructure and Organization project, first semester of 2018*

Receiving data:
Both programs receive the reading path under the scanf function and validate read permissions with the access function.
A name is requested for the output file, with the same function the non-existence is validated, if these cases are not met, will jump to the `error` label, and the program will end.

## `Encoder.s`

Upon completion, the extension “.b64” with the strcat function will be added to the output file. In non-text files, some bytes may be confused with EOF, (Byte fully lit), therefore a cycle ending in EOF may not work properly when exiting prematurely. Thus, the fseek function that moves the FPI (File Position Indicator) to the true end of the file with the SEEK_END parameter, then, ftell indicates the size or number of bytes, the value is saved in a register to know how long to iterate and, finally, with the use of the rewind function the FPI returns to us at the beginning of the file.
Using the fgetc function we store, in an array of characters (one byte), `aux` until we get 3, this because each letter is 8 bits, the total size is 24, 24 by 6 (number of bits needed for encoding) is 4, then 4 characters in base 64 would result from this combination.
Each time 3 letters are obtained they will be joined in a register, this will be moved so that the 4 spaces of 6 bits stored are obtained, each set of 6 bits is used as an index to obtain the character that it represents in `b64` (The array `b64` has the 64 characters set in base 64), this is printed in the output file with fputc and the counter reset to read the next 3 characters.

We will not always obtain a number of characters multiple of 3, therefore, when leaving the cycle, the condition of less than 3 characters stored in the array is evaluated, if so, we have two cases:
* If there is only one character, the last two bits are shifted to the right, thus printing the value represented by the first 6 in b64. The two displaced are added 4 0s resulting in another value of the array and finally printed “==” representing the missing characters.
* If there are two characters in aux, the displacements, impressions and the aforementioned operation are made with the difference of printing only the “=” character, since only one byte was missing.

Then we close the files and to clean possible unread characters in the input buffer after using the getc function, iterate over getchar until we come across a line break.
We consult for the coding of another file, if it is fulfilled we jump to “main”, if not, to “quit”.

## `Deco64.s`

To validate the entries, the “ascii” array was created, which has the representation of the table with -1s in the positions where there are non-representable values ​​with 6 bits, that is, they do not exist in base 64. If the byte received in the position representing represents a -1 indicates that the number does not belong to the representation and is ignored when storing to decode. The process is similar to coding, but this aux array will stop storage when receiving 4 instead of three. Again, they are joined in a register and under a series of shifts, the 3 sets of 8 bits that are found in this are printed in the output file.

As in the other file, there are conditions that there is not a multiple of 4 bytes, and they are treated equally, displacements and fills with 0s (the = character is not printed).

At the end the files are closed and the user is consulted under the same conditions.
