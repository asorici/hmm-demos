function [ P, alpha, beta, scale ] = forward_backward_continuous( O, Pi, A, C, MU, SIGMA)
%FORWARD_BACKWARD computes the probability ... 
%   Input args:
%   O - the observed sequence
%   Pi - initial state probabilities
%   MU - the meam vectors for each gaussian mixture component in each state
%   SIGMA - the covariance matrix for each gaussian mixture component in
%           each state
%
%
%   N - the number of states
%   M - the number of gaussian mixture components
%   T - the length of the observed sequence
%   R - the number of considered dimensions for the observation signal
%
%   Pi is an 1 x N matrix
%   A is an N x N matrix
%   O is an T X R matrix
%   C is an N x M
%   MU is an N x M x R matrix
%   SIGMA is an N x M x R x R matrix

%   alpha is an T x N
%   beta is an T X N

N = size(Pi, 2);
M = size(C, 2);
T = size(O, 2);

scale = zeros (1, T);
alpha = zeros (T, N);
beta = ones (T, N);

B = zeros(N, T);
for i = 1:N
    for t=1:T
        B(i,t) = mixture_fun(O(t,:),i,C,MU,SIGMA);
    end
end

alpha(1,:) = Pi .* B(:, 1)';
scale(1) = sum(alpha(1, :));
alpha(1,:) = alpha(1, :) / scale(1);

for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* B(:,t)';
    scale(t) = sum(alpha(t, :));
    alpha(t, :) = alpha(t, :) / scale(t);
end

beta(T, :) = beta(T, :) / scale(T);
for t = (T-1):-1:1
    beta(t,:) = A * (B(:,t+1) .* beta(t+1,:)');
    beta(t, :) = beta(t, :) / scale(t);
end

%scale = ones(size(scale)) ./ scale;
P = prod(scale);
