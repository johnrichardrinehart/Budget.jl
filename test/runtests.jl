using Test
import Dates

include("../src/income_charts.jl")

@testset "construct regular deposits" begin
#	@test Growth.RegularDeposit(1.0, start=Dates.DateTime("2020-06-01", "y-m-d"), stop=Dates.DateTime("2020-09-01", "y-m-d"), every=Dates.Period(Dates.Month(1)))  == Growth.RegularDeposit(1.0, Dates.DateTime("2020-06-01", "y-m-d"), Dates.DateTime("2020-09-01", "y-m-d"), Dates.Period(Dates.Month(1)))
end

@testset "compound growth" begin
	@test Growth.compound(.05, 2) == (1.05)^2
	@test Growth.compound(.01, .5) == (1.01)^(.5)
	@test Growth.compound(.1, 10) == (1.1)^(10)
end
@testset "compound growth" begin
	@test Growth.compound(.05, 2) == (1.05)^2
	@test Growth.compound(.01, .5) == (1.01)^(.5)
	@test Growth.compound(.1, 10) == (1.1)^(10)
end
@testset "compound growth" begin
	@test Growth.compound(.05, 2) == (1.05)^2
	@test Growth.compound(.01, .5) == (1.01)^(.5)
	@test Growth.compound(.1, 10) == (1.1)^(10)
end

@testset "compound growth" begin
	@test Growth.compound(.05, 2) == (1.05)^2
	@test Growth.compound(.01, .5) == (1.01)^(.5)
	@test Growth.compound(.1, 10) == (1.1)^(10)
end

@testset "portofolio timelines" begin
	@test Growth.portfolio_timeline(1,3,.05) == cumsum([ 1; (1.05)^(1/12.0); (1.05)^(2/12.0) ])
end

@testset "generate plot data" begin
	@test reduce(hcat, Growth.portfolio_timeline.(1,3,[0 0])) ≈ [ cumsum([1.0; 1; 1]) cumsum([1.0; 1; 1]) ]
end
