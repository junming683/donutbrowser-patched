#!/usr/bin/bash
# 将 MSVC link.exe 参数转换为 GNU ld 参数
# 收集需要转换的 .lib 文件
LIBS=""
ARGS=""
MODE="link"

for arg in "$@"; do
  case "$arg" in
    *.lib)
      libname=$(basename "$arg" .lib)
      # 转换为 -l 格式
      LIBS="$LIBS -l$libname"
      ;;
    /NOLOGO|-flavor|link|-flavor|link)
      # skip
      ;;
    /OUT:*)
      outfile="${arg#/OUT:}"
      ARGS="$ARGS -o $outfile"
      ;;
    /NATVIS:*|/PDBALTPATH:*|/DEBUG)
      # skip debug/natvis options
      ;;
    /OPT:*)
      # skip optimization options
      ;;
    /NXCOMPAT)
      # skip NXCOMPAT
      ;;
    /defaultlib:*)
      lib="${arg#/defaultlib:}"
      LIBS="$LIBS -l$lib"
      ;;
    *.o|*.rlib|*.rcgu.o)
      ARGS="$ARGS $arg"
      ;;
    /LIBPATH:*)
      path="${arg#/LIBPATH:}"
      ARGS="$ARGS -L$path"
      ;;
    -L*)
      ARGS="$ARGS $arg"
      ;;
    *)
      ARGS="$ARGS $arg"
      ;;
  esac
done

# 调用 GNU linker
exec x86_64-w64-mingw32-gcc -Wl,--start-group $ARGS $LIBS -Wl,--end-group -lwinpthread -static-libgcc
