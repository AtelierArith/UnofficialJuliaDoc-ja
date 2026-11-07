```julia
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

`library.function_name`で指定した、Cからエクスポートされた共有ライブラリ内の関数を呼び出します。`library`は文字列定数または文字列リテラルです。ライブラリは省略できます。その場合、`function_name`は現在のプロセス内で解決されます。また、`@ccall`を使って、`dlsym`が返す値などの関数ポインタ`$function_pointer`を呼び出すこともできます。

`argvalue`から`@ccall`までの各引数は、`unsafe_convert(argtype, cconvert(argtype, argvalue))`の呼び出しが自動的に挿入され、対応する`argtype`に変換されます。（詳しくは、[`unsafe_convert`](@ref Base.unsafe_convert)および[`cconvert`](@ref Base.cconvert)のドキュメントも参照してください。）ほとんどの場合、これは単に`convert(argtype, argvalue)`の呼び出しになります。

# Examples

```julia
@ccall strlen(s::Cstring)::Csize_t
```

これは、C標準ライブラリ関数を呼び出します。

```julia
size_t strlen(char *)
```

Juliaの変数名`s`を使います。`ccall`も参照してください。

可変長引数は、次の規則に従ってサポートされます。

```julia
@ccall printf("%s = %d"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
```

セミコロンは、必須引数（少なくとも1つ必要）と可変長引数を区切るために使います。

外部ライブラリを使う例：

```julia
# C signature of g_uri_escape_string:
# char *g_uri_escape_string(const char *unescaped, const char *reserved_chars_allowed, gboolean allow_utf8);

const glib = "libglib-2.0"
@ccall glib.g_uri_escape_string(my_uri::Cstring, ":/"::Cstring, true::Cint)::Cstring
```

必要であれば、関数名の直前に文字列リテラルを直接指定することもできます`"libglib-2.0".g_uri_escape_string(...`

`gc_safe = true`オプションを使うと、ccallを`gc_safe`として宣言できます。

```julia
@ccall gc_safe=true strlen(s::Cstring)::Csize_t
```

これにより、ccallの実行中にガベージコレクタを並行して動作させられます。`ccall`がJuliaの外部でブロックする可能性がある場合に便利です。

!!! warning
    ccallからJuliaランタイムにコールバックすると未定義動作につながる可能性があるため、このオプションは慎重に使用してください。ただし、`@cfunction`/`@ccallables`は安全です。


!!! compat "Julia 1.12"
    `gc_safe`引数を使うには、Julia 1.12以降が必要です。

