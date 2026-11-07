using Test

include(joinpath(@__DIR__, "..", "assets", "docstring_prefetch.jl"))

module ForeignPrefetchFixture
"Foreign documentation must not be collected."
foreign_function() = nothing
end

module PrefetchFixture
import ..ForeignPrefetchFixture
"Unexported root documentation."
hidden_function() = nothing
module Nested
"Nested module documentation."
hidden_child() = nothing
end

module EmptyPrefetchFixture end
end

@testset "Collect owned nested and non-exported documentation" begin
    docs = collect_documented_docstrings(PrefetchFixture)
    texts = [join(string.(doc.text)) for doc in docs]
    @test length(docs) == 2
    @test any(t -> occursin("Unexported root", t), texts)
    @test any(t -> occursin("Nested module", t), texts)
    @test !any(t -> occursin("Foreign documentation", t), texts)
    seen = Base.IdSet{Module}()
    @test length(collect_documented_docstrings(PrefetchFixture; seen_modules = seen)) == 2
    @test isempty(
        collect_documented_docstrings(PrefetchFixture.Nested; seen_modules = seen),
    )
    @test isempty(collect_documented_docstrings(PrefetchFixture.EmptyPrefetchFixture))
end

module ManyPrefetchFixture end
for i = 1:12
    name = Symbol("documented_", i)
    Core.eval(ManyPrefetchFixture, :(@doc $("Documentation $i") $name() = nothing))
end

@testset "Bounded asynchronous docstring prefetch" begin
    active = Ref(0)
    peak = Ref(0)
    completed = Ref(0)
    callback = doc -> begin
        active[] += 1
        peak[] = max(peak[], active[])
        sleep(0.02)
        active[] -= 1
        completed[] += 1
        nothing
    end
    count = prefetch_documented_docstrings(ManyPrefetchFixture, callback; concurrency = 3)
    @test count == 12
    @test completed[] == 12
    @test peak[] == 3
    @test active[] == 0
    @test_throws ArgumentError prefetch_documented_docstrings(
        ManyPrefetchFixture,
        callback;
        concurrency = 0,
    )
end
