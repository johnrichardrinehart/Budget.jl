module Growth

import Dates

day_per_year = 365.24219
hour_per_day= 24
min_per_hour = 60
sec_per_min = 60
ms_per_s = 1000

ms_per_year = day_per_year*hour_per_day*min_per_hour*sec_per_min*ms_per_s

struct Deposit
	amount::Real
	when::Dates.DateTime
end
Broadcast.broadcastable(x::Deposit) = Ref(x) # Broadcast as a scalar

struct RegularDeposit
	amount::Real
	start::Dates.DateTime
	stop::Union{Dates.DateTime}
	every::Dates.Period
end
RegularDeposit(amt::Real; start::Dates.DateTime, stop::Dates.DateTime, every::Dates.Period) = RegularDeposit(amt, start, stop, every)
Broadcast.broadcastable(x::RegularDeposit) = Ref(x) # Broadcast as a scalar

struct Budget 
	name::String
	start::Dates.DateTime
	deposits::Vector{Union{RegularDeposit, Deposit}}
end

function compound(dep::Deposit, t::Dates.DateTime, apr::Real)
	if t<dep.when
		return 0
	end
	nms = (t-dep.when)
	n = nms.value/ms_per_year
	dep.amount*(1+apr)^n
end

function compound(dep::RegularDeposit, t::Dates.DateTime, apr::Real)
	if t < dep.start
		return 0
	end
	res = 0
	for i in dep.start:dep.every:min(dep.stop,t)
		nms = t-i # how long has it been
		n = nms.value/ms_per_year
		res += dep.amount*(1+apr)^n # how much has it compounded
	end
	return res
end

function portfolio_timeline(budget::Budget, ts::AbstractVector{Dates.DateTime}, apr::Real)
	component_growth = map(d->compound.(d, ts, apr), budget.deposits);
	r = reduce(+, component_growth)
	return r
end

export portfolio_timeline 

end
