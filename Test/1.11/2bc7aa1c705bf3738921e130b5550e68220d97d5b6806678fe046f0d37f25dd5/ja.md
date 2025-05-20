```julia
using Test

@testset "Example Test Set" begin
    let x = 1
        @test x + 1 == 2
        @test x * 2 == 2
    end
end
```
