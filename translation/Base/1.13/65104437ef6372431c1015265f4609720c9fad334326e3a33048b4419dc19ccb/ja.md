```julia
@__DIR__ -> String
```

現在のディレクトリの絶対パスを文字列として取得するマクロです。

スクリプト内で使用した場合は、`@__DIR__` マクロ呼び出しを含むスクリプトのディレクトリを返します。REPL から実行した場合、または `julia -e <expr>` によって評価された場合は、現在の作業ディレクトリを返します。

# Examples

この例では、現在の作業ディレクトリとは異なるディレクトリに簡単なスクリプトを作成し、両方のコマンドを実行することで、`@__DIR__` と `pwd()` の動作の違いを示します。

```julia-repl
julia> cd("/home/JuliaUser") # working directory

julia> # create script at /home/JuliaUser/Projects
       open("/home/JuliaUser/Projects/test.jl","w") do io
           print(io, """
               println("@__DIR__ = ", @__DIR__)
               println("pwd() = ", pwd())
           """)
       end

julia> # outputs script directory and current working directory
       include("/home/JuliaUser/Projects/test.jl")
@__DIR__ = /home/JuliaUser/Projects
pwd() = /home/JuliaUser
```
