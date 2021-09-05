include("../src/income_charts.jl")
import Configurations
import YAML
import Printf
import Plots
import Dates

###################################################
## Plotly
###################################################
Plots.plotly()

###################################################
## Gaston
###################################################
#import Gaston
#Plots.gaston()
#Gaston.set(term="x11")

###################################################
## UnicodePlots
###################################################
#Plots.unicodeplots()

###################################################
## GR
###################################################
#Plots.gr()

# helpers
tdy = Dates.today()

weekly_deposit(amt::Real; start=tdy) = RegularDeposit(amt, start, stop+Dates.Year(1000), Dates.Week(1))
monthly_deposit(amt::Real; start=tdy) = RegularDeposit(amt, start, start+Dates.Year(1000), Dates.Month(1))
yearly_deposit(amt::Real; start=tdy) = RegularDeposit(amt, start, stop+Dates.Year(1000), Dates.Year(1))

struct ForecastTimeRange
	start::Dates.DateTime
	stop::Dates.DateTime
end

# forecast timeline
forecastRange = ForecastTimeRange(tdy, tdy+Dates.Year(10))

# forecast budgets
budgets = [
	   Budget("3000 per month", tdy, [monthly_deposit(3000, start=tdy+Dates.Week(1)), Deposit(100*10^3, tdy)])
	   Budget("4000 per month", tdy, [monthly_deposit(4000, start=tdy+Dates.Week(1)), Deposit(100*10^3, tdy)])
	   Budget("5000 per month", tdy, [monthly_deposit(5000, start=tdy+Dates.Week(1)), Deposit(100*10^3, tdy)])
	  ]

# forecast APRs
rates = [
	 .1
	 .3
	 .5
	 ];

# plot data
ts = range(forecastRange.start, stop=forecastRange.stop, step=Dates.Week(1))

ys = reduce(hcat, [portfolio_timeline(case, ts, apr) for case in budgets, apr in rates]);

function plot(xs, ys, budget_names, rates)
	legend_names = map(tup-> "$(tup[1]) @ $(100*tup[2])% APR", [(x,y) for x in budget_names, y in rates])
	plt = Plots.plot();
	Plots.plot!(plt, xs, ys,
		    size=(2000, 1200),
		    yaxis=:log10,
		    ticks=:native,
		    legend=:outertopleft,
		    tickfont=16,
		    label = reshape(legend_names, 1, length(budget_names)*length(rates)),
		    legendfontsize=14,
		    linewidth=2,
		   );
end

plot_it = plot(ts, ys, map(x->x.name, budgets), rates)

Printf.@printf "\nRun `plot_it` to display the plot"
