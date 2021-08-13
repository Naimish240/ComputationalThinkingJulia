# First Lecture Video

using Printf
using Downloads
using DataFrames
using CSV
using Plots
using Dates

# Download the data
function downloadData()
    url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    println("... Reading from URL : ", url)
    # Download url
    Downloads.download(url, "covid19_dataset.csv")
    println("... Data downloaded successfully")
end

downloadData()

df = CSV.read("covid19_dataset.csv", DataFrame)
typeof(df)

rename!(df, 1 => "province", 2 => "country") # Modify in place

countries = unique(df[:, 2]) # Extract all countries from 2nd column, as vector (1d array)

for i in countries
    @show i # Uses macro to show values
end

# Finds India's index from dataframe
i = findfirst(df[:, 2] .== "India")
# Extract India's date-wise data
india_row = df[i, 5:end]

cases = [i for i in india_row]

plot(cases)

date_strings = String.(names(df)[5:end])
format = Dates.DateFormat("m/d/y")

# Converts all date strings to date objects
dates = parse.(Date, date_strings, format) + Year(2000)

# Plot with dates
plot(dates, data)

plot(
    dates,
    data,
    xticks=dates[1:25:end],
    xrotation=45,
    leg=:topleft,
    label="India Data",
    xlabel="Date",
    ylabel="Confirmed Cases",
    title="Total Covid 19 Cases"
)
png("Total Cases.png")

# Data from day 9, because 0 cases for previous days
plot(
    dates[9:end],
    data[9:end],
    xticks=dates[1:25:end],
    xrotation=45,
    leg=:topleft,
    label="India Data",
    yscale=:log10,
    xlabel="Date",
    ylabel="Confirmed Cases",
    title="Total Covid 19 Cases (SemiLog)"
)
png("Semilog Total Cases.png")
