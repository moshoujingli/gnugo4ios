
#make the different typefils to compile
cd ./gnugo
./configure
sed -i "" '/TERM/d' config.h
sed -i "" '/NCURSES/d' config.h
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
for type in 'armv7' 'armv7s' 'i386' 'x86_64'; do
	mkdir $type;
	compileFolder='./gnugo32';
	if [[ $type == 'x86_64' ]]; then
		compileFolder='./gnugo64';
	fi
	cd $compileFolder;
	for folder in 'engine' 'patterns' 'interface' 'sgf' 'utils'; do
		cd $folder
		cp ../../util/$folder/* ./
		if [[ $folder = 'patterns' ]]; then
			mv influence.c influencep.c
			mv endgame.c endgamep.c
		fi
		if [[ $type = 'armv7' || $type = 'armv7s' ]]; then
			./compile.sh ../../$type $type
		else
			./smcompile.sh  ../../$type $type
		fi
		cd ..
	done
	cd ..
done


for type in 'armv7' 'armv7s' 'i386' 'x86_64'; do
	cd ./$type
		if [[ $type = 'armv7s' || $type = 'armv7' ]]; then
			sdkPath='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk';
		else
			sdkPath='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk';
		fi
		/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool -static -arch_only $type -syslibroot $sdkPath *.o -o gnugo.a
	cd -
done

cd gnugolib
cp ../armv7/*.h ./include
xcrun -sdk iphoneos lipo -output ./gnugo.a -create \
-arch armv7s ../armv7s/gnugo.a \
-arch armv7 ../armv7/gnugo.a \
-arch i386 ../i386/gnugo.a \
-arch x86_64 ../x86_64/gnugo.a
lipo -info ./gnugo.a
cd ..
#clean
for type in 'armv7' 'armv7s' 'i386' 'x86_64'; do
	rm -rf ./$type;
done
rm -rf gnugo32
rm -rf gnugo64
