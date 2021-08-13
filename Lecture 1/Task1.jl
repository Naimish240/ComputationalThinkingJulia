# First Lecture Task

using DataFrames
using CSV
using Plots
using Dates

function getData(df)
    # Finds India's index from dataframe
    i = findfirst(df[:, 2] .== "India")
    # Extract India's date-wise cases data
    india_row = df[i, 5:end]
    cases = [i for i in india_row]
    # Extract all dates
    date_strings = String.(names(df)[5:end])
    format = Dates.DateFormat("m/d/y")
    # Converts all date strings to date objects
    dates = parse.(Date, date_strings, format) + Year(2000)

    return dates, cases
end

function getWeeklyCount(cases)
    weeklyCases = Vector{Int64}()
    for i in 1:7:(length(cases) - length(cases)%7)
        push!(weeklyCases, cases[i])
    end
    return weeklyCases
end

# Load Data
df = CSV.read("covid19_dataset.csv", DataFrame)
dates, cases = getData(df)

weeklyData = getWeeklyCount(cases)
y_axis = dates[1:7:(length(cases) - length(cases)%7)]

weeklyDelta = [weeklyData[i]-weeklyData[i-1] for i in 2:length(weeklyData)]

plot(
    y_axis[2:end],
    weeklyDelta,
    xticks=dates[1:25:end],
    xrotation=45,
    leg=:topleft,
    label="India Data",
    xlabel="Week",
    ylabel="Weelky Confirmed Cases",
    title="Total Weekly Covid 19 Cases"
)
png("WeeklyCases.png")

casesTillWeek = [sum(weeklyDelta[1:i]) for i in 1:length(weeklyDelta)]

plot(
    # Starts from 7 to get rid of 0's
    casesTillWeek[7:end],
    weeklyDelta[7:end],
    leg=:topleft,
    m=:o,
    xscale=:log10, # Comment out for non log
    yscale=:log10, # Comment out for non
    label="India Data",
    xlabel="Log of Total Confirmed Cases",
    ylabel="Log of New Confirmed Cases (in past week)",
    title="Trajectory of Confirmed Covid Cases (log)"
)
png("WeeklyLogGrowthFraction.png")
