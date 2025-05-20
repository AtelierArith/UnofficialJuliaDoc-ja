```
finish(rb::GitRebase, sig::GitSignature) -> Csize_t
```

`rb`で説明されたリベースを完了します。`sig`はリベースを完了するユーザーの身元を指定する[`GitSignature`](@ref)です。リベースが成功裏に完了した場合は`0`を、エラーが発生した場合は`-1`を返します。
