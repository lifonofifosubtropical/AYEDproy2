
# Ordering and Binary Search:
*Computer Estructure and Organization project, first semester of 2018*

It starts by storing in `r15` register the address of `array`, then it is verified that in the entry there are exactly 2 arguments, if not, jump to `BA` label that prints "BADARGS".
Then, `ARGV [1]` is stored, which is the data that we want to locate in the `rcx` register.
The ordering is simple, O(n²), two nested cicles that compare each element of the array and place it in the corresponding position from least to greatest.
The `BBin` tag indicates the start of the binary search.
`r8` will be equal to the lower end of the array, ie, 0.
`r10` to the upper end, ie, the size of the array.
Once the values ​​are assigned, it enter a while that checks that `r8` is always less than or equal to `r10`, that is, that the limits are not crossed, if so, the element is not in the array.
The array is split in half and it is verified that the data is there, if not, it is verified that it is above the middle or below, depending on the upper and lower registers being redefined by changing the limits, iterating until it finds the data or not.

If found, the value is printed, otherwise, it prints 0.
Also the number of iterations saved in the `r12` register.
