% test for the computation of reestimated A, B, Pi values given
% [old] A, [old] B, Alpha, Beta, Scale, logP
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
    TMax = randi(30,1,1) + 5; % Maximum length for the observed sequences
    T = ones(1,L) * TMax;
    O = randi(M,L,TMax);
    

    %% Initialize Alpha, Beta, Scale, LogP
    Alpha = zeros (L, TMax, N); % Alpha is a T x N matrix
    Beta = ones (L, TMax, N); % Beta is a T x N matrix
    LogP = zeros(1,L);
    Scale = ones(L, TMax);
    
    for l=1:L
        [LogP(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
            forward_backward_disc(O(l,1:T(l)), Pi, A, B);
    end

    Aold = A;
    Bold = B;
    A_ = A;
    B_ = B;
    TMax = size(O,2); % Maximum length for the observed sequences
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
            permute(repmat(A_,[1 1 1 (T(l)-1)]), [3 4 1 2]);

        B_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(B_(:,O(l,2:T(l))),[1 1 1 N]), [3 2 4 1]);

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
