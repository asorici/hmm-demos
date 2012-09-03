function [ P, alpha, beta, scale ] = forward_backward( O, Pi, A, B )
% FORWARD_BACKWARD computes the forward and backward variables for an
% observation sequence and a given HMM (Pi, A, B). The values of Alpha and
% Beta are scaled in order to avoid exceeding the precision range.
%
% Input args:
% O :   an R x T matrix containing the observation sequence, where R is the dimensionality of the observed variable
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(Q(1)=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(Q(t+1)=Sj | Q(t) = Si)
% B :   an N x M matrix if R = 1 or an N x M x R if R > 1 for the observation values probability distribution
%       in each state
%       B(j,k) = P(O(t)=V(k) | Q(t) = Sj) if R = 1
%       B(j, k, r) = P(O(r, t) = V(k, r) | Q(t) = Sj) if R > 1
%
% Output args
% P :       the probability of the observation sequence, given the HMM
% Alpha :   a T x N matrix containing the forward variables
%           Alpha(t,i) = P(O(1),O(2),...,O(t),Q(t)=Si | Lambda)
% Beta :    a T x N matrix containing the backward variables
%           for each time instance 1 <= t <= T and each state 1 <= i <= N
%           Beta(t,i) = P(O(t+1),O(t+2),...O(T) | Q(t)=Si,Lambda)
% Scale :   an 1 x T matrix containing the scaling coefficients
%           Scale(t) = 1 / (Alpha(t,1) +... Alpha(t,N))

%{  
    The function distinguishes programmatically between the uni-dimensional
    and multi-dimensional independent observation sequences
%}

%%   Initialization
N = size(Pi, 2);
M = size(B, 2);
T = size(O, 2);
R = size(O, 1);

scale = zeros (1, T);
alpha = zeros (T, N);
beta = ones (T, N);

%   check the equality in dimensions between O and B
if size(B, 3) ~= R
    error('forward_backward:dimensionCheck', ... 
          'The row dimension %d of O and the depth dimension %d of B do not agree', R, size(B, 3));
end

%%  The uni-dimensional case
if R == 1
    alpha(1,:) = Pi .* B(:, O(1))';
    %scale(1) = sum(alpha(1, :));
    %alpha(1,:) = alpha(1, :) / scale(1);
    scale(1) = 1 ./ sum(alpha(1, :));
    alpha(1,:) = alpha(1, :) * scale(1);

    for t = 2:T
        alpha(t,:) = (alpha(t-1,:) * A) .* B(:, O(t))';
        %scale(t) = sum(alpha(t, :));
        %alpha(t, :) = alpha(t, :) / scale(t);
        scale(t) = 1 ./ sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) * scale(t);
    end

    %beta(T, :) = beta(T, :) / scale(T);
    beta(T, :) = beta(T, :) * scale(T);
    for t = (T-1):-1:1
        beta(t,:) = A * (B(:,O(t+1)) .* beta(t+1,:)');
        %beta(t, :) = beta(t, :) / scale(t);
        beta(t, :) = beta(t, :) * scale(t);
    end
    %scale = ones(size(scale)) ./ scale;
    %P = prod(scale);
    %P = sum(log(scale));
    P = -sum(log(scale));
    
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
            B_prod_line = B(b_idx);
            B_prod(:, t) = B_prod(:, t) .* B_prod_line';
        end
    end
    
    
    alpha(1,:) = pi .* B_prod(:, 1)';
    %scale(1) = sum(alpha(1, :));
    %alpha(1,:) = alpha(1, :) / scale(1);
    scale(1) = 1 ./ sum(alpha(1, :));
    alpha(1,:) = alpha(1, :) * scale(1);

    for t = 2:T
        alpha(t,:) = (alpha(t-1,:) * A) .* B_prod(:, t)';
        %scale(t) = sum(alpha(t, :));
        %alpha(t, :) = alpha(t, :) / scale(t);
        scale(t) = 1 ./ sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) * scale(t);
    end

    %beta(T, :) = beta(T, :) / scale(T);
    beta(T, :) = beta(T, :) * scale(T);
    for t = (T-1):-1:1
        beta(t,:) = A * (B_prod(:,t+1) .* beta(t+1,:)');
        %beta(t, :) = beta(t, :) / scale(t);
        beta(t, :) = beta(t, :) * scale(t);
    end
    
    %scale = ones(size(scale)) ./ scale;
    %P = prod(scale);
    %P = sum(log(scale));
    P = -sum(log(scale));
end
