function [Pi, A, B] = baum_welch_discrete(O, T, N, M)
% BAUM_WELCH_DISCRETE computes the Baum-Welch algorithm for discrete values
% It receives L observed sequences of lengths T(:) (1xL), the number of
% states for the HMM, and the size of the domain for the observed variables
% M. The algorithm returns the parameters of the HMM: Pi, A, B.
%
% Input args:
% O :   an L x TMax matrix with the observed sequences
% T :   an 1 x L matrix with the length of each sequence in O
% N :   the number of states in the HMM
% M :   the number of discrete observation values
%
% Output args
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(q[1]=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(q[t+1]=Sj | q[t] = Si)
% B :   an N x M matrix for the observation values probability distribution
%       in each state
%       B(j,k) = P(O[t]=v[k] | q[t] = Sj)

%% Other variables

% Observed sequences
L = size(O,1); % Number of observed sequences
TMax = size(O,2); % Maximum length for the observed sequences

% Forward and Backward variables
Alpha = zeros(L, TMax, N); % L x TMax x N matrix
Beta = zeros(L, TMax, N); % L x TMax x N matrix

% Variables for the Baum-Welch algorithm (Gamma and Xi)
% Gamma = L x T x N matrix
% Xi = L x (T-1) x N x N matrix

Gamma = zeros(L,T,N);
Xi = zeros(L,T-1,N,N);

% Auxiliary variables
A_3D = zeros(L,TMax,N,N);
B_3D = zeros(L,TMax,N,N);
Alpha_3D = zeros(L,TMax,N,N);
Beta_3D = zeros(L,TMax,N,N);


%% Initial random values for the HMM parameters

Pi = zeros(1,N);
Pi(1) = 1.0;

A = rand(N,N);
A = A ./ repmat(sum(A,2),1,N);

B = rand(N,M);
B = B ./ repmat(sum(B,2),1,M);

Pold = -1;

P = zeros(1,L);
Scale = zeros(L, TMax);

% Compute initial P (and forward and backward variables)
for l=1:L
    [P(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward(O(l,1:T(l)), Pi, A, B);
end

%% EM Loop
while abs(Pold - prod(P)) >= 0.000001
    
    Pold = prod(P);
    
    %% Expectation
      
    % Computing the expected probabilities
   
for l=1:L
    % Add dimension to multiply element by element
    Alpha_3D(l,1:(T(l)-1),:,:) = ...
        repmat(Alpha(l,1:(T(l)-1),:),[1 1 1 N]);
    
    A_3D(l,1:(T(l)-1),:,:) = ...
        permute(repmat(A,[1 1 1 (T(l)-1)]), [3 4 1 2]);
    
    B_3D(l,1:(T(l)-1),:,:) = ...
        permute(repmat(B(:,O(l,2:T(l))),[1 1 1 N]), [3 2 4 1]);
    
    Beta_3D(l,1:(T(l)-1),:,:) = ...
        permute(repmat(Beta(l,2:T(l),:), [1 1 1 N]), [1 2 4 3]);
end
    
% Compute Gamma and Xi
% Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P(l); % not correct
% Gamma = Alpha .* Beta / P(l); % not correct in this form

A_ = A
B_ = B

%% Maximization (Reestimation)

mask = zeros(L, TMax);
mask(1:L, 1:TMax-1) = (O(1:L,2:TMax) > 0);
mask = repmat(mask, [1 1 N]);

% Reestimate Lambda
A = shiftdim(sum(sum( ...
    Alpha_3D .* A_3D .* B_3D .* Beta_3D ...
    , 1),2),2) ...
    ./ shiftdim(sum(sum( ...
    repmat(Alpha .* Beta .* mask .* ...
    repmat(Scale,[1 1 N]),[1 1 1 N]) ...
    ,1),2),2);

B = shiftdim(sum(sum( ...
    (permute(repmat(repmat(O,[1 1 M]) == ...
    permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
    repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
    ,1),2),2) ./ ...    
    shiftdim(sum(sum( ...
    repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
    ,1),2),2);

    
    % Recompute P and forward & backward variables
    for l=1:L
        [P(l), Alpha(l,1:T(l),:), Beta(l,1:T(l),:), Scale(l,1:T(l))] = ...
            forward_backward(O(l,1:T(l)), Pi, A, B);
    end
end
