function [ logP, Q ] = viterbi ( O, Pi, A, B )
%FORWARD_BACKWARD computes the probability ... 
%   Input args:
%   O - the observed sequence
%   Pi - initial state probabilities

%   Output args:
%   Q - the most likely sequence of states that generated the observed
%   sequence

%   N - the number of states
%   M - the number of possible values for each observed variable
%   T - the length of the observed sequence

%   Pi is an 1 x N matrix
%   A is an N x N matrix
%   B is an N x M matrix
%   O is an 1 X T matrix

%   Q is an 1 x T matrix

N = size(Pi, 2);
% M = size(B, 2);
T = size(O, 2);

logA = log(A);
logB = log(B);

Q = zeros(1, T);

% delta = zeros(T, N);
psi = zeros(T, N);

% delta(1, :) = Pi .* B(:, O(1))';
phi(1, :) = log(Pi) + logB(:, O(1))';

% recursive part of this algorithm :)

for t=2:T
    %{
    [delta(t,:), psi(t,:)] = max(repmat(delta(t-1,:)',1,N).*A);
    % alternativ
    [delta(t,:), psi(t,:)] = max(diag(delta(t-1,:))*A);
    delta(t,:) = delta(t,:).* B(:,O(t))';
    %}    
    [phi(t,:), psi(t,:)] = max(repmat(phi(t-1,:)',1,N) + logA);
    phi(t,:) = phi(t,:) + logB(:,O(t))';
end

% [p, Q(T)] = max(delta(T,:));
[logP, Q(T)] = max(phi(T, :));

for t=(T-1):-1:1
    Q(t) = psi(t+1,Q(t+1));
end