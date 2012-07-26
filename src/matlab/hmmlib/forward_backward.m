function [ P, alpha, beta, scale ] = forward_backward( O, Pi, A, B )
%FORWARD_BACKWARD computes the probability ... 
%   Input args:
%   O - the observed sequence
%   Pi - initial state probabilities


%   N - the number of states
%   M - the number of possible values for each observed variable
%   T - the length of the observed sequence

%   Pi is an 1 x N matrix
%   A is an N x N matrix
%   B is an N x M matrix
%   O is an 1 X T matrix

%   alpha is an T x N
%   beta is an T X N

N = size(Pi, 2);
M = size(B, 2);
T = size(O, 2);

scale = zeros (1, T);
alpha = zeros (T, N);
beta = ones (T, N);

alpha(1,:) = Pi .* B(:, O(1))';
scale(1) = sum(alpha(1, :));
alpha(1,:) = alpha(1, :) / scale(1);

for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* B(:, O(t))';
    scale(t) = sum(alpha(t, :));
    alpha(t, :) = alpha(t, :) / scale(t);
end

beta(T, :) = beta(T, :) / scale(T);
for t = (T-1):-1:1
    beta(t,:) = A * (B(:,O(t+1)) .* beta(t+1,:)');
    beta(t, :) = beta(t, :) / scale(t);
end
%scale = ones(size(scale)) ./ scale;
P = prod(scale);
