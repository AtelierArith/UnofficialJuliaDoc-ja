```julia
mkdir(path::AbstractString; mode::Unsigned = 0o777)
```

新しいディレクトリを名前`path`、パーミッション`mode`で作成します。`mode`のデフォルト値は`0o777`で、現在のファイル作成マスクによって変更されます。この関数が作成するディレクトリは1つだけです。ディレクトリがすでに存在する場合、または途中のディレクトリが存在しない場合、この関数はエラーをスローします。必要な中間ディレクトリをすべて作成する関数については、[`mkpath`](@ref)を参照してください。`path`を返します。

# Examples

```jldoctest; setup = :(curdir = pwd(); testdir = mktempdir(); cd(testdir)), teardown = :(cd(curdir); rm(testdir, recursive=true)), filter = r"^\".*testingdir\"$"
julia> mkdir("testingdir")
"testingdir"

julia> cd("testingdir")

julia> pwd()
"/home/JuliaUser/testingdir"
```
