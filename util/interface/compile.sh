CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch $2 -I/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/usr/include -DHAVE_CONFIG_H -I. -I..  -I../engine -I../sgf -I../utils  -g -O2  -c -o";
A_FOLDER="$1";cat ./lib_list|while read line; do $CC $line.o $line.c;done;
cp *.h $A_FOLDER;
mv *.o $A_FOLDER;
