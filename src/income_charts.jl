module Growth

import Dates
import Printf


struct Deposit
	amount::Real
	when::Dates.DateTime
end

struct RegularDeposit
	amount::Real
	start::Dates.DateTime
	stop::Union{Nothing, Dates.DateTime}
	every::Dates.Period
end
RegularDeposit(amt::Real; start::Dates.DateTime, stop::Dates.DateTime, every::Dates.Period) = RegularDeposit(amt, start, stop, every)

struct Budget 
	start::Dates.DateTime
	deposits::Vector{Union{RegularDeposit, Deposit}}
end

function compound(dep::Deposit, t::Dates.DateTime, apr::Float64)
	if t<dep.when
		return 0
	end
	dep.amount*(1+apr)^(Dates.year(t-dep.when))
end

function compound(dep::RegularDeposit, t::Dates.DateTime, apr::Float64)
	if t<dep.every
		return 0
	end
	dep.amount*(1+apr)^(Dates.year(t-dep.every))
end

function portfolio_timeline(budget::Budget, ts::AbstractVector{Dates.DateTime}, apr::Float64)
	deps = budget.deposits

	component_growth = [ compound.(d, ts, apr) for d in deps ];
	r = sum(component_growth, dims=2)
	return r
end

export portfolio_timeline 
end
