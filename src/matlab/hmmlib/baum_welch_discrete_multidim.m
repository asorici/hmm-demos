function [Pi, A, B] = baum_welch_discrete_multidim(O, T, N, M, model, max_iter)
% BAUM_WELCH_DISCRETE computes the Baum-Welch algorithm for discrete values
% 
% Inputs
%   O :     an L x R x TMax matrix with the observed sequences
%   T :     an 1 x L matrix with the length of each sequence in O
%   N :     the number of states in the HMM
%   M :     the number of discrete observation values
%   R :     the number of dimensions for the observed values
%   model:  the model of the transition structure for the HMM
%           choices are from {ergodic, bakis}
%
% Outputs:
%   Pi : an 1 x N matrix containing the initial state distribution
%        Pi(j) = P(q[1]=Sj) for 1 =< j =< N
%   A :  an N x N matrix for the state transition probability distribution
%        A(i,j) = P(q[t+1]=Sj | q[t] = Si)
%   B :  an N x M x R matrix for the observation values probability distribution
%        in each state
%        B(j,k,r) = P(O[r,t]=v[r,k] | q[t] = Sj)

%% Other variables

% Maximum number of iterations
max_iter = 50;
iter_ct = 1;

% Observed sequences
L = size(O,3); % Number of observed sequences
TMax = size(O,2); % Length of each sequence

% Forward and Backward variables
Alpha = zeros(L, TMax, N); % L x TMax x N matrix
Beta = zeros(L, TMax, N); % L x TMax x N matrix

% Variables for the Baum-Welch algorithm (Gamma and Xi)
% Gamma = L x T x N matrix
% Xi = L x (T-1) x N x N matrix

Gamma = zeros(L,TMax, N);
Xi = zeros(L,TMax - 1, N, N);

% Auxiliary variables
A_3D = zeros(L,TMax,N,N);
B_3D = zeros(L,TMax,N,M);
Alpha_3D = zeros(L,TMax,N,N);
Beta_3D = zeros(L,TMax,N,N);
V = 1:M;

%%  Initial random values for the HMM parameters
Pi = zeros(1, N);
A = rand(N, N);
B = ones(N, M, R) / M;  % uniform initial output probabilities

%   Switch after model type
if strcmp(model, 'ergodic')
    Pi = rand(1, N);
    Pi = Pi ./ sum(Pi);
    A = A ./ repmat(sum(A,2),1,N);
else
    if strcmp(model, 'bakis')
        Pi(1) = 1;
        A = zeros(N, N);
        
        for i = 1 : N - 2
            A(i, i:(i+2)) = rand(1, 3);
        end
        A(N - 1, (N - 1):N) = rand(1, 2);
        A(N, N) = 1;
        A = A ./ repmat(sum(A,2),1,N);
    else
        error('baum_welch_discrete_multidim:modelCheck', ...
            'No transition model named' + model);
    end 
end

%% initial computation
Pold = -1;

P = zeros(1,L);
Scale = zeros(L, TMax);

% Compute initial P (and forward and backward variables)
for l=1:L
    [P(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward( shiftdim(O(l, R, 1:T(l))), Pi, A, B);
end

%% EM Loop
while abs(Pold - prod(P)) >= 0.000001 && iter_ct < max_iter
    
    Pold = prod(P);
    
    %% Expectation
      
    % Computing the expected probabilities
    for l=1:L
        % Add dimension to multiply element by element
        Alpha_3D(l,1:T(l),:,:) = ...
            repmat(Alpha(l,1:(T(l)-1),:),[1 1 N]);
        A_3D(l,1:T(l),:,:) = ...
            permute(repmat(A(l,:,:),[1 1 (T(l)-1)]), [3 1 2]);
        B_3D(l,1:T(l),:,:) = ...
            permute(repmat(B(l,:,O(2:T(l))),[1 1 N]), [2 3 1]);
        Beta_3D(l,1:T(l),:,:) = ...
            permute(repmat(Beta(l,2:T(l),:), [1 1 N]), [1 3 2]);
    end
    
    % Compute Gamma and Xi
    % Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P(l); % not correct
    % Gamma = Alpha .* Beta / P(l); % not correct in this form

    %% Maximization (Reestimation)

    % Reestimate Lambda
    A = shiftdim(sum(sum( ...
        Alpha_3D .* A_3D .* B_3D .* Beta_3D ...
        , 1),2),2) ...
        ./ shiftdim(sum(sum( ...
        repmat(Alpha(:,1:(T-1),:) .* Beta(:,1:(T-1),:).* ...
        repmat(Scale,[1 1 N]),[1 1 1 N]) ...
        ,1),2),2);
    
    B = shiftdim(sum(sum( ...
        (permute(repmat(repmat(O,[1 1 M]) == ...
        permute(repmat(1:M, [L 1 N]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
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
    
    % increase iteration count
    iter_ct = iter_ct + 1;
end
