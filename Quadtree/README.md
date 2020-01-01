## Collision Detection 2D
*Algorithms and Data Structures project, second semester of 2017*

All objects will be received by stdin and added (by `addNode`) with their respective coordinates to the objects list created in main.
Once the list is created, QT(QuadTree) is instantiated and the constructor is called with all the data received, including the list.
The fields are filled and then in the constructor it is called`divisor` with the newly created node that is the root.
`divisor` will be responsible for subdividing the plane as many times as necessary while meeting user's requirements. 
Once subdivided call is over, returning to the constructor who calls `preorden`, again with the root.
`preorden` will not only calculate the collisions by calling the `colision` function with each list node as explained above, it will also print the
list size of each node in the tree. At the end of the call it prints the calculation results thus ending the detection algorithm.

All data structures are implemented by hand.
