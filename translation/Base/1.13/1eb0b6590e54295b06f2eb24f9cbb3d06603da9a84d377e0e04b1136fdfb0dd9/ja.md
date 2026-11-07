```julia
reinterpret(T::DataType, A::AbstractArray)
```

指定された配列と同じバイナリデータを持ち、要素型が `T` である配列ビューを作成します。

この関数は、要素が明示的に取得されるまで計算されない「遅延」配列にも使用できます。たとえば、範囲 `1:6` に対する `reinterpret` は、密なベクトル `collect(1:6)` に対する場合と同様に動作します。

```jldoctest
julia> reinterpret(Float32, UInt32[1 2 3 4 5])
1×5 reinterpret(Float32, ::Matrix{UInt32}):
 1.0f-45  3.0f-45  4.0f-45  6.0f-45  7.0f-45

julia> reinterpret(Complex{Int}, 1:6)
3-element reinterpret(Complex{Int64}, ::UnitRange{Int64}):
 1 + 2im
 3 + 4im
 5 + 6im
```

`T` と `eltype(A)` でパディングビットの位置が一致しない場合、無効なビットの書き込みまたは読み取りを防ぐため、結果の配列は読み取り専用または書き込み専用になります。

```jldoctest
julia> a = reinterpret(Tuple{UInt8, UInt32}, UInt32[1, 2])
1-element reinterpret(Tuple{UInt8, UInt32}, ::Vector{UInt32}):
 (0x01, 0x00000002)

julia> a[1] = 3
ERROR: Padding of type Tuple{UInt8, UInt32} is not compatible with type UInt32.

julia> b = reinterpret(UInt32, Tuple{UInt8, UInt32}[(0x01, 0x00000002)]); # showing will error

julia> b[1]
ERROR: Padding of type UInt32 is not compatible with type Tuple{UInt8, UInt32}.
```
