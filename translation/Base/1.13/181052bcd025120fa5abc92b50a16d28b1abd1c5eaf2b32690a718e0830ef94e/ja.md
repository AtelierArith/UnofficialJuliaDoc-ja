```julia
@lock_nofail l expr
```

関数がエラーをスローしないことを保証できる場合は、`@lock l expr`と同等です。この場合、try-catchを避けることでパフォーマンスが向上することがあります。[`@lock`](@ref)を参照してください。
