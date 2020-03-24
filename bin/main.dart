// IMPORT NECESSARY HEADER FILES AND PACKAGES
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

const lineNumber = 'line-number';

ArgResults results;


// MAIN FUNCTION
void main(List<String> arity) {
  exitCode = 0;

  final parser = ArgParser()
      ..addFlag(lineNumber, negatable: false, abbr:'n');

  results = parser.parse(arity);

  final paths = results.rest;

  dcat(paths, results[lineNumber] as bool);
}


/**
 * `dcat` FUNCTION WHICH RETURNS A `Future` of either 
 * 
 * 1. the contents of a file(s) passed in as arguments, or
 * 
 * 2. the input stream that returns any passed message 
 *    back to screen if no file is passed as arguments to the program
 */

Future dcat(List<String> paths, bool showLineNumber) async {
  if(paths.isEmpty) {
    await stdin.pipe(stdout);
  } else {
    for(var path in paths) {
      stdout.writeln('\n\n`$path` BEGINS HERE');
      var lineNumber = 1;
      final lines = utf8.decoder.bind(File(path).openRead())
          .transform(const LineSplitter());

      try {
        await for( var line in lines ) {
          if(showLineNumber) {
            stdout.write('    ${lineNumber++}   ');
          }
          stdout.writeln(line);
        }
        stdout.writeln('===================================');
      } on Exception {
        await _handleErrors(path);
      }
    }
  }
}


/**
 * `_handleErrors` PRIVATE FUNCTION THAT HANDLES ERRORS RELATING TO PATH ARGUMENT 404s
 * IT RETURNS A `Future` OBJECT OF THE RESULT OF 
 * A CONFIRMATION OF PATH AS A FILE OR DIRECTORY, OR AS NONE
 */

Future _handleErrors(String path) async {
  if(await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('$path is a directory');
  } else {
    exitCode = 2;  //error return
  }
}