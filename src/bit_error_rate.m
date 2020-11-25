% calculate bit error rate by comparing transmitted and received signal

function error = bit_error_rate(transmit, received, threshold)
    N = length(transmit);
    if (length(received) ~= N)
        ME = MException('length of transmitted signal and received signal is different');
        throw(ME)
    end
    transmit_decoded = threshold_logic(transmit, threshold);
    received_decoded = threshold_logic(received, threshold);
    error = sum(transmit_decoded ~= received_decoded) / N;
%     error = 0;
%     for i = 1: N
%         if (transmit_decoded(i) ~= received_decoded(i))
%             error = error + 1;
%         end
%     end
%     error = error / N;
end