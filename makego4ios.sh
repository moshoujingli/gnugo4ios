export SDK_VERSION=8.0
#make the different typefils to compile
cd ./gnugo
git checkout -b ioscompile
git apply ../remove_print.patch
git apply ../rename.patch

./configure
sed -i "" '/TERM/d' config.h
sed -i "" '/NCURSES/d' config.h
echo '#define GG_TURN_OFF_ASSERTS 1'>>config.h
#x86_64
make
make clean
cd ..
cp -r ./gnugo ./gnugo64
cd -
sed -i "" 's/#define SIZEOF_LONG 8/#define SIZEOF_LONG 4/' config.h
make
make clean
cd ..
cp -r ./gnugo ./gnugo32
#do compile
mkdir gnugolib
mkdir gnugolib/include
for type in 'armv7' 'armv7s' 'i386' 'x86_64' 'arm64'; do
    echo 'start compile for'$type
    mkdir $type;
    compileFolder='./gnugo32';
    if [[ $type = 'x86_64' || $type == 'arm64' ]]; then
        compileFolder='./gnugo64';
    fi
    cd $compileFolder;
    for folder in 'engine' 'patterns' 'interface' 'sgf' 'utils'; do
        cd $folder
        echo 'compile libs in '$folder
        cp ../../util/$folder/* ./
        if [[ $folder = 'patterns' && ! -f 'endgamep.c' ]]; then
            mv influence.c influencep.c
            mv endgame.c endgamep.c
        fi
        if [[ $type = 'armv7s' || $type = 'armv7' || $type = 'arm64' ]]; then
            export SDK_TYPE='OS'
        else
            export SDK_TYPE='Simulator'
        fi
        export CC_HEAD="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch $type -g -O2  -c -I/Applications/Xcode.app/Contents/Developer/Platforms/iPhone${SDK_TYPE}.platform/Developer/SDKs/iPhone${SDK_TYPE}${SDK_VERSION}.sdk/usr/include -DHAVE_CONFIG_H -I. -I.."
        ./compile.sh ../../$type $type
        cd ..
    done
    cd ..
done


for type in 'armv7' 'armv7s' 'i386' 'x86_64' 'arm64'; do
    cd ./$type
        if [[ $type = 'armv7s' || $type = 'armv7' || $type = 'arm64' ]]; then
            export SDK_TYPE='OS'
        else
            export SDK_TYPE='Simulator'
        fi
        sdkPath="/Applications/Xcode.app/Contents/Developer/Platforms/iPhone${SDK_TYPE}.platform/Developer/SDKs/iPhone${SDK_TYPE}${SDK_VERSION}.sdk";
        /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool -static -arch_only $type -syslibroot $sdkPath *.o -o gnugo.a
    cd -
done

cd gnugolib
cp ../armv7/*.h ./include
xcrun -sdk iphoneos lipo -output ./gnugo.a -create \
-arch armv7s ../armv7s/gnugo.a \
-arch armv7 ../armv7/gnugo.a \
-arch i386 ../i386/gnugo.a \
-arch x86_64 ../x86_64/gnugo.a \
-arch arm64 ../arm64/gnugo.a
lipo -info ./gnugo.a
cd ..
#clean
for type in 'arm64' 'armv7' 'armv7s' 'i386' 'x86_64'; do
    rm -rf ./$type;
done
rm -rf gnugo32
rm -rf gnugo64
