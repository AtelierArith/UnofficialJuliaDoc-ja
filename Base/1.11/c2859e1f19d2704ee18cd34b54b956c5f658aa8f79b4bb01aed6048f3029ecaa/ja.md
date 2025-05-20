```
finalizer(f, x)
```

関数 `f(x)` を登録して、`x` へのプログラムからアクセス可能な参照がなくなったときに呼び出されるようにし、`x` を返します。`x` の型は `mutable struct` でなければならず、そうでない場合は関数がエラーをスローします。

`f` はタスクスイッチを引き起こしてはいけません。これにより、`println` のようなほとんどの I/O 操作が除外されます。デバッグ目的で、`@async` マクロを使用して（ファイナライザの外でコンテキストスイッチを遅延させるために）または `ccall` を使用して C の I/O 関数を直接呼び出すことが役立つ場合があります。

`f` の実行に対して保証されたワールドエイジはないことに注意してください。ファイナライザが登録されたワールドエイジまたはそれ以降のワールドエイジで呼び出される可能性があります。

# 例

```julia
finalizer(my_mutable_struct) do x
    @async println("Finalizing $x.")
end

finalizer(my_mutable_struct) do x
    ccall(:jl_safe_printf, Cvoid, (Cstring, Cstring), "Finalizing %s.", repr(x))
end
```

ファイナライザはオブジェクトの構築時に登録できます。以下の例では、ファイナライザが新しく作成されたミュータブル構造体 `x` を返すことに暗黙的に依存していることに注意してください。

```julia
mutable struct MyMutableStruct
    bar
    function MyMutableStruct(bar)
        x = new(bar)
        f(t) = @async println("Finalizing $t.")
        finalizer(f, x)
    end
end
```
