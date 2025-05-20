```
GC.@preserve x1 x2 ... xn expr
```

オブジェクト `x1, x2, ...` を式 `expr` の評価中に *使用中* としてマークします。これは、`expr` が `x` のいずれかが所有するメモリやその他のリソースを *暗黙的に使用する* 場合にのみ、unsafe コードで必要です。

`x` の *暗黙的な使用* には、コンパイラが見ることができない `x` に論理的に所有されるリソースの間接的な使用が含まれます。いくつかの例：

  * `Ptr` を介してオブジェクトのメモリに直接アクセスする
  * `ccall` に `x` へのポインタを渡す
  * 最終化子でクリーンアップされる `x` のリソースを使用する

`@preserve` は、オブジェクトのライフタイムを一時的に延長する典型的な使用ケースでは、一般的にパフォーマンスに影響を与えないはずです。実装において、`@preserve` は動的に割り当てられたオブジェクトをガーベジコレクションから保護するなどの効果があります。

# 例

`unsafe_load` でポインタから読み込むとき、基になるオブジェクトは暗黙的に使用されます。たとえば、次のように `unsafe_load(p)` によって `x` が暗黙的に使用されます。

```jldoctest
julia> let
           x = Ref{Int}(101)
           p = Base.unsafe_convert(Ptr{Int}, x)
           GC.@preserve x unsafe_load(p)
       end
101
```

ポインタを `ccall` に渡すとき、指し示すオブジェクトは暗黙的に使用され、保持されるべきです。（ただし、通常は `x` を直接 `ccall` に渡すべきであり、これは明示的な使用としてカウントされます。）

```jldoctest
julia> let
           x = "Hello"
           p = pointer(x)
           Int(GC.@preserve x @ccall strlen(p::Cstring)::Csize_t)
           # 推奨される代替
           Int(@ccall strlen(x::Cstring)::Csize_t)
       end
5
```
