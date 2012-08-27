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
iter_ct = 1;

% Observed sequences
L = size(O, 1);     % Number of observed sequences
R = size(O, 2);     % Number of dimensions for a variable in a sequence
TMax = size(O, 3);  % Length of each sequence


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
B_3D = zeros(L,TMax,N,N);
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
        forward_backward( shiftdim(O(l, 1:R, 1:T(l))), Pi, A, B);
end

%% EM Loop
while abs(Pold - prod(P)) >= 0.000001 && iter_ct < max_iter
    
    Pold = prod(P);
    
    % Precompute B_prod like in the forward_backward case
    B_prod = ones(L, N, TMax);
    for l = 1 : L
        for t = 1 : T(l)
            obs_symbol_idx = O(l, :, t)';
            for r = 1 : R
                b_idx = sub2ind(size(B), 1:N, ...
                    repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
                B_prod_line = B(b_idx);
                B_prod(l, :, t) = B_prod(l, :, t) .* B_prod_line;
            end
        end
    end
    
    %% Expectation
      
    % Computing the expected probabilities
    for l=1:L
        % Add dimension to multiply element by element
        Alpha_3D(l,1:(T(l)-1),:,:) = ...
            repmat(Alpha(l,1:(T(l)-1),:),[1 1 1 N]);

        A_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(A,[1 1 1 (T(l)-1)]), [3 4 1 2]);

        B_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(B_prod(l, :, 2:T(l)),[1 1 1 N]), [3 2 4 1]);
            %permute(repmat(B(:,O(l,2:T(l))),[1 1 1 N]), [3 2 4 1]);
            
        Beta_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(Beta(l,2:T(l),:), [1 1 1 N]), [1 2 4 3]);
    end
    
    % Compute Gamma and Xi
    % Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P(l); % not correct
    % Gamma = Alpha .* Beta / P(l); % not correct in this form

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

    % reestimate emission probabilities for each dimension of the
    % observed variables
    for r = 1 : R
        O_r = shiftdim(permute(O(:, r, :), [1 3 2]));
        B(:,:,r) = shiftdim(sum(sum( ...
            (permute(repmat(repmat(O_r,[1 1 M]) == ...
            permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
            repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
            ,1),2),2) ./ ...    
            shiftdim(sum(sum( ...
            repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
            ,1),2),2);
    end

    
    % Recompute P and forward & backward variables
    for l=1:L
        [P(l), Alpha(l,1:T(l),:), Beta(l,1:T(l),:), Scale(l,1:T(l))] = ...
            forward_backward( shiftdim(O(l, 1:R, 1:T(l))), Pi, A, B);
    end
    
    % increase iteration count
    iter_ct = iter_ct + 1;
end
