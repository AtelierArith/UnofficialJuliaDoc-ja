```julia
Array{T}(undef, dims)
Array{T,N}(undef, dims)
```

型 `T` の要素を格納する、未初期化の `N` 次元の [`Array`](@ref) を構築します。`N` は、`Array{T,N}(undef, dims)` のように明示的に指定することも、`dims` の長さまたは個数から決定することもできます。`dims` には、各次元の長さを表すタプル、または複数の整数引数を指定できます。ランク `N` を明示的に指定する場合は、`dims` の長さまたは個数と一致していなければなりません。ここで、[`undef`](@ref) は [`UndefInitializer`](@ref) です。

# Examples

```julia-repl
julia> A = Array{Float64, 2}(undef, 2, 3) # N given explicitly
2×3 Matrix{Float64}:
 6.90198e-310  6.90198e-310  6.90198e-310
 6.90198e-310  6.90198e-310  0.0

julia> B = Array{Float64}(undef, 4) # N determined by the input
4-element Vector{Float64}:
   2.360075077e-314
 NaN
   2.2671131793e-314
   2.299821756e-314

julia> similar(B, 2, 4, 1) # use typeof(B), and the given size
2×4×1 Array{Float64, 3}:
[:, :, 1] =
 2.26703e-314  2.26708e-314  0.0           2.80997e-314
 0.0           2.26703e-314  2.26708e-314  0.0
```
