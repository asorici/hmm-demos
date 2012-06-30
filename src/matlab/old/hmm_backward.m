function [beta] = hmm_backward(O, T, E, pi)
% the function computes the backward variable beta given independent multidimensional
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
% the output is the matrix L x N beta matrix


% initialization
L = size(O, 1);
N = size(T, 1);
M = size(E, 1);
R = size(E, 2);

beta = ones(L, N);

% recurssion
for l = L-1:-1:1
    for i = 1:N
        s = T(i, :) * beta(l + 1, :)';
        
        idx_symbols = O(l + 1, :);
        em_i = E(:, :, i);
        idx = sub2ind(size(em_i), idx_symbols, 1:R);
        
        beta(l, i) = s * prod(em_i(idx));
    end
end