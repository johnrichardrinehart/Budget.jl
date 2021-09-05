include("income_charts.jl")
import .Growth

import Configurations
import YAML
import Printf
import Plots
import Dates

###################################################
## Plotly
###################################################
Plots.plotly()
#   ###################################################
#   ## Gaston
#   ###################################################
#   #import Gaston
#   #Plots.gaston()
#   #Gaston.set(term="x11")
#   
#   ###################################################
#   ## UnicodePlots
#   ###################################################
#   #Plots.unicodeplots()
#   
#   ###################################################
#   ## GR
#   ###################################################
#   #Plots.gr()


struct ForecastTimeRange
	start::Dates.DateTime
	stop::Dates.DateTime
end

tdy = Dates.today()
defaultForecastRange = ForecastTimeRange(tdy, tdy+Dates.Year(20))

weekly_deposit(amt::Real; start=tdy) = Growth.RegularDeposit(amt, start, stop+Dates.Year(1000), Dates.Week(1))
monthly_deposit(amt::Real; start=tdy) = Growth.RegularDeposit(amt, start, start+Dates.Year(1000), Dates.Month(1))
yearly_deposit(amt::Real; start=tdy) = Growth.RegularDeposit(amt, start, stop+Dates.Year(1000), Dates.Year(1))

#budgets = [Growth.Budget(tdy, [monthly_deposit(5000, start=tdy+Dates.Month(1))])]
budgets = [
#	   Growth.Budget("3000 per month", tdy, [monthly_deposit(5000, start=tdy+Dates.Week(1)), Growth.Deposit(100*10^3, tdy)])
	   Growth.Budget("4000 per month", tdy, [monthly_deposit(4000, start=tdy+Dates.Week(1)), Growth.Deposit(100*10^3, tdy)])
	   Growth.Budget("5000 per month", tdy, [monthly_deposit(5000, start=tdy+Dates.Week(1)), Growth.Deposit(100*10^3, tdy)])
	  ]

forecastRange = defaultForecastRange;

#rates = range(.1, step=.1, stop=.1);
rates = [
	 .1
	 .3
	 .5
	 ];

ts = range(forecastRange.start, stop=forecastRange.stop, step=Dates.Day(1))

ys = reduce(hcat, [Growth.portfolio_timeline(case, ts, apr) for case in budgets, apr in rates]);


#   ###################################################
#   ## Configuration File Unmarshalling
#   ###################################################
#   
#   Configurations.@option struct ConfigIncome
#       initial_investment::Float64
#       yearly_income::Float64
#       tax_rate::Float64
#       monthly_expenses::Float64
#       monthly_expenses_flex::Float64
#       monthly_investments::Union{Nothing,Vector{Float64}}
#       compound_interval::Float64
#       years::Float64
#       rates::Vector{Float64}
#   end
#   
#   data = YAML.load_file("config.yml", dicttype=Dict{String, Any})
#   conf = Configurations.from_dict(ConfigIncome, data)
#   
#   
#   ###################################################
#   ## Generating necessary variables
#   ###################################################
#   # income
#   initial_investment=conf.initial_investment
#   yearly_income=conf.yearly_income
#   
#   # expenses
#   tax_rate=conf.tax_rate
#   monthly_expenses=conf.monthly_expenses
#   monthly_expenses_flex=conf.monthly_expenses_flex # amount of under/overestimating monthly expenses
#   
#   # timelines
#   num_years=conf.years
#   interval = conf.compound_interval # how often to compound interest
#   
#   # rates
#   rates = conf.rates
#   
#   ## Calculations
#   times = 0:interval:num_years
#   
#   # monthly calcs
#   monthly_income = (conf.yearly_income*(1-conf.tax_rate))/12
#   monthly_deposit_minimum=monthly_income-(monthly_expenses+monthly_expenses_flex) # underestimated monthly expenses
#   monthly_deposit_maximum=monthly_income-(monthly_expenses-monthly_expenses_flex) # overestimated monthly expenses

struct Ylabel
	value::Real
end

function plot(xs, ys, budget_names, rates)
	print(budget_names)
	plt = Plots.plot();
	Plots.plot!(plt, xs, ys,
		    size=(2000, 1200),
#		    yticks=map(x-> Ylabel(x), [0, 50*10^3, 1*10^6]),
		    ticks=:native,
		    legend=:topleft,
		    tickfont=16,
		    label = reshape(map(tup-> "$(tup[1]) @ $(tup[2])", [(x,y) for x in budget_names, y in rates]),1,length(budget_names)*length(rates)),
		    #label = [ (name, apr) -> "$(name) @ $(apr*100)" for name in budget_names, apr in rates],
#		    label = [ (name) -> "$(name) @ " for name in budget_names],
		   );
end

plot_it = plot(ts, ys, map(x->x.name, budgets), rates)

Printf.@printf "\nRun `plot_it` to display the plot"
