import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

ArgResults results;

void main(List<String> arity) {
  exitCode = 0;

  final envVarMap = Platform.environment;
  print('PWD = ${envVarMap["PWD"]}');
  print('LOGNAME = ${envVarMap["LOGNAME"]}');
  print('PATH = ${envVarMap["PATH"]}');
  print(Platform.isLinux);
  print(Platform.numberOfProcessors);
  print(Platform.script);
  print(Platform.isMacOS);
  print(Platform.isWindows);

  final parser = ArgParser()
      ..addFlag(lineNumber, negatable: false, abbr: 'n');

  results = parser.parse(arity);

  final paths = results.rest;

  dcat(paths, results[lineNumber] as bool);

}

Future dcat(List<String> paths, bool showLineNumber) async {
  if(paths.isEmpty) {
    await stdin.pipe(stdout);
  } else {
    for(var path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder.bind(File(path).openRead()).transform(const LineSplitter());

      try {
        var header = '`$path` BEGINS HERE!';
        stdout.writeln('\n\n$header'); for(var i = 0; i < header.length; ++i) { stdout.write('='); }
        stdout.writeln();
        await for(var line in lines) {
          if(showLineNumber) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
        stdout.writeln('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      } catch(_) {
        await _handleErrors(path);
      }
    }
  }
}

Future _handleErrors(String path) async {
  if(await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('$path is a directory');
  } else {
    exitCode = 2;
  }
}

// stdout.writeln('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');



//import 'dart:convert';
// import 'dart:io';
// import 'package:args/args.dart';

// const lineNumber = 'line-number';

// ArgResults results;

// void main(List<String> arity) {
//   exitCode = 0;

//   final parser = ArgParser()
//       ..addFlag(lineNumber, negatable: false, abbr: 'n');
  
//   results = parser.parse(arity);

//   final paths = results.rest;

//   dcat(paths, results[lineNumber] as bool);
// }

// Future dcat(List<String> paths, bool showLineNumber) async {
//   if(paths.isEmpty) {
//     await stdin.pipe(stdout);
//   } else {
//     for(var path in paths) {
//       var lineNumber = 1;
//       var lines = utf8.decoder.bind(File(path).openRead()).transform(const LineSplitter());

//       try {
//         await for(var line in lines) {
//           if(showLineNumber) {
//             stdout.write('   ${lineNumber++}  ');
//           }
//           stdout.writeln(line);
//         }
//       } on Exception {
//         await _handleErrors(path);
//       }
//     }
//   }
// }

// Future _handleErrors(String path) async {
//   if(await FileSystemEntity.isDirectory(path)) {
//     stderr.writeln('$path is a directory');
//   } else {
//     exitCode = 2;
//   }
// }



// import 'dart:convert';
// import 'dart:io';
// import 'package:args/args.dart';

// const lineNumber = 'line-number';

// ArgResults results;

// void main(List<String> arity) {
//   exitCode = 0;

//   final parser = ArgParser()
//       ..addFlag(lineNumber, negatable: false, abbr: 'n');
  
//   results = parser.parse(arity);

//   final paths = results.rest;

//   dcat(paths, results[lineNumber] as bool);
// }

// Future dcat(List<String> paths, bool showLineNumber) async {
//   if(paths.isEmpty) {
//     await stdin.pipe(stdout);
//   } else {
//     for(var path in paths) {
//       var lineNumber = 1;
//       var lines = utf8.decoder.bind(File(path).openRead()).transform(const LineSplitter());

//       try {
//         await for(var line in lines) {
//           if(showLineNumber) {
//             stdout.write('    ${lineNumber++}  ');
//           } else { stdout.write('   '); }
//           stdout.writeln(line);
//         }
//       } on Exception {
//         await _handleErrors(path);
//       }
//     }
//   }
// }


// Future _handleErrors(String path) async {
//   if(await FileSystemEntity.isDirectory(path)) {
//     stderr.writeln('$path is a directory');
//   } else {
//     exitCode = 2;
//   }
// }