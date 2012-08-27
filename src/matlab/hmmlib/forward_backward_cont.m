function [P,Alpha,Beta,Scale] = forward_backward_cont(O,Pi,A,C,MU,SIGMA)
%FORWARD_BACKWARD_CONT computes the forward and backward variables for a
%continuous observation sequence and a given HMM (Pi, A, B). The value sof
%Alpha and Beta are scaled in order to avoid exceeding the precision range.
%   
% Input args:
% O :       an 1 x T matrix containing the observation sequence
% Pi :      an 1 x N matrix containing the initial state distribution
%           Pi(j) = P(Q(1)=Sj) for 1 =< j =< N
% A :       an N x N matrix for the state transition probability
%           distribution
%           A(i,j) = P(Q(t+1)=Sj | Q(t)=Si)
% C :       an N x M matrix containing the weights for the gaussian mixture
%           components in each state
% MU :      an N x M x R matrix containing the meam vectors for each
%           gaussian mixture component in each state
% SIGMA :   an N x M x R X R matrix containing the covariance matrix for 
%           each gaussian mixture component in each state
%
% Output args:
% P :       the probability of the observation sequence, given the HMM
% Alpha :   a T x N matrix containing the forward variables                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
%           Alpha(t,i) = P(O(1),O(2),...,O(t),Q(t)=Si | Lambda)
% Beta :    a T x N matrix containing the backward variables
%           for each time instance 1 <= t <= T and each state 1 <= i <= N
%           Beta(t,i) = P(O(t+1),O(t+2),...O(T) | Q(t)=Si,Lambda)
% Scale :   an 1 x T matrix containing the scaling coefficients
%           Scale(t) = 1 / (Alpha(t,1) +... Alpha(t,N))
% Other vars:
% N :       the number of states in the HMM
% M :       the number of gaussian mixture components
% T :       the length of the observation sequence
% R :       the number of considered dimensions for the observation signal
%
%  Tudor Berariu, Alexandru Sorici, Iulie 2012

%% Initialization

N = size(Pi, 2);
M = size(C, 2);
T = size(O, 2);

Scale = zeros (1, T);
Alpha = zeros (T, N);
Beta = ones (T, N);

%% Compute matrix B (as in the discrete case)
B = zeros(N, T);
for i = 1:N
    for t=1:T
        B(i,t) = mixture_fun(O(t,:),i,C,MU,SIGMA);
    end
end

%% Compute Alpha
Alpha(1,:) = Pi .* B(:, 1)';
Scale(1) = 1 / sum(Alpha(1, :));
Alpha(1,:) = Alpha(1, :) * Scale(1);

for t = 2:T
    Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:,t)';
    Scale(t) = 1 / sum(Alpha(t, :));
    Alpha(t, :) = Alpha(t, :) * Scale(t);
end

%% Compute Beta
Beta(T, :) = Beta(T, :) * Scale(T);
for t = (T-1):-1:1
    Beta(t,:) = A * (B(:,t+1) .* Beta(t+1,:)');
    Beta(t, :) = Beta(t, :) * Scale(t);
end

%% The probability of the observed sequence
P = 1 / prod(Scale);
