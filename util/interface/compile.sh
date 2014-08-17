CC="$CC_HEAD -I../engine -I../sgf -I../utils -o ";
A_FOLDER="$1";cat ./lib_list|while read line; do $CC $line.o $line.c;done;
cp *.h $A_FOLDER;
mv *.o $A_FOLDER;
