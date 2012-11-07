% test for the computation of the Gamma values given
% A,B,Pi,Alpha,Beta,Scale and Xi
% ! not to be executed directly
%
% Authors: Alexandru Sorici, Tudor Berariu / August 2012

A_Correct = 1;
B_Correct = 1;
max_error = 1e-10;

for no=1:10
    %% Build random HMM
    N = randi(20,1,1); % Number of states
    M = randi(10,1,1); % Size of symbol set
    L = randi(10,1,1); % Number of observed sequences
    % Initial state probabilities
    Pi = rand(1, N);
    Pi = Pi / sum(Pi);
    % State transition probabilities
    A = rand(N, N);
    A = A .* repmat((1.0 ./ sum(A,2)), [1 N]);
    % Emission probabilities
    B = rand(N, M);
    B = B .* repmat((1.0 ./ sum(A,2)), [1 M]);

    %% Create random observed sequence
    T = randi(30,1,1);
    O = randi(M,L,T);

    %% Initialize Alpha, Beta, Scale, LogP
    Alpha = zeros (L, T, N); % Alpha is a T x N matrix
    Beta = ones (L, T, N); % Beta is a T x N matrix
    LogP = zeros(1,L);
    Scale = ones(L, TMax);
    
    for l=1:L
        [LogP(l), Alpha(l, 1:T, :), Beta(l, 1:T, :), Scale(l, 1:T)] = ...
            forward_backward_multi_disc(O(l,1:T(l)), Pi, A, B);
    end

    %% Compute Xi

    Xi = zeros(L,T-1,N,N);

    for l = 1:L
        for t = 1:(T-1)
            s_ = 0;
            for i = 1:N
                for j = 1:N
                    Xi(l,t,i,j) = Alpha(l,t,i)*A(i,j)*B(j,O(l,t+1))*Beta(l,t+1,j);
                    s_ = s_ + Xi(l,t,i,j);
                end
            end
            Xi(l,t,:,:) = Xi(l,t,:,:) ./ s_;
        end
    end
    
    Gamma = zeros(L,T,N);
    Gamma_ = Gamma;
    
    for l = 1:L
        for t = 1:(T-1)
            for i = 1:N
                Gamma_(l,t,i) = Alpha(l,t,i)*Beta(l,t,i);
            end
            Gamma(l,t,:) = Gamma_(l,t,:) ./ exp(logP(l));
        end
    end
    
    try
%%%--REPLACE-THIS--%%%
    catch
        fprintf('%s\n',lasterror.message);
        Correct = 0;
	return;
    end

    %% Compute correct A, B
    % Do not optimize, use definition. (Tudor)

    % Auxiliary variables
    A_3D = zeros(L,TMax,N,N);
    B_3D = zeros(L,TMax,N,N);
    Alpha_3D = zeros(L,TMax,N,N);
    Beta_3D = zeros(L,TMax,N,N);
    V = 1 : M;
    
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
    
    A_aux = shiftdim(sum(sum( ...
            Alpha_3D .* A_3D .* B_3D .* Beta_3D ... 
        , 1),2),2); 
    % A_aux is now N x N
    A_ = A_aux ./ repmat(sum(A_aux, 2), [1 N]);
    
    % reestimate emission probabilities for each dimension of the
    % observed variables
    % also use laplacian smoothing with a factor of 1.0e-4
    B_ = (shiftdim(sum(sum( ...
        (permute(repmat(repmat(O,[1 1 M]) == ...
        permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
        repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
        ,1),2),2) + ones(N, M) * 1.0e-4) ./ ...    
        (shiftdim(sum(sum( ...
        repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
        ,1),2),2) + ones(N, M) * 1.0e-4 * M);
    
   %% Check results
    if A_Correct == 1
	[A_Correct, A_Message] = ...
	    matrices_are_equal(A_, A, max_error);
    end
    if B_Correct == 1
	[B_Correct, B_Message] = ...
	    matrices_are_equal(B_, B, max_error);
    end
    if A_Correct == 0 && B_Correct == 0
        break;
    end
end

if A_Correct == 1
    fprintf('A correct\n');
else
    fprintf('A incorrect: %s\n',A_Message);
end
if B_Correct == 1
    fprintf('B correct\n');
else
    fprintf('B incorrect: %s\n',B_Message);
end

Correct = A_Correct * B_Correct; 
