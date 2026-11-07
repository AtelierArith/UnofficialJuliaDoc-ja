# SIMD Support

`VecElement{T}` 型は、SIMD 演算のライブラリを構築するためのものです。実際に使用するには、`llvmcall` を使う必要があります。この型は次のように定義されています。

```julia
struct VecElement{T}
    value::T
end
```

この型には特別なコンパイル規則があります。`T` がプリミティブなビット型の場合、`VecElement{T}` の同種タプルは LLVM の `vector` 型に対応します。

`-O3` では、このようなタプルに対する演算がコンパイラーによって自動的にベクトル化されることがあります。たとえば、次のプログラムを `julia -O3` でコンパイルすると、x86 システムでは 2 つの SIMD 加算命令（`addps`）が生成されます。

```julia
const m128 = NTuple{4,VecElement{Float32}}

function add(a::m128, b::m128)
    (VecElement(a[1].value+b[1].value),
     VecElement(a[2].value+b[2].value),
     VecElement(a[3].value+b[3].value),
     VecElement(a[4].value+b[4].value))
end

triple(c::m128) = add(add(c,c),c)

code_native(triple,(m128,))
```

ただし、自動ベクトル化は保証されないため、今後は主に `llvmcall` を使うライブラリ経由で利用することになるでしょう。
