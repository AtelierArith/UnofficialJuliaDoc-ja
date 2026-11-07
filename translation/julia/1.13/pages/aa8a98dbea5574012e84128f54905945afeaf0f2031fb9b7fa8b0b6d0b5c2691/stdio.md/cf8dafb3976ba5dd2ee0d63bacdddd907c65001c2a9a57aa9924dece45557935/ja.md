# printf() and stdio in the Julia runtime

## [Libuv wrappers for stdio](@id Libuv-wrappers-for-stdio)

`julia.h` は、`stdio.h` ストリーム用のラッパーである [libuv](https://docs.libuv.org) を定義します。

```c
uv_stream_t *JL_STDIN;
uv_stream_t *JL_STDOUT;
uv_stream_t *JL_STDERR;
```

また、対応する出力関数も定義します。

```c
int jl_printf(uv_stream_t *s, const char *format, ...);
int jl_vprintf(uv_stream_t *s, const char *format, va_list args);
```

これらの `printf` 関数は、標準入出力が必要な箇所で、`src/` および `cli/` ディレクトリ内の `.c` ファイルから使用されます。これにより、出力バッファリングを統一的に処理できます。

シグナルハンドラーのように、libuv の全機能を使うには負荷が大きすぎる特殊なケースでは、`jl_safe_printf()` を使って、`STDERR_FILENO` に直接 [`write(2)`](@ref) できます。

```c
void jl_safe_printf(const char *str, ...);
```

## Interface between JL_STD* and Julia code

[`Base.stdin`](@ref)、[`Base.stdout`](@ref)、[`Base.stderr`](@ref) は、ランタイムで定義される `JL_STD*` の libuv ストリームにバインドされています。

Julia の `__init__()` 関数（`base/sysimg.jl` 内）は、`base/stream.jl` 内の `reinit_stdio()` を呼び出し、[`Base.stdin`](@ref)、[`Base.stdout`](@ref)、[`Base.stderr`](@ref) 用の Julia オブジェクトを作成します。

`reinit_stdio()` は [`ccall`](@ref) を使って `JL_STD*` へのポインターを取得し、`jl_uv_handle_type()` を呼び出して各ストリームの型を調べます。その後、各ストリームを表す Julia の `Base.IOStream`、`Base.TTY`、または `Base.PipeEndpoint` オブジェクトを作成します。例：

```
$ julia -e 'println(typeof((stdin, stdout, stderr)))'
Tuple{Base.TTY,Base.TTY,Base.TTY}

$ julia -e 'println(typeof((stdin, stdout, stderr)))' < /dev/null 2>/dev/null
Tuple{IOStream,Base.TTY,IOStream}

$ echo hello | julia -e 'println(typeof((stdin, stdout, stderr)))' | cat
Tuple{Base.PipeEndpoint,Base.PipeEndpoint,Base.TTY}
```

これらのストリームに対する [`Base.read`](@ref) および [`Base.write`](@ref) メソッドは、[`ccall`](@ref) を使って `src/jl_uv.c` 内の libuv ラッパーを呼び出します。例：

```
stream.jl: function write(s::IO, p::Ptr, nb::Integer)
               -> ccall(:jl_uv_write, ...)
  jl_uv.c:          -> int jl_uv_write(uv_stream_t *stream, ...)
                        -> uv_write(uvw, stream, buf, ...)
```

## printf() during initialization

`jl_printf()` などが依存する libuv ストリームは、ランタイムの初期化が途中まで進むまでは利用できません（`init.c`、`init_stdio()` を参照）。それ以前に出力する必要があるエラーメッセージや警告は、次の仕組みによって標準 C ライブラリの `fwrite()` 関数に送られます。

`sys.c` では、`JL_STD*` ストリームポインターが整数定数 `STD*_FILENO (0, 1 and 2)` で静的に初期化されています。`jl_uv.c` では、`jl_uv_puts()` 関数が `uv_stream_t* stream` 引数を確認し、ストリームが `STDOUT_FILENO` または `STDERR_FILENO` に設定されている場合は `fwrite()` を呼び出します。

これにより、初期化完了前に特定のコードへ到達できるかどうかにかかわらず、ランタイム全体で `jl_printf()` を一貫して使用できます。

## [Legacy `ios.c` library](@id Legacy-ios.c-library)

`src/support/ios.c` ライブラリは [femtolisp](https://github.com/JeffBezanson/femtolisp) から継承したものです。クロスプラットフォームのバッファー付きファイル I/O と、メモリー上の一時バッファーを提供します。

`ios.c` は、現在も次の用途で使われています。

  * `src/flisp/*.c`
  * `src/dump.c` — シリアライズ用のファイル I/O とメモリーバッファー。
  * `src/staticdata.c` — シリアライズ用のファイル I/O とメモリーバッファー。
  * `base/iostream.jl` — ファイル I/O（libuv による同等機能については `base/fs.jl` を参照）。

これらのモジュールでの `ios.c` の使用は、ほぼ自己完結しており、libuv の I/O システムから分離されています。ただし、femtolisp がレガシーな `ios_t` ストリームを使って `jl_printf()` を呼び出す [one place](https://github.com/JuliaLang/julia/blob/master/src/flisp/print.c#L654) があります。

`ios.h` には、`ios_t.bm` フィールドが `uv_stream_t.type` と一致するようにし、`ios_t.bm` に使われる値が有効な `UV_HANDLE_TYPE` の値と重ならないようにするハックがあります。これにより、`uv_stream_t` ポインターで `ios_t` ストリームを指せるようになります。

これは、`jl_printf()` の呼び出し元である `jl_static_show()` に、femtolisp の `fl_print()` 関数から `ios_t` ストリームが渡されるために必要です。Julia の `jl_uv_puts()` 関数では、これを特別に処理します。

```c
if (stream->type > UV_HANDLE_TYPE_MAX) {
    return ios_write((ios_t*)stream, str, n);
}
```
