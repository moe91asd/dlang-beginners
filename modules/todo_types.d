/*

variables
cast

string is an alias for immutable(char)[]
The elements of a string can never be altered
dup returns a mutable copy of a string (not const, not immutable) 
idup returns an immutable copy
You can append to a string.
Use a char[] if you have to modify individual characters.


*/

module dlang.mod.types;

import std.stdio;

void main() {

	immutable(char)[] s = "hello";
}

