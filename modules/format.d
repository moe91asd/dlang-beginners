/*



*/

module dlang.mod.format;

import std.stdio;
import std.string;
import std.conv;

void main() {

	//data type maximums https://en.wikipedia.org/wiki/C_data_types
	
	int i 	= 1234567890;	//max int = 1_234_567_890
							//C int 16 bits = +/- 32,767
							
	float f	= 12345678.12; // max float until format fails - need to learn how to format large float numbers
	
	long l	= 1234567890123456789;	//max long              =     1_234_567_890_123_456_789
									//C long 32 bits        = +/-             2,147,483,647
									//C long long = 64 bits = +/- 9,223,372,036,854,775,807
									
	//format:  %[flag][min width][precision][length modifier][conversion specifier]

	//format:  %[flag][min width][precision][length modifier][conversion specifier]
	//format examples:
	//writeln( "f=" ~ format("%*.*f", 12, 2, f ) );		//f= 12345678.00
	//writeln( "f=" ~ format("%12.2f", f ) );			//f= 12345678.00
	//writeln(to!string(f)); = "%g"

	//float %f
	float f =  12345678.12;
	float g = f + 3;

	//writeln( "f=" ~ format("%20.4f", f ) );
	//writeln( "f=" ~ format("%*.*f", 12, 2, f ) );	//f= 12345678.00
	//writeln( "f=" ~ format("%12.2f", f ) );			//f= 12345678.00
	
	writeln(to!string(f)); //uses "%g"

	writeln( format("%s", f ) );

	//write just takes each argument, converts it to a string, and outputs it:
    write(1, " <- one");

	//writef treats the first string as a format-specifier (much like C's printf), and uses it to format the remaining arguments:
    writef("%d %s", 2, "<- two");

	//versions ending with "ln" aappend a newline at the end of printing.
    writeln(3, " <- three");
    writefln("%d %s", 4, "<- four");
    writefln("%s", 5, "<- five"); //missing a format-specifier

    //writefln("%f", 6, "<- six"); //FormatException, can't convert int 6 to float %f
    writefln("%f %s", 6., "<- six float"); //now 6 is a float
    writefln("%s %s", 6., "<- six string"); //%s will print all types as string, less decimals
    writefln("%06.2f, %s", 66., "<- sixty-six"); //6 total chars including the period, pad leading zeros, 2 decimal points
    
    //there is no format-specifier to print commas
    //writefln("%,d %s", 1000, "<- one thousand"); //FormatException, can't process the comma
    
    //setting the local doesn't add commas
    //setlocale(LC_NUMERIC, "en_US");
    //float n = 1000.;
    //writefln("Set Locale: %f", n);
	
    //setlocale(LC_ALL, "");
    //writefln("%d", 1123456789);
    
	//import core.stdc.stdio : printf;
    import std.string;
    //char[] hi = "hello world";
	//char[] slice = hi[0 .. 5];
	printf("\nhello");
	printf(toStringz("\nhello"));


import std.c.stdio;
import std.c.stdlib;

	printf("\n%'d primes", 1001); //does NOT support the apostrophe to print commas

	printf("\n%10.3lf\n", 13000.26);
	
	printfcomma(1001);
	
	//works char *c = cast(char*) malloc(4);
	//char *c = cast(char*) = "1001";
	
	//no printf("string = %s\n", i);
	//no printf("string = %s\n", s);
	//no printf("string = %s\n", toStringz(s));


    //printf("printf2 %,d\n", 1123456789); //comma not in the D binding to the C library
	
}
