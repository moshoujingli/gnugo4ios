CC="$CC_HEAD -o";
A_FOLDER="$1";cat ./lib_list|while read line; do $CC $line.o $line.c;done;
cp *.o $A_FOLDER;
cp *.h $A_FOLDER;
