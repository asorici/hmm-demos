function [P, Alpha, Beta, Scale] = forward_backward_disc(O, Pi, A, B)
% computes forward and backward variables for a discrete observation sequence
%
% usage: [P, Alpha, Beta, Scale] = forward_backward_disc(O, Pi, A, B)
%
% FORWARD_BACKWARD_DISC computes the forward and backward variables for a
% discrete observation sequence and a given HMM (PI, A, B). The values of
% ALPHA and BETA are scaled in order to avoid exceeding the precision range.
%
% Input args:
% O :   an 1 x T matrix containing the observation sequence
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(Q(1)=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(Q(t+1)=Sj | Q(t) = Si)
% B :   an N x M matrix for the observation values probability distribution
%       in each state
%       B(j,k) = P(O(t)=V(k) | Q(t) = Sj)
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
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

%% Initialization

N = size(Pi, 2); % The number of states in the model
T = size(O, 2); % The number of observations in the sequence O

Scale = zeros (1, T); % Scale is an 1 x T matrix (see above)
Alpha = zeros (T, N); % Alpha is a T x N matrix (see above)
Beta = ones (T, N); % Beta is a T x N matrix (see above)

%% Forward variables
% alpha_disc-start - Write code below

Alpha(1,:) = Pi .* B(:, O(1))';
Scale(1) = 1 / sum(Alpha(1, :));
Alpha(1,:) = Alpha(1, :) * Scale(1);

for t = 2:T
    Alpha(t,:) = (Alpha(t-1,:) * A) .* B(:, O(t))';
    Scale(t) = 1 / sum(Alpha(t, :));
    Alpha(t, :) = Alpha(t, :) * Scale(t);
end

% alpha_disc-end - Write code above

%% Backward variables
% beta_disc-start - Write code below

Beta(T, :) = Beta(T, :) * Scale(T);
for t = (T-1):-1:1
    Beta(t,:) = A * (B(:,O(t+1)) .* Beta(t+1,:)');
    Beta(t, :) = Beta(t, :) * Scale(t);
end

% beta_disc-end - Write code above

%% The probability of the observed sequence
% prob_disc-start - Write code below

P = 1 / prod(Scale);

% prob_disc-end - Write code above