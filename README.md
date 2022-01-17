# printds

A utility for macOS to help with manual duplex printing.

## Description

If your printer doesn't support duplex printing, this tool can help: it will promt you to print the first set of pages,
turn those over and insert into the paper tray, and then print the other set of pages.
It's also possible to simply save the two documents to print them at a later time.

## Usage

```swift
printds <input> [--output <output>] [--single] [--plain]
```

| Placeholder | Description
| --: | :----
| `<input>` | The path to the document.
| `--output <output>`<br/>`-o <output>` | The directory to save files to instead of printing.
| `--single`<br/>`-s` | Print a usual single-sided document.
| `--plain` | Do not style output to the console.

## Examples
Print `document.pdf` in duplex mode:
```
printds document.pdf
```

Print `document.pdf` in single-sided mode:
```
printds -s document.pdf
```

Save two documents, `document-odd.pdf` and `document-even.pdf`, to the directory `~/Desktop`, to be printed later:
```
printds document.pdf -o ~/Desktop
```
