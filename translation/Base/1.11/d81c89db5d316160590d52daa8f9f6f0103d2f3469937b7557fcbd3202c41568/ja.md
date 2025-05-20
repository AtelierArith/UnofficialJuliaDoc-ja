```
strip([pred=isspace,] str::AbstractString) -> SubString
strip(str::AbstractString, chars) -> SubString
```

`str`から先頭と末尾の文字を削除します。削除する文字は、`chars`で指定されたものか、または関数`pred`が`true`を返すものです。

デフォルトの動作は、先頭と末尾の空白および区切り文字を削除することです。正確な詳細については、[`isspace`](@ref)を参照してください。

オプションの`chars`引数は、削除する文字を指定します。これは単一の文字、ベクター、または文字の集合であることができます。

他に[`lstrip`](@ref)および[`rstrip`](@ref)も参照してください。

!!! compat "Julia 1.2"
    関数を受け入れるメソッドは、Julia 1.2以降が必要です。


# 例

```jldoctest
julia> strip("{3, 5}\n", ['{', '}', '\n'])
"3, 5"
```
