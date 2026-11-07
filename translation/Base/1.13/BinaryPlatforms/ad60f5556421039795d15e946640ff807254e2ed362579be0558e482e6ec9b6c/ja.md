```julia
parse_dl_name_version(path::String, platform::AbstractPlatform)
```

動的ライブラリへのパスを受け取り、ファイル名から取得できる情報を解析します。たとえば、"lib/libfoo.so.3.2" のようなパスが与えられると、この関数は `"libfoo", v"3.2"` を返します。パス名が有効な動的ライブラリを表していない場合、このメソッドはエラーをスローします。"libbar.so" のようにファイル名から soversion を抽出できない場合は、`"libbar", nothing` を返します。
