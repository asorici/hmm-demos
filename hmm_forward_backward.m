function [alfa, beta] = hmm_forward_backward(O, T, E, pi)

% the function computes the forward variable alfa and backward variable beta 
% given multidimensional
% observations O, transition matrix T, emission probabilties E and initial
% state estimations pi. The observation matrix is given as an L x R
% matrix where:
% R - the number of dimensions
% L - the length of the observation sequence along each dimension
% the values are the indices of the codevectors in the codebook for each
% dimension
%
% T is an N x N matrix, where N is the number of states
% E is an M x R x N matrix, where R is the number of dimensions, M is the
%   number of discrete symbols and N is the number of states
% pi is an array of N elements 
%
% the output is the matrix L x N alfa matrix


% initialization
L = size(O, 1);
N = size(T, 1);
M = size(E, 1);
R = size(E, 2);

alfa = zeros(L, N);
beta = ones(L, N);
scale = zeros(1, L);

for i=1:N
    idx_symbols = O(1, :);
    em_i = E(:, :, i);
    idx = sub2ind(size(em_i), idx_symbols, 1:R);
    alfa(1, i) = pi(i) * prod(em_i(idx));
end

scale(1, 1) = 1.0 / sum(alfa(1, :));
alfa(1, :) = alfa(1, :) * scale(1, 1);

% recurssion
for l = 2:L
    %lb = L + 1 - l;
    for j = 1:N
        sa = alfa(l-1, :) * T(:, j);
        %sb = T(j, :) * beta(lb + 1, :)';
        
        idx_symbols_alfa = O(l, :);
        %idx_symbols_beta = O(lb + 1, :);
        em_j = E(:, :, j);
        
        idx_alfa = sub2ind(size(em_j), idx_symbols_alfa, 1:R);
        %idx_beta = sub2ind(size(em_j), idx_symbols_beta, 1:R);
        
        alfa(l, j) = sa * prod(em_j(idx_alfa));
        %beta(lb, j) = sb * prod(em_j(idx_beta));
    end
    
    scale(1, l) = 1.0 / sum(alfa(l, :));
    alfa(l, :) = alfa(l, :) * scale(1, l);
end


% ----- backward -----
beta(L, :) = beta(L, :) * scale(1, L);

for l = L-1:-1:1
    for i = 1:N
        s = T(i, :) * beta(l + 1, :)';
        
        idx_symbols = O(l + 1, :);
        em_i = E(:, :, i);
        idx = sub2ind(size(em_i), idx_symbols, 1:R);
        
        beta(l, i) = s * prod(em_i(idx));
    end
    beta(l, :) = beta(l, :) * scale(1, l);
end
