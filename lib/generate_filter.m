
function pdFlt = generate_filter(d, n)

pdFlt = zeros(2*n - 1, 1);

for i = -(n-1):n-1
    if i ~= 0
        if (mod(i, 2))
            pdFlt((n-1) + i+1) = -1/((i*pi*d)*(i*pi*d));
        end
    else
        pdFlt((n-1) + i+1) = 1/(4*d*d);
    end
end

end