```julia
Array{T}(undef, dims)
Array{T,N}(undef, dims)
```

型 `T` の要素を含む初期化されていない `N` 次元の [`Array`](@ref) を構築します。`N` は `Array{T,N}(undef, dims)` のように明示的に指定することも、`dims` の長さまたは数によって決定されることもあります。`dims` はタプルまたは各次元の長さに対応する整数引数の系列である場合があります。ランク `N` が明示的に指定された場合、それは `dims` の長さまたは数と一致しなければなりません。ここで [`undef`](@ref) は [`UndefInitializer`](@ref) です。

# 例

```julia-repl
julia> A = Array{Float64, 2}(undef, 2, 3) # N が明示的に指定されている
2×3 Matrix{Float64}:
 6.90198e-310  6.90198e-310  6.90198e-310
 6.90198e-310  6.90198e-310  0.0

julia> B = Array{Float64}(undef, 4) # N が入力によって決定される
4-element Vector{Float64}:
   2.360075077e-314
 NaN
   2.2671131793e-314
   2.299821756e-314

julia> similar(B, 2, 4, 1) # typeof(B) を使用し、指定されたサイズを使う
2×4×1 Array{Float64, 3}:
[:, :, 1] =
 2.26703e-314  2.26708e-314  0.0           2.80997e-314
 0.0           2.26703e-314  2.26708e-314  0.0
```
