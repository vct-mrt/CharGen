## CharGen

## Description
`CharGen` is a C project that generates random characters based on a given input number.

## Requirement Installation
```bash

cd requirement
bash requirement.sh
```

## Compilation
To compile the project, run the following command :
```bash
make
```

## How to use
```bash
./chargen <number>
```
or
```bash
Usage: ./chargen <options> <number>
Options:
	-h		Display this help message
	-n		generates only numeric
	-c		generates only letters of the alphabet
	-s		generates only special characters
	-i		letters are in lower case (required -c)
	-a		letters are in upper case (required -c)
	<number>	number of characters to generate
By default :
	[./chargen <number>] generates alpha numeric with special characters
```

## Author
- vct-mrt
