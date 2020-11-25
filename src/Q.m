function pe = Q(x)
    pe = 0.5 .* erfc(x ./ sqrt(2));
end