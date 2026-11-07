```julia
LibGit2.git_url(; kwargs...)::String
```

指定された URL コンポーネントに基づいて文字列を作成します。`scheme` キーワードが指定されていない場合、生成される URL には代わりに [scp-like syntax](https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a) が使用されます。

# Keywords

  * `scheme::AbstractString=""`: 使用するプロトコルを示す URL スキーム。HTTP には "http"、SSH には "ssh" などを指定します。`scheme` が指定されていない場合、出力形式は "ssh" になりますが、scp 形式の構文が使用されます。
  * `username::AbstractString=""`: 指定されている場合、出力に使用するユーザー名。
  * `password::AbstractString=""`: 指定されている場合、出力に使用するパスワード。
  * `host::AbstractString=""`: 出力に使用するホスト名。ホスト名の指定は必須です。
  * `port::Union{AbstractString,Integer}=""`: 指定されている場合、出力に使用するポート番号。scp 形式の構文を使用する場合は指定できません。
  * `path::AbstractString=""`: 指定されている場合、出力に使用するパス。

!!! warning
    URL にパスワードを含めないでください。認証情報オブジェクトとは異なり、Julia では使用後に機密データを安全にゼロ化または破棄できません。そのため、パスワードがメモリに残り、初期化されていないメモリを通じて漏えいする可能性があります。


# Examples

```jldoctest
julia> LibGit2.git_url(username="git", host="github.com", path="JuliaLang/julia.git")
"git@github.com:JuliaLang/julia.git"

julia> LibGit2.git_url(scheme="https", host="github.com", path="/JuliaLang/julia.git")
"https://github.com/JuliaLang/julia.git"

julia> LibGit2.git_url(scheme="ssh", username="git", host="github.com", port=2222, path="JuliaLang/julia.git")
"ssh://git@github.com:2222/JuliaLang/julia.git"
```
