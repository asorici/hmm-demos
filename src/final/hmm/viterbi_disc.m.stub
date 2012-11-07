function [ logP, Q ] = viterbi_disc( O, Pi, A, B )
% finds the best path that explains O and its logP using Viterbi algorithm
%
% usage: [ logP, Q ] = viterbi_disc( O, Pi, A, B )
%
% VITERBI_DISC computes the path Q that maximizes P(O|Q,A,B,Pi). 
% The values of Delta are scaled in order to avoid exceeding 
% the precision range.
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
% logP :    the logarithm of the probability of the observation sequence,
%           given the HMM
% Q :       an 1 x T matrix containing the sequence of states (best path)
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

%% Initialization

N = size(Pi, 2); % The number of states in the model
T = size(O, 2); % The number of observations in the sequence O

logA = log(A); 
logB = log(B); 

Q = zeros(1, T); % Q is a 1 x T matrix (see above)

Psi = zeros(T, N); % Psi is  a T x N matrix
Phi = zeros(T, N); % Phi(t,i) = max{log P(q1,...,qt,o1,...,ot|A,B,Pi)}

Phi(1, :) = log(Pi) + logB(:, O(1))'; % Initialization for Phi (t = 1)

%% Recursion
% phi_psi_disc-start
for t=2:T
    [Phi(t,:), Psi(t,:)] = max(repmat(Phi(t-1,:)',1,N) + logA);
    Phi(t,:) = Phi(t,:) + logB(:,O(t))';
end
% phi_psi_disc-end

%% logP
[logP, Q(T)] = max(Phi(T, :));

%% Backtracking to compute the path Q
% path_disc-start - Write code below
for t=(T-1):-1:1
    Q(t) = Psi(t+1,Q(t+1));
end
% path_disc-end - Write code below