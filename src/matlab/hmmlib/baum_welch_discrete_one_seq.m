function [Pi, A, B] = baum_welch_discrete(O, N, M)
% BAUM_WELCH_DISCRETE computes the Baum-Welch algorithm for discrete values
%
% O :   an 1 x T matrix with the observed sequence
% N :   the number of states in the HMM
% M :   the number of discrete observation values
%
% Pi :  an 1 x N matrix containing the initial state distribution
%       Pi(j) = P(q[1]=Sj) for 1 =< j =< N
% A :   an N x N matrix for the state transition probability distribution
%       A(i,j) = P(q[t+1]=Sj | q[t] = Si)
% B :   an N x M matrix for the observation values probability distribution
%       in each state
%       B(j,k) = P(O[t]=v[k] | q[t] = Sj)

%% Other variables

% Observed sequences
T = size(O,2);

% Forward and Backward variables
Alpha = zeros(T, N); % T x N matrix
Beta = ones(T, N); % T x N matrix

% Variables for the Baum-Welch algorithm (Gamma and Xi)
% Gamma = T x N matrix
% Xi = (T-1) x N x N matrix


%% Initial random values for the HMM parameters

Pi = rand(1,N);
Pi = Pi/ sum(Pi);

A = rand(N,N);
A = A ./ repmat(sum(A,2),1,N);

B = rand(N,M);
B = B ./ repmat(sum(B,2),1,M);

Pold = -1;

P = rand();

[P, Alpha, Beta, Scale] = forward_backward(O, Pi, A, B);

while abs(Pold - prod(P)) >= 0.000001
    
    Pold = prod(P);
    
    %% Expectation
      
    % Computing the Gamma and Xi probabilities

    Alpha_3D = repmat(Alpha(1:(T-1),:),[1 1 N]);
    A_3D = permute(repmat(A,[1 1 (T-1)]), [3 1 2]);
    B_3D = permute(repmat(B(:,O(2:T)),[1 1 N]), [2 3 1]);
    Beta_3D = permute(repmat(Beta(2:T,:), [1 1 N]), [1 3 2]);

    Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P;
    Gamma = Alpha .* Beta / P;

    %% Maximization (Reestimation)

    Pi(:) = Gamma(1,:);
    A = shiftdim(sum(Xi,1),1) ./ repmat(sum(Gamma(1:(T-1),:),1)',1,N);
    B = ((repmat(O,M,1)==repmat(V',1,T))*Gamma)' ./ repmat(sum(Gamma,1)',1,M);
    
    for l=1:L
        [P(l), Alpha(l,:,:), Beta(l,:,:), Scale(l,:)] = forward_backward(O, Pi, A, B);
    end
end
