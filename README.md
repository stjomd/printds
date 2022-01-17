# printds

A utility for macOS to help with manual duplex printing.

## Description

If your printer doesn't support duplex printing, this tool can help: it will promt you to print the first set of pages,
turn those over and insert into the paper tray, and then print the other set of pages.
It's also possible to simply save the two documents to print them at a later time.

## Usage

```swift
printds <input> [--from <from>] [--to <to>] [--output <output>] [--single] [--plain]
```

| Parameter | Description
| --: | :----
| `<input>` | The path to the document.
| `--from <from>`<br/>`-f <from>` | The number of the page to be considered the first.
| `--to <to>`<br/>`-t <to>` | The number of the page to be considered the last.
| `--output <output>`<br/>`-o <output>` | The directory to save files to instead of printing.
| `--single`<br/>`-s` | Print a usual single-sided document.
| `--plain` | Do not style output to the console.

## Examples
Print `document.pdf` in duplex mode:
```
printds document.pdf
```
Print pages 2, 3, 4 and 5 of `document.pdf` in duplex mode:
```
printds document.pdf --from 2 --to 5
```

Print `document.pdf` in single-sided mode:
```
printds -s document.pdf
```
Print all pages of `document.pdf`, starting with 3, in single-sided mode:
```
printds -s document.pdf --from 3
```

Save two documents, `document-odd.pdf` and `document-even.pdf`, to the directory `~/Desktop`, to be printed later:
```
printds document.pdf -o ~/Desktop
```
Save a document `document-out.pdf` to the desktop by removing all pages in `document.pdf` after the 4th one:
```
printds -s document.pdf --to 4 --output ~/Desktop
```

## Installation
You will need to compile the source code, after which you can either add the executable to `/usr/local/bin` or run
it in any other directory.
The code also comes with a shell script to aid with installation: if you've already downloaded the source code, run
`sudo sh install.sh`.

Otherwise, you can download the code and install immediately using the following command:
```
git clone https://github.com/stjomd/printds.git && sudo printds/install.sh && rm -rf printds
```
You will be prompted to enter your password. Note that you need the Swift compiler.
