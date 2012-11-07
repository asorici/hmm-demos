function [Pi, A, B] = baum_welch_discrete(O, T, N, M, model, max_iter)
% BAUM_WELCH_DISCRETE computes the Baum-Welch algorithm for discrete values
% It receives L observed sequences of lengths T(:) (1xL), the number of
% states for the HMM, and the size of the domain for the observed variables
% M. The algorithm returns the parameters of the HMM: Pi, A, B.
%
% Inputs:
% O :       an L x TMax matrix with the observed sequences
% T :       an 1 x L matrix with the length of each sequence in O
% N :       the number of states in the HMM
% M :       the number of discrete observation values
% model:    the model of the transition structure for the HMM
%           choices are from {ergodic, bakis}
% max_iter: the maximum number of iterations for the Baum-Welch
%           algorithm
%
% Outputs
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(q[1]=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(q[t+1]=Sj | q[t] = Si)
% B :   an N x M matrix for the observation values probability distribution
%       in each state
%       B(j,k) = P(O[t]=v[k] | q[t] = Sj)

%% Other variables

% Number of iterations
iter_ct = 1;

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
V = 1 : M;

ll_threshold = 0.00001;

%% Initial random values for the HMM parameters
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

%% Initial computation
LogP_old = 0;

LogP = zeros(1,L);
Scale = ones(L, TMax);

% Compute initial P (and forward and backward variables)
for l=1:L
    [LogP(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward(O(l,1:T(l)), Pi, A, B);
end

%% EM Loop
while abs(LogP_old - sum(LogP) / L) >= ll_threshold && iter_ct < max_iter
    
    LogP_old = sum(LogP) / L;
    
    % display some progress
    fprintf('Iteration: %d, Log Likelihood: %0.5f\n', ...
                iter_ct, LogP_old);
    
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
    
    
    %% Maximization (Reestimation)

    mask = zeros(L, TMax);
    mask(1:L, 1:TMax-1) = (O(1:L,2:TMax) > 0);
    mask = repmat(mask, [1 1 N]);

    % Reestimate Lambda
    %{
    A = shiftdim(sum(sum( ...
        Alpha_3D .* A_3D .* B_3D .* Beta_3D ...
        , 1),2),2) ...
        ./ shiftdim(sum(sum( ...
        repmat(Alpha .* Beta .* mask ./ ...
        repmat(Scale,[1 1 N]),[1 1 1 N]) ...
        ,1),2),2);
    %}

    A_aux = shiftdim(sum(sum( ...
            Alpha_3D .* A_3D .* B_3D .* Beta_3D ... 
        , 1),2),2); 
    % A_aux is now N x N
    A = A_aux ./ repmat(sum(A_aux, 2), [1 N]);
    
    % reestimate emission probabilities for each dimension of the
    % observed variables
    % also use laplacian smoothing with a factor of 1.0e-4
    B = (shiftdim(sum(sum( ...
        (permute(repmat(repmat(O,[1 1 M]) == ...
        permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
        repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
        ,1),2),2) + ones(N, M) * 1.0e-4) ./ ...    
        (shiftdim(sum(sum( ...
        repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
        ,1),2),2) + ones(N, M) * 1.0e-4 * M);

    if strcmp(model, 'ergodic')
        % we have to reestimate the 
        % initial state probabilities as well
        Pi = zeros(1, N);
        for l = 1:L
            AlphaL = shiftdim(Alpha(l, :, :));
            BetaL = shiftdim(Beta(l, :, :));
            Pi = Pi + AlphaL(1, :) .* BetaL(1, :) ./ Scale(l, 1) ./ ... 
                sum(AlphaL(1, :) .* BetaL(1, :) ./ Scale(l, 1));
        end

        Pi = Pi ./ L;
    end
    
    % Recompute P and forward & backward variables
    for l=1:L
        [LogP(l), Alpha(l,1:T(l),:), Beta(l,1:T(l),:), Scale(l,1:T(l))] = ...
            forward_backward(O(l,1:T(l)), Pi, A, B);
    end
    
     % increase iteration count
    iter_ct = iter_ct + 1;
end
