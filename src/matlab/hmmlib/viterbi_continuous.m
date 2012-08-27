function [ logP, Q ] = viterbi_continuous ( O, Pi, A, C, MU, SIGMA)
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
%   mixture_fun is a function defined elsewhere
%   O is an T x R matrix

%   Q is an 1 x T matrix

N = size(Pi, 2);
% M = size(B, 2);
T = size(O, 2);

logA = log(A);

Q = zeros(1, T);

% delta = zeros(T, N);
psi = zeros(T, N);

% delta(1, :) = Pi .* B(:, O(1))';
phi = zeros(T, N);
for i=1:N
    phi(1, i) = log(Pi(i)) + log(mixture_fun(O(1,:),i, C, MU, SIGMA));
end


%% recursive part of this algorithm :)

for t=2:T
    %{
    [delta(t,:), psi(t,:)] = max(repmat(delta(t-1,:)',1,N).*A);
    % alternativ
    [delta(t,:), psi(t,:)] = max(diag(delta(t-1,:))*A);
    delta(t,:) = delta(t,:).* B(:,O(t))';
    %}    
    [phi(t,:), psi(t,:)] = max(repmat(phi(t-1,:)',1,N) + logA);
    for i=1:N
        phi(t,i) = phi(t,i) + log(mixture_fun(O(t,:),i,C, MU, SIGMA));
    end
end

% [p, Q(T)] = max(delta(T,:));
[logP, Q(T)] = max(phi(T, :));

for t=(T-1):-1:1
    Q(t) = psi(t+1,Q(t+1));
end