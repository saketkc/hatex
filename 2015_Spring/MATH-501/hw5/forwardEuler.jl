N = 100
h = 1.0/N
y = zeros(N)
y[1] = 0
t = linrange(0,2,N)

function func(t,x)
    return x^(1/3.0)
end

for i=1:N-1
    y[i+1] = y[i] + h*func(t[i], y[i])
end
println("y", "  ", "y(t)", "  ", "Error")
for i=1:N
    println(t[i]^(3/2.0), "  ", y[i], " ", abs(t[i]^1.5-y[i])/t[i]^1.5)
end
