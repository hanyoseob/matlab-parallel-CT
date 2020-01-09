
function y = convolution1d(x, ker, n)
y = zeros(n, 1);

for i = 0:n-1
    for j = 0:n-1
        y(i+1) = y(i+1) + ker(((n-1) + i+1) - (j+1) + 1)*x(j+1);
    end
end
end