function [Pi, A, C, MU, SIGMA] = baum_welch_continuous(O, T, N, M)
% BAUM_WELCH_DISCRETE computes the Baum-Welch algorithm for discrete values
%
% O :     an L x TMax x R matrix with the observed sequences
% T :     an 1 x L matrix with the length of each sequence in O
% N :     the number of states in the HMM
% M :     the number of gaussian mixture components

% Pi :    an 1 x N matrix containing the initial state distribution
%         Pi(j) = P(q[1]=Sj) for 1 =< j =< N
% A :     an N x N matrix for the state transition probability distribution
%         A(i,j) = P(q[t+1]=Sj | q[t] = Si)
% C :     an N x M matrix
%         contains the weights for the mixture components per state
% MU :    an N x M x R matrix
%         it contains the mean vectors for the mixture components per state
% SIGMA : an N x M x R x R matrix  
%         it contains the covariance matrices for the mixture components
%         per state

%% Other variables

% Observed sequences
L = size(O,1); % Number of observed sequences
TMax = size(O,2); % Length of each sequence
R = size(O,3) % Number of considered dimensions for the observed signal

% Forward and Backward variables
Alpha = zeros(L, TMax, N); % L x TMax x N matrix
Beta = zeros(L, TMax, N); % L x TMax x N matrix

% Variables for the Baum-Welch algorithm (Gamma and Xi)
% Gamma = L x T x N matrix
Gamma = zeros(L, T, N);
% Xi = L x (T-1) x N x N matrix
Xi = zeros(L, T-1, N, N);

% Auxiliary variables
% A_3D = zeros(L,TMax,N,N);
B_3D = zeros(L,TMax,N,N);
% Alpha_3D = zeros(L,TMax,N,N);
Beta_3D = zeros(L,TMax,N,N);


err = 1e-6;

%% Initial random values for the HMM parameters

Pi = zeros(1,N);
Pi(1) = 1.0;

A = rand(N,N);
A = A ./ repmat(sum(A,2),1,N);

C = rand(N,M);
C = C ./ repmat(sum(C,2),1,M);

MU = -.5+rand();
SIGMA = rand(N, M, R, R);

Pold = Inf;

P = zeros(1,L);
Scale = zeros(L, TMax);

% Compute initial P (and forward and backward variables)
for l=1:L
    [P(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward_continuous(...
        reshape(O(l,1:T(l),:),[T(l) R]), Pi, A, C, MU, SIGMA);
end

%% EM Loop
while abs(Pold - sum(log(P))) >= err
    
    Pold = sum(log(P));
    
    %% Expectation
      
    % Computing the expected probabilities
   
    % Add dimension to multiply element by element
    Alpha_3D = repmat(Alpha,[1 1 1 N]);
    A_3D = permute(repmat(A,[1 1 L TMax]), [3 4 1 2]);
    
    for l = 1:L
        for j = 1:N
            for t=2:T(l)
                B_3D(l,t-1,:,j) = ...
                    mixture_fun(reshape(O(l,t,:),[1 R]),j,C,MU,SIGMA);
            end
        end
    end
    
    Beta_3D(:,1:(TMax-1),:,:) = ...
        permute(repmat(Beta(:,2:TMax,:), [1 1 1 N]), [1 2 4 3]);
    
    % Compute Gamma and Xi
    % Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P(l); % not correct
    
    Alpheta = Alpha .* Beta;
    Gamma = Alpheta ./ repmat(sum(sum(Alpheta,2),3),[1 TMax N]);
    
    Comp = zeros(L,TMax,N,M);
    
    for l = 1:l
        for t = 1:T(l)
            for j = 1:N
                for m = 1:M
                    Comp(l,t,j,m) = ...
                        C(j,m) * mixture_fun(reshape(O(l,t,:), [1 R]), ...
                                             j, C(j,m), MU, SIGMA);
                end
                Comp(l,t,j,:) = Comp(l,t,j,:) / sum(Comp(l,t,j,:));
            end
        end
    end
    
    GammaComponent = repmat(Gamma, [1 1 1 M]) .* Comp;

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

%     B = shiftdim(sum(sum( ...
%         (permute(repmat(repmat(O,[1 1 M]) == ...
%         permute(repmat(V,[L 1 TMax]),[1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
%         repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
%         ,1),2),2) ./ ...    
%         shiftdim(sum(sum( ...
%         repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
%         ,1),2),2);

    C = reshape(sum(sum(GammaComponent,1),2),[N M]) ./ ...
        repmat(reshape(sum(sum(sum(GammaComponent,1),2),4), [N 1]), [1 M]);
    MU
    SIGMA
    
    % Recompute P and forward & backward variables
    for l=1:L
        [P(l), Alpha(l,1:T(l), :),Beta(l, 1:T(l),:),Scale(l, 1:T(l))] = ...
            forward_backward_continuous(O(l,1:T(l)), Pi, A, C, MU, SIGMA);
    end
end
