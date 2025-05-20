```
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

Cでエクスポートされた共有ライブラリ内の関数を呼び出します。`library.function_name`で指定され、`library`は文字列定数またはリテラルです。ライブラリは省略可能で、その場合は`function_name`は現在のプロセス内で解決されます。あるいは、`@ccall`を使用して、`dlsym`によって返されるような関数ポインタ`$function_pointer`を呼び出すこともできます。

`@ccall`への各`argvalue`は、`unsafe_convert(argtype, cconvert(argtype, argvalue))`への呼び出しを自動的に挿入することによって、対応する`argtype`に変換されます。（詳細については、[`unsafe_convert`](@ref Base.unsafe_convert)および[`cconvert`](@ref Base.cconvert)のドキュメントも参照してください。）ほとんどの場合、これは単に`convert(argtype, argvalue)`への呼び出しになります。

# 例

```
@ccall strlen(s::Cstring)::Csize_t
```

これはC標準ライブラリ関数を呼び出します：

```
size_t strlen(char *)
```

Julia変数`s`を使用しています。`ccall`も参照してください。

可変引数は次の規約でサポートされています：

```
@ccall printf("%s = %d"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
```

セミコロンは、必須引数（少なくとも1つ必要）と可変引数を区切るために使用されます。

外部ライブラリを使用した例：

```
# g_uri_escape_stringのCシグネチャ：
# char *g_uri_escape_string(const char *unescaped, const char *reserved_chars_allowed, gboolean allow_utf8);

const glib = "libglib-2.0"
@ccall glib.g_uri_escape_string(my_uri::Cstring, ":/"::Cstring, true::Cint)::Cstring
```

文字列リテラルは、必要に応じて関数名の前に直接使用することもできます `"libglib-2.0".g_uri_escape_string(...`
