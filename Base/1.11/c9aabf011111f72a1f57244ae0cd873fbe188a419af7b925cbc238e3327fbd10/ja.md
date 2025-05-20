```
eachrsplit(str::AbstractString, dlm; limit::Integer=0, keepempty::Bool=true)
eachrsplit(str::AbstractString; limit::Integer=0, keepempty::Bool=false)
```

`str`を区切り文字`dlm`で分割したときに生成される`SubString`のイテレータを返し、逆順（右から左）で出力されます。`dlm`は[`findprev`](@ref)の最初の引数で許可される形式（すなわち、文字列、単一の文字、または関数）または文字のコレクションのいずれかであることができます。

`dlm`が省略された場合、デフォルトは[`isspace`](@ref)で、`keepempty`のデフォルトは`false`です。

オプションのキーワード引数は次のとおりです：

  * `limit > 0`の場合、イテレータは最大で`limit - 1`回分割し、その後は残りの文字列を分割せずに返します。`limit < 1`は分割に制限がないことを意味します（デフォルト）。
  * `keepempty`: 空のフィールドをイテレートする際に返すべきかどうか。デフォルトは`dlm`引数なしで`false`、`dlm`引数ありで`true`です。

[`split`](@ref)、[`rsplit`](@ref)、および[`eachsplit`](@ref)とは異なり、この関数は入力に現れる順序で部分文字列を右から左にイテレートします。

他に[`eachsplit`](@ref)、[`rsplit`](@ref)も参照してください。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。


# 例

```jldoctest
julia> a = "Ma.r.ch";

julia> collect(eachrsplit(a, ".")) == ["ch", "r", "Ma"]
true

julia> collect(eachrsplit(a, "."; limit=2)) == ["ch", "Ma.r"]
true
```
