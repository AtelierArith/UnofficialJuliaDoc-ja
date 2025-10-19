# printf() and stdio in the Julia runtime

## [Libuv wrappers for stdio](@id Libuv-wrappers-for-stdio)

`julia.h` は [libuv](https://docs.libuv.org) のラッパーを `stdio.h` ストリームのために定義しています：

```c
uv_stream_t *JL_STDIN;
uv_stream_t *JL_STDOUT;
uv_stream_t *JL_STDERR;
```

... および対応する出力関数:

```c
int jl_printf(uv_stream_t *s, const char *format, ...);
int jl_vprintf(uv_stream_t *s, const char *format, va_list args);
```

これらの `printf` 関数は、出力バッファリングが統一された方法で処理されることを保証するために、`src/` および `cli/` ディレクトリ内の `.c` ファイルで必要に応じて使用されます。

In special cases, like signal handlers, where the full libuv infrastructure is too heavy, `jl_safe_printf()` can be used to [`write(2)`](@ref) directly to `STDERR_FILENO`:

```c
void jl_safe_printf(const char *str, ...);
```

## Interface between JL_STD* and Julia code

[`Base.stdin`](@ref)、[`Base.stdout`](@ref) および [`Base.stderr`](@ref) は、ランタイムで定義された `JL_STD*` libuv ストリームにバインドされています。

ジュリアの `__init__()` 関数（`base/sysimg.jl` 内）は、`reinit_stdio()`（`base/stream.jl` 内）を呼び出して、[`Base.stdin`](@ref)、[`Base.stdout`](@ref) および [`Base.stderr`](@ref) のためのジュリアオブジェクトを作成します。

`reinit_stdio()` は [`ccall`](@ref) を使用して `JL_STD*` へのポインタを取得し、各ストリームのタイプを調べるために `jl_uv_handle_type()` を呼び出します。その後、各ストリームを表すために Julia の `Base.IOStream`、`Base.TTY` または `Base.PipeEndpoint` オブジェクトを作成します。例えば：

```
$ julia -e 'println(typeof((stdin, stdout, stderr)))'
Tuple{Base.TTY,Base.TTY,Base.TTY}

$ julia -e 'println(typeof((stdin, stdout, stderr)))' < /dev/null 2>/dev/null
Tuple{IOStream,Base.TTY,IOStream}

$ echo hello | julia -e 'println(typeof((stdin, stdout, stderr)))' | cat
Tuple{Base.PipeEndpoint,Base.PipeEndpoint,Base.TTY}
```

[`Base.read`](@ref) および [`Base.write`](@ref) メソッドは、これらのストリームに対して [`ccall`](@ref) を使用して、`src/jl_uv.c` 内の libuv ラッパーを呼び出します。例えば:

```
stream.jl: function write(s::IO, p::Ptr, nb::Integer)
               -> ccall(:jl_uv_write, ...)
  jl_uv.c:          -> int jl_uv_write(uv_stream_t *stream, ...)
                        -> uv_write(uvw, stream, buf, ...)
```

## printf() during initialization

`jl_printf()` などに依存する libuv ストリームは、ランタイムの初期化の途中まで利用できません（`init.c` の `init_stdio()` を参照）。この前に印刷する必要があるエラーメッセージや警告は、次のメカニズムによって標準 C ライブラリの `fwrite()` 関数にルーティングされます：

`sys.c`では、`JL_STD*`ストリームポインタが整数定数`STD*_FILENO (0, 1, 2)`に静的に初期化されています。`jl_uv.c`では、`jl_uv_puts()`関数がその`uv_stream_t* stream`引数をチェックし、ストリームが`STDOUT_FILENO`または`STDERR_FILENO`に設定されている場合に`fwrite()`を呼び出します。

これにより、初期化が完了する前に特定のコードが到達可能かどうかに関係なく、ランタイム全体で `jl_printf()` を一貫して使用できるようになります。

## [Legacy `ios.c` library](@id Legacy-ios.c-library)

`src/support/ios.c`ライブラリは[femtolisp](https://github.com/JeffBezanson/femtolisp)から継承されています。これは、クロスプラットフォームのバッファ付きファイルIOとメモリ内一時バッファを提供します。

`ios.c` はまだ以下で使用されています:

  * `src/flisp/*.c`
  * `src/dump.c` – シリアル化ファイルIOおよびメモリバッファ用。
  * `src/staticdata.c` – シリアル化ファイルIOおよびメモリバッファ用。
  * `base/iostream.jl` – ファイル入出力用 (libuvの同等物については`base/fs.jl`を参照)。

`ios.c`のこれらのモジュールでの使用は、主に自己完結型であり、libuv I/Oシステムから分離されています。しかし、[one place](https://github.com/JuliaLang/julia/blob/master/src/flisp/print.c#L654)では、femtolispがレガシー`ios_t`ストリームを使用して`jl_printf()`を呼び出します。

`ios.h`には、`ios_t.bm`フィールドが`uv_stream_t.type`と整列するようにするハックがあり、`ios_t.bm`に使用される値が有効な`UV_HANDLE_TYPE`の値と重複しないことを保証します。これにより、`uv_stream_t`ポインタが`ios_t`ストリームを指すことができます。

これは、`jl_printf()` の呼び出し元である `jl_static_show()` に femtolisp の `fl_print()` 関数によって `ios_t` ストリームが渡されるために必要です。Julia の `jl_uv_puts()` 関数はこれに特別な処理を行っています：

```c
if (stream->type > UV_HANDLE_TYPE_MAX) {
    return ios_write((ios_t*)stream, str, n);
}
```
