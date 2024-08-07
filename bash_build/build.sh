#!/bin/sh
umask 022

VERSION_NUMBER="2.0"

update() {
    curl -o updated.sh -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/MohammedAlAkashi/C/main/bash_build/build.sh?$(date +%s)" 2> /dev/null
    mv updated.sh "$0"
    chmod +x "$0"
    echo "updated successfully... run with -h for help."
    exit 0
}


if [ $# -lt 1 ]; then
    echo "missing 1 argument(s)"
    echo "build C_FILE OUTPUT_NAME - OPTIONAL"
    echo "exited with status code 2"
    exit 2
fi

if [ "$1" = "-u" ]; then
    echo "checking for updates..."
    version=$(curl -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/MohammedAlAkashi/C/main/bash_build/version.txt?$(date +%s)" 2> /dev/null )

    if [ "$version" != "$VERSION_NUMBER" ]; then
                echo "update available... would you like to update? (y/N)"
        read -r choice

        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
                echo "updating..."
                update
                exit 0
        else
                echo "cancelling..."
                exit 0
        fi
    else
        echo "already up to date."
        echo "version retrieved: $version"
        echo "current version: $VERSION_NUMBER"
        exit 0
    fi

    exit 0
fi

if [ "$1" = "-m" ]; then

        files=$(ls *.c 2>/dev/null)

        echo "" > makefile
        echo "CC = gcc" >> ./makefile
        echo "CC_FLAGS = -g -pedantic -W -Wall -ansi" >> ./makefile
        echo "FILES = " $files >> ./makefile
        echo "OUT_EXE = output" >> ./makefile
        echo "\n" >> ./makefile
        echo "build: \$(FILES)" >> ./makefile
        echo "          \$(CC) \$(CC_FLAGS) -o \$(OUT_EXE) \$(FILES)" >> ./makefile
        echo "\n" >> ./makefile
        echo "clean: rm -f *.o core *.exe *~" >> ./makefile
        echo "\n" >> ./makefile
        echo "rebuild: clean build" >> ./makefile
        echo "done"
        exit 0
fi


if [ "$1" = "-s" ]; then
    echo 'alias build="~/build.sh"' >> ~/.bashrc
    source ~/.bashrc
    echo 'success, type "build -h" for details'
    exit 0
fi

if [ "$1" = "-h" ]; then
    echo ""
    echo "------ HELP ------"
    echo ""
    echo "build -u"
    echo "updates the program if there is a update"
    echo ""
    echo "build -v"
    echo "prints version number"
    echo ""
    echo "---- MAKEFILE ----"
        echo ""
        echo "build -m  // automatically generates a makefile for you based off the directory you are in."
        echo "                  // complies with C90 standards."
        echo ""
        echo "---- BUILD(S) ----"
    echo ""
    echo "build FILE.c"
    echo ""
    echo "---- OPTIONAL ----"
    echo ""
    echo "build FILE.c OUTPUT_NAME"
    echo "ex: build main.c output"
    echo ""
    exit 0
fi

if [ "$1" = "-v" ]; then
    echo "$VERSION_NUMBER"
    exit 0
fi

if [ $# -eq 1 ]; then
    gcc -g -o output "$1" -ansi -pedantic -Wall
elif [ $# -ge 2 ]; then
    gcc -g -o "$2" "$1" -ansi -pedantic -Wall
fi

result=$?

if [ $result -eq 0 ]; then
    echo "build successful with exit code: $result"
    exit 0
else
    echo "build failed with exit code: $result"
    exit 1
fi
