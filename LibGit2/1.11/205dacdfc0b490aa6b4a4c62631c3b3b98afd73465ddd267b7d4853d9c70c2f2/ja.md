```julia
finish(rb::GitRebase, sig::GitSignature)::Csize_t
```

`rb`で説明されているリベースを完了してください。`sig`は、リベースを完了するユーザーの本人確認に使用する[`GitSignature`](@ref)です。リベースが正常に完了した場合は`0`を、エラーが発生した場合は`-1`を返してください。
