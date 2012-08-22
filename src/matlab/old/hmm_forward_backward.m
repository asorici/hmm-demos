function [alfa, beta, scale] = hmm_forward_backward(O, T, E, pi)

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
% E is an M x N x R matrix, where R is the number of dimensions, M is the
%   number of discrete symbols and N is the number of states
% pi is an array of N elements 
%
% the output are the L x N alfa and beta matrices, as well as the scale
% vector


% initialization
L = size(O, 1);
N = size(T, 1);
M = size(E, 1);
R = size(E, 3);

alfa = zeros(L, N);
beta = ones(L, N);
scale = zeros(1, L);

%{
for i=1:N
    idx_symbols = O(1, :);
    em_i = E(:, :, i);
    idx = sub2ind(size(em_i), idx_symbols, 1:R);
    alfa(1, i) = pi(i) * prod(em_i(idx));
end
%}

for i=1:N
    idx_symbols = O(1, :);
    prod_r = 1;
    for r = 1 : R
        prod_r = prod_r * E(idx_symbols(1, r), i, r);
    end
    alfa(1, i) = pi(i) * prod_r;
end

scale(1, 1) = sum(alfa(1, :));
alfa(1, :) = alfa(1, :) / scale(1, 1);

% recurssion
for l = 2:L
    %lb = L + 1 - l;
    for j = 1:N
        sa = alfa(l-1, :) * T(:, j);
        
        idx_symbols_alfa = O(l, :);
        %em_j = E(:, :, j);
        %idx_alfa = sub2ind(size(em_j), idx_symbols_alfa, 1:R);
        
        prod_r = 1;
        for r = 1 : R
            prod_r = prod_r * E(idx_symbols_alfa(1, r), j, r);
        end
        
        %alfa(l, j) = sa * prod(em_j(idx_alfa));
        alfa(l, j) = sa * prod_r;
    end
    
    scale(1, l) = sum(alfa(l, :));
    alfa(l, :) = alfa(l, :) / scale(1, l);
end


% ----- backward -----
beta(L, :) = beta(L, :) / scale(1, L);

for l = L-1:-1:1
    idx_symbols = O(l + 1, :);
    for i = 1:N
        %{
        s = T(i, :) * beta(l + 1, :)';
        idx_symbols = O(l + 1, :);
        
        %em_i = E(:, :, i);
        %idx = sub2ind(size(em_i), idx_symbols, 1:R);
        prod_r = 1;
        for r = 1 : R
            prod_r = prod_r * E(idx_symbols(1, r), i, r);
        end
        
        %beta(l, i) = s * prod(em_i(idx));
        beta(l, i) = s * prod_r;
        %}
        beta(l, i) = 0;
        for j = 1 : N
            s_elem = T(i, j) * beta(l + 1, j);
            
            prod_r = 1;
            for r = 1 : R
                prod_r = prod_r * E(idx_symbols(1, r), j, r);
            end
            
            s_elem = s_elem * prod_r;
            beta(l, i) = beta(l, i) + s_elem;
        end
    end
    
    beta(l, :) = beta(l, :) / scale(1, l);
end
