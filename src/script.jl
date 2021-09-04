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
defaultForecastRange = ForecastTimeRange(tdy, tdy+Dates.Year(10))

weekly_deposit(amt::Real; start=tdy, stop=nothing) = Growth.RegularDeposit(amt, start, stop, Dates.Week(1))
monthly_deposit(amt::Real; start=tdy, stop=nothing) = Growth.RegularDeposit(amt, start, stop, Dates.Month(1))
yearly_deposit(amt::Real; start=tdy, stop=nothing) = Growth.RegularDeposit(amt, start, stop, Dates.Year(1))

deposit_cases = [Growth.Budget(tdy, [monthly_deposit(2000, start=tdy), Growth.Deposit(20*10^3, tdy)])]

forecastRange = defaultForecastRange;

rates = range(.2, step=.2, stop=.8);

N = 100
sample_interval = (forecastRange.stop - forecastRange.start) / N;
ts=range(forecastRange.start, stop=forecastRange.stop, step=sample_interval)

ys = reduce(hcat, [Growth.portfolio_timeline(case, ts, apr) for case in deposit_cases, apr in rates]);

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

function plot(xs, ys, labels)
	plt = Plots.plot();
	Plots.plot!(plt, ts, ys,
		    size=(1800, 900),
		    xlim=(ts[begin], ts[end]),
		    #	    ylim=(50*10^3, 3*10^6),
		    #label = [ (monthly, apr) -> "($(monthly), $(apr*100))" for monthly in monthlies, apr in rates],
		   );
end

plot_it = plot(ts, ys, [])

Printf.@printf "\nRun `plot_it` to display the plot"
