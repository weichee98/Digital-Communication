% generate noise

function noise = noise_generator(N, mean, var)
    % generate noise with normal distribution    
    noise = sqrt(var) * randn(1, N) + mean;
end