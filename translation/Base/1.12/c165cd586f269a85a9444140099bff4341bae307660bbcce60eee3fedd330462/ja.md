```julia
eachline(io::IO=stdin; keep::Bool=false)
eachline(filename::AbstractString; keep::Bool=false)
```

I/O ストリームまたはファイルから各行を生成する iterable `EachLine` オブジェクトを作成します。反復処理は、ストリーム引数に対して [`readline`](@ref) を繰り返し呼び出し、`keep` を渡して、末尾の改行文字が保持されるかどうかを決定します。ファイル名で呼び出された場合、反復の開始時にファイルが一度開かれ、終了時に閉じられます。反復が中断された場合、`EachLine` オブジェクトがガーベジコレクトされるときにファイルは閉じられます。

`String` の各行を反復処理するには、`eachline(IOBuffer(str))` を使用できます。

[`Iterators.reverse`](@ref) は `EachLine` オブジェクトで使用して、行を逆順に読み取ることができます（ファイル、バッファ、および [`seek`](@ref) をサポートする他の I/O ストリームの場合）、また [`first`](@ref) または [`last`](@ref) を使用して、それぞれ最初または最後の行を抽出できます。

# 例

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\n It has many members.\n");

julia> for line in eachline("my_file.txt")
           print(line)
       end
JuliaLang is a GitHub organization. It has many members.

julia> rm("my_file.txt");
```

!!! compat "Julia 1.8"
    `eachline` イテレータで `Iterators.reverse` または `last` を使用するには、Julia 1.8 が必要です。

