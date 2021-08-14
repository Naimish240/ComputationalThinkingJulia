using Random
using Plots
using Statistics

# Set random number seed
Random.seed!(42)
num_exp = 10^5

# Generate 100 random numbers and plot them
r = rand(100)
scatter(r)
png("Random Scatter.png")

# Function to generate bernoulli trial for a given probability
function bernoulli(p)
    return rand() < p
end

# Function to perform multiple bernoulli trials and return number of times trial was true
function bernoulliTrials(p, N=100)
    trials = [bernoulli(p) for _ in 1:N]
    return count(trials)
end

trials = bernoulliTrials(0.15)

# Runs a random process many times and looks at result
function MonteCarloSim(p=0.25, N=20, num_exp=10000)
    result = [bernoulliTrials(p, N) for _ in 1:num_exp]
    return result
end
result = MonteCarloSim(0.25, 20, 100)
scatter(result)
png("MonteCarlo Scatter.png")

# Probability Distribution of Random Variable
# Options to store data are
#    1. Dictionary
#    2. Vector
# Dictionary is homework, Vector implemented here
function freqDist(results)
    high = maximum(results)
    dist = zeros(Int16, high+1)
    for i in results
        dist[i+1] += 1
    end
    return dist
end

dist = freqDist(result)
plot(
    0:length(dist)-1, # Shifting by -1 because 1 based indexing
    dist,
    xlims=(minimum(result)-2, maximum(result)+1),
    m=:o,
    title="Frequency Distribution"
)
png("Frequency Distribution.png")

probDist = dist ./ num_exp
sum(probDist)
#=
# To take fraction sums, do this
probDist = dist .// num_exp
sum(probDist)
=#

mean(result) # Expected mean value = n*P
mean(dist)
mean(probDist)
