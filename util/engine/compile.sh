CC="$CC_HEAD -I../patterns -I../sgf -I../utils -o ";
A_FOLDER="$1";cat ./lib_list|while read line; do $CC $line.o $line.c;done;
mv *.o $A_FOLDER;
cp *.h $A_FOLDER;
