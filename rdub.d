/+

version 1.0.0

rdub is a front end for dub

	rdub //rund dub with defaults \src or \source\app.d
	
	rdub C:\path\app.d
	
	1. copies C:\path\app.d to src\app.d
	2. asks before deleting all other files in \src (avoids more than 1 main()).
	2. runs dub with defaults to build and run src\app.d
	3. passes all args to dub, except: h|help
	
	Requires: dub.json or dub.sdl must have name and targetType "executable"
		name "snippet" //the name of the .exe
		description "Run DWT Snippets"
		targetType "executable"
		sourceFiles "res\\resource.res" platform="windows"
		stringImportPaths "..\\dwt\\org.eclipse.swt.snippets\\res"
		dependency "dwtlib" version="~>1.0.2"
	
+/

module dlang.apps.rdub;

import std.ascii;
import std.conv;
import std.file;
import std.path, std.process;
import std.stdio, std.string;

enum SUCCESS=0, ERROR=1;
enum srcDir = "src";

string[] files, flags, dubFlags;
string dubArgs, rdubArgs;
string sourceFile, targetFile;

bool helpFlag, yesFlag;

int main(string[] args)
{

	//get files and flags, ignore arg[0] which is this exe
	for (int i=1; i < args.length; i++) {
		if ( args[i].startsWith("-") ) {
			flags ~= args[i];
		} else {
			if (args[i] !="") files ~= args[i];  //.bat files could pass empty args
		}
	}
	
	//check option flags and strip from the command line so they are not passed as dub args
	//incidently, this will also detect --help and --yes
	for (int i; i < flags.length; i++)
	{
		if ( indexOf(flags[i], "-h") != -1 ) {
			helpFlag = true;
		} else if ( indexOf(flags[i], "-y") != -1 ) {
			yesFlag = true;
		} else {
			dubFlags ~= flags[i];
		}
	}

	//show help
	if (helpFlag) {
		showHelp();
		return SUCCESS;
	}
	
	//if more than 1 file as arg, error
	if ( files.length > 1 ) {
		writeln("ERROR only one 1 file allowed.");
		return ERROR;
	}

	//if no file as arg, use default
	if ( files.length == 0 ) {
		files ~= r"src\app.d";	
	} else {

		//if no extension, add .d
		sourceFile = files[0];
		if (sourceFile.extension == "") sourceFile ~= ".d";
		
		//exists?
		if (!sourceFile.exists) {
			writeln("ERROR file not found: " ~ sourceFile);
			return ERROR;
		}
		
		//is main?
		if (!sourceFile.isMain) {
			writeln("ERROR file not main(): " ~ sourceFile);
			return ERROR;
		}
		
		//if src exists and yes flag, remove
		if (srcDir.exists) {
			if (yesFlag) {
				rmdirRecurse(srcDir);			
			} else {
				writeln("WARNING src folder exists, use --yes to overwrite.");
				return SUCCESS;
			}
		}

		//mkdir src and copy \path\foo.d \src\foo.d
		mkdir(srcDir);
		targetFile = srcDir ~ dirSeparator ~ baseName(sourceFile);
		copy(sourceFile, targetFile);

	}
		
	//form args to pass to dub command line
	foreach (f; dubFlags)
		dubArgs ~= f ~ " ";

	//run dub with args passed from the rdub command line
	string cmd = "dub " ~ dubArgs;

	int returnCode = doPipeShell(cmd);
	
	if (returnCode == ERROR)
	{
		writeln("ERROR code: ", returnCode);
	}
	
	return SUCCESS;

}

bool isMain(string filePath) {
	string line;
	
	if ( filePath.exists )
	{
		try
	    {
	        auto file = File(filePath, "r");
	        while ((line = file.readln()) !is null)
	        {
				if (indexOf(line.removechars(whitespace), "main(") != -1) {
					return true;
				}
	        }
	    }
	    catch (FileException ex)
	    {
	        writeln("ERROR reading file: ", filePath);
	    }
	}
	return false;
}

int doPipeShell(string cmd) {
	
	int returnCode = 0;
	
	auto pipes = pipeShell(cmd, Redirect.stdout | Redirect.stderr, null, Config.suppressConsole);
	
	scope(exit) {
	    wait(pipes.pid);
	}
	
	foreach (line; pipes.stdout.byLine) {
	    writeln(to!string(line));	
	}
	
	foreach (line; pipes.stderr.byLine) {
	    writeln(to!string(line));
	    returnCode = 1;
	}
	
	return returnCode;
}

void showHelp()
{

string helpText = `
	rdub is a front end for DUB - a D language build tool

	rdub                 = run dub with defaults \src or \source\app.d
	
	rdub C:\path\foo.d   = rund dub as follows:
	
	1. Copy C:\path\foo.d to src\foo.d
	2. Ask before deleting all other files in \src - avoids more than 1 main().
	2. Run dub to build and run src\app.d
	3. Pass all args to dub, except: -h or --help
	
	Requires: dub.json or dub.sdl must have name "exename" and targetType "executable"
	
`;

    writeln(helpText);

}
