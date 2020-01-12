% Ch.3 Equation (3.29)
% Generate filter kernel
function pdFlt = generate_filter(d, n)

pdFlt = zeros(2*n - 1, 1, 'single');

for i = -(n-1):n-1
    if i == 0
        pdFlt((n-1) + i+1) = 1/(4*d*d);
    else
        if (mod(i, 2)) == 0
            pdFlt((n-1) + i+1) = 0;
        else
            pdFlt((n-1) + i+1) = -1/((i*pi*d)*(i*pi*d));
        end
    end
end

pdFlt = d * pdFlt;

end