function [alfa] = hmm_forward(O, T, E, pi)
% the function computes the forward variable alfa given independent multidimensional
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

for i=1:N
    idx_symbols = O(1, :);
    em_i = E(:, :, i);
    idx = sub2ind(size(em_i), idx_symbols, 1:R);
    alfa(1, i) = pi(i) * prod(em_i(idx));
end

% recurssion
for l = 2:L
    for j = 1:N
        s = alfa(l-1, :) * T(:, j);
        
        idx_symbols = O(l, :);
        em_j = E(:, :, j);
        idx = sub2ind(size(em_j), idx_symbols, 1:R);
        
        alfa(l, j) = s * prod(em_j(idx));
    end
end
