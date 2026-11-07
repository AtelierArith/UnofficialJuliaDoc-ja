```julia
VersionNumber
```

Version number type which follows the specifications of [semantic versioning (semver)](https://semver.org/spec/v2.0.0-rc.2.html), composed of major, minor and patch numeric values, followed by pre-release and build alphanumeric annotations.

`VersionNumber` objects can be compared with all of the standard comparison operators (`==`, `<`, `<=`, etc.), with the result following semver v2.0.0-rc.2 rules.

`VersionNumber` has the following public fields:

  * `v.major::Integer`
  * `v.minor::Integer`
  * `v.patch::Integer`
  * `v.prerelease::Tuple{Vararg{Union{Integer, AbstractString}}}`
  * `v.build::Tuple{Vararg{Union{Integer, AbstractString}}}`

See also [`@v_str`](@ref) to efficiently construct `VersionNumber` objects from semver-format literal strings, [`VERSION`](@ref) for the `VersionNumber` of Julia itself, and [Version Number Literals](@ref man-version-number-literals) in the manual.

# Examples

```jldoctest
julia> a = VersionNumber(1, 2, 3)
v"1.2.3"

julia> a >= v"1.2"
true

julia> b = VersionNumber("2.0.1-rc1")
v"2.0.1-rc1"

julia> b >= v"2.0.1"
false
```
