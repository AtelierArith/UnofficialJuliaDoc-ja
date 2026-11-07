```julia
eachline(io::IO=stdin; keep::Bool=false)
eachline(filename::AbstractString; keep::Bool=false)
```

I/Oストリームまたはファイルから各行を返す、反復可能な`EachLine`オブジェクトを作成します。反復中は、ストリーム引数に対して[`readline`](@ref)を繰り返し呼び出し、末尾の改行文字を保持するかどうかを指定する`keep`を渡します。ファイル名を指定した場合、反復の開始時にファイルを一度だけ開き、終了時に閉じます。反復が中断された場合、ファイルは`EachLine`オブジェクトがガベージコレクションされる際に閉じられます。

`String`の各行を反復するには、`eachline(IOBuffer(str))`を使用できます。

[`Iterators.reverse`](@ref)を`EachLine`オブジェクトに適用すると、行を逆順に読み取れます（ファイル、バッファー、および[`seek`](@ref)をサポートするその他のI/Oストリームが対象です）。また、先頭または末尾の行を取り出すには、それぞれ[`first`](@ref)または[`last`](@ref)を使用できます。

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\n It has many members.\n");

julia> for line in eachline("my_file.txt")
           print(line)
       end
JuliaLang is a GitHub organization. It has many members.

julia> rm("my_file.txt");
```

!!! compat "Julia 1.8"
    `eachline`イテレーターで`Iterators.reverse`または`last`を使用するには、Julia 1.8が必要です。

