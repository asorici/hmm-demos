function [logP, Alpha, Beta, Scale] = forward_backward_multi_disc( O, Pi, A, B )
% computes forward and backward variables for a discrete observation sequence
%
% usage [logP, Alpha, Beta, Scale] = forward_backward_multi_disc( O, Pi, A, B )
%
% FORWARD_BACKWARD_MULTI_DISC computes the forward and backward variables for a
% discrete observation sequence and a given HMM (PI, A, B). The values of
% ALPHA and BETA are scaled in order to avoid exceeding the precision range.
% The function deals with multi-dimensional independent sequences.
% It uses forward_backward_disc.
%
% Input args:
% O :   an R x T matrix containing the observation sequence, 
%       where R is the dimensionality of the observed variable
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(Q(1)=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(Q(t+1)=Sj | Q(t) = Si)
% B :   an N x M matrix if R = 1 or an N x M x R if R > 1 for the observation values probability distribution
%       in each state
%       B(j,k) = P(O(t)=V(k) | Q(t) = Sj) if R = 1
%       B(j, k, r) = P(O(r, t) = V(k, r) | Q(t) = Sj) if R > 1
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

%%   Initialization
N = size(Pi, 2);
T = size(O, 2);
R = size(O, 1);

%   check the equality in dimensions between O and B
if size(B, 3) ~= R
    error('forward_backward:dimensionCheck', ... 
          'The row dimension %d of O and the depth dimension %d of B do not agree', R, size(B, 3));
end

%%  The uni-dimensional case
if R == 1
    [logP, Alpha, Beta, Scale] = forward_backward_disc(O, Pi, A, B);
else
%%  The multi-dimensional case
    % precompute the multiplication of the multi-dimensional
    % independent observation probabilities for each state
    B_prod = ones(N, T);
    for t = 1 : T
        obs_symbol_idx = O(:, t)';
        for r = 1 : R
            b_idx = sub2ind(size(B), 1:N, ...
                repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
            B_prod(:, t) = B_prod(:, t) .* B(b_idx)';
        end
    end
    
    [logP, Alpha, Beta, Scale] = forward_backward_disc(1:T, Pi, A, B_prod);
end
