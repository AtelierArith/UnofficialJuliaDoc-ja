```
@__DIR__ -> String
```

現在のディレクトリの絶対パスを文字列として取得するためのマクロです。

スクリプト内で使用される場合、`@__DIR__`マクロ呼び出しを含むスクリプトのディレクトリを返します。REPLから実行するか、`julia -e <expr>`で評価される場合は、現在の作業ディレクトリを返します。

# 例

この例は、現在の作業ディレクトリとは異なるディレクトリに簡単なスクリプトを作成し、`@__DIR__`と`pwd()`の動作の違いを示しています：

```julia-repl
julia> cd("/home/JuliaUser") # 作業ディレクトリ

julia> # /home/JuliaUser/Projectsにスクリプトを作成
       open("/home/JuliaUser/Projects/test.jl","w") do io
           print(io, """
               println("@__DIR__ = ", @__DIR__)
               println("pwd() = ", pwd())
           """)
       end

julia> # スクリプトのディレクトリと現在の作業ディレクトリを出力
       include("/home/JuliaUser/Projects/test.jl")
@__DIR__ = /home/JuliaUser/Projects
pwd() = /home/JuliaUser
```
