using Plots

function plotResult(res, title)
    plot(
        res,
        m=:o,
        label="I[n]",
        legend=:topleft,
        title=title
    )
end

function simpleExponentialModel(I₀=1, λ=1.01, T=10)
#=
    I₀ : Number of people initially infected
    λ  : Number of people each infected person can infect
    T  : Timesteps to run the simulation for

    Equation:
        I_n+1 = I_n + c * I_n
            => I_n+1 = λ I_n
    This isn't a very good model, because it assumes infinite population
=#
    I = zeros(T)
    I[1] = I₀
    for n in 1:T-1
        I[n+1] = I[n] * λ
    end
    return I
end

function simpleExponentPlots()
    methods(simpleExponentialModel)
    # For small T, model looks linear
    result = simpleExponentialModel()
    plotResult(result, "Small T")
    png("Small T Exponential.png")

    # For large T, graph becomes more obviously exponential
    plotResult(simpleExponentialModel(1, 1.01, 150), "Large T")
    png("Large T Exponential.png")
end

simpleExponentPlots()

function simpleLogisticModel(I₀=1, p=0.01, α=0.01, N=1000, T=20)
#=
    I₀ : Number of people initially infected
    p  : Probability of infecting a person at contact
    α  : Fraction of people each person is in contact with
    N  : Size of population
    T  : Timesteps to run the simulation for

    Equation:
        I_n+1 = I_n + [p * α (N - I_n)] * I_n
            => I_n+1 = I_n + β(I_n, S_n); where,
                I_n : infected
                S_n : susceptible == N - I_n
    This is a decent model, because you can only infect uninfected people
=#
    β(I, S) = p*α*S
    I = zeros(T)
    I[1] = I₀
    for n in 1:T-1
        S = N - I[n]
        I[n+1] = I[n] + β(I[n], S) * I[n]
    end
    return I
end

function simpleLogisticPlot()
    results = simpleLogisticModel()
    plotResult(results, "Small T Logistic")
    png("Small T Logistic.png")
    results = simpleLogisticModel(1, 0.01, 0.01, 1000, 250)
    plotResult(results, "Large T Logistic")
    png("Large T Logistic.png")
end

simpleLogisticPlot()
