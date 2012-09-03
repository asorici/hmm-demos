%% test pentru calculul matircelor A, B în Baum-Welch multi-dim discret

%% init random variables

L = 3;
M = 4;
N = 5;
R = 2;
T = [3 5 6];

TMax = max(T);

err = 0.000001;

V = 1:M;
%O = ones(L, TMax) * (M+1);
O = zeros(L, R, TMax);

for l=1:L
    for r=1:R
        O(l, r, 1:T(l)) = randi(M,1,T(l));
    end
end

Pi = zeros(1,N);
Pi(1) = 1.0;

A = zeros(N, N);        
for i = 1 : N - 2
    A(i, i:(i+2)) = rand(1, 3);
end
A(N - 1, (N - 1):N) = rand(1, 2);
A(N, N) = 1;
A = A ./ repmat(sum(A,2),1,N);

B = ones(N, M, R) / M;

LogP = zeros(1,L);
%Scale = zeros(L, TMax);
Scale = ones(L, TMax);
% Forward and Backward variables
Alpha = zeros(L, TMax, N); % L x TMax x N matrix
Beta = zeros(L, TMax, N); % L x TMax x N matrix

% Auxiliary variables
A_3D = zeros(L,TMax,N,N);
B_3D = zeros(L,TMax,N,N);
Alpha_3D = zeros(L,TMax,N,N);
Beta_3D = zeros(L,TMax,N,N);

A_3D_ = zeros(L,TMax,N,N);
B_3D_ = zeros(L,TMax,N,N);
Alpha_3D_ = zeros(L,TMax,N,N);
Beta_3D_ = zeros(L,TMax,N,N);

% Compute initial P (and forward and backward variables)
for l=1:L
    [LogP(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward( shiftdim(O(l, 1:R, 1:T(l))), Pi, A, B);
end


for ct = 1:5
    %% Precompute B_prod like in the forward_backward case
    %B_prod = ones(L, N, TMax);
    B_prod = zeros(L, N, TMax);
    for l = 1 : L
        B_prod(l, :, 1:T(l)) = ones(N, T(l));
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

    %% actual computation

    % Computing the expected probabilities
    for l=1:L
        % Add dimension to multiply element by element
        Alpha_3D(l,1:(T(l)-1),:,:) = ...
            repmat(Alpha(l,1:(T(l)-1),:),[1 1 1 N]);

        A_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(A,[1 1 1 (T(l)-1)]), [3 4 1 2]);

        B_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(shiftdim(B_prod(l, :, 2:T(l))),[1 1 1 N]), [3 2 4 1]);
            %permute(repmat(B(:,O(l,2:T(l))),[1 1 1 N]), [3 2 4 1]);

        Beta_3D(l,1:(T(l)-1),:,:) = ...
            permute(repmat(Beta(l,2:T(l),:), [1 1 1 N]), [1 2 4 3]);
    end


    % Compute Gamma and Xi
    % Xi = Alpha_3D .* A_3D .* B_3D .* Beta_3D / P(l); % not correct
    % Gamma = Alpha .* Beta / P(l); % not correct in this form


    A_ = A;
    B_ = B;

    %% Maximization (Reestimation)

    mask = zeros(L, TMax);
    %mask(1:L, 1:TMax-1) = ...
    %    (shiftdim(permute((O(1:L, 1, 2:TMax) > 0), [2 1 3])));
    for l = 1:L
        mask(l, 1:(T(l) - 1)) = ones(1, (T(l) - 1));
    end
    mask2 = mask;
    mask = repmat(mask, [1 1 N]);

    % Reestimate Lambda
    %{
    A = shiftdim(sum(sum( ...
        Alpha_3D_ .* A_3D_ .* B_3D_ .* Beta_3D_ ... %.* repmat(mask2,[1 1 N N]) ...
        , 1),2),2) ...
        ./ shiftdim(sum(sum( ...
        repmat(Alpha .* Beta .* mask .* ...
        repmat(Scale,[1 1 N]),[1 1 1 N]) ...
        ,1),2),2);
    %}
    %{
    A = shiftdim(sum(sum( ...
        Alpha_3D .* A_3D .* B_3D .* Beta_3D ... %.* repmat(mask2,[1 1 N N]) ...
        , 1),2),2) ...
        ./ shiftdim(sum(sum( ...
        repmat(Alpha .* Beta .* mask .* ...
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
    for r = 1 : R
        O_r = shiftdim(permute(O(:, r, :), [1 3 2]));
        B(:,:,r) = (shiftdim(sum(sum( ...
            (permute(repmat(repmat(O_r,[1 1 M]) == ...
            permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
            repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
            ,1),2),2) + ones(N, M) * 1.0e-4) ./ ...    
            (shiftdim(sum(sum( ...
            repmat(Alpha .* Beta ./ repmat(Scale,[1 1 N]),[1 1 1 M]) ...
            ,1),2),2) + ones(N, M) * 1.0e-4 * M);
    end
    
    
    Pi = zeros(1, N);
    for l = 1:L
        AlphaL = shiftdim(Alpha(l, :, :));
        BetaL = shiftdim(Beta(l, :, :));
        Pi = Pi + AlphaL(1, :) .* BetaL(1, :) ./ Scale(l, 1) ./ ... 
            sum(AlphaL(1, :) .* BetaL(1, :) ./ Scale(l, 1));
    end
    
    Pi = Pi ./ L;
    
    
    %% verification
    Pi
    sum(Pi)
    
    A

    disp 'Sum A';
    sum(A, 2)

    for r = 1 : R
        B_r = B(:,:, r);
        fprintf('Sum B in dim %d \n', r); 
        sum(B_r, 2)
    end

    
    %% new forward-backward computation
    for l=1:L
        [LogP(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
            forward_backward( shiftdim(O(l, 1:R, 1:T(l))), Pi, A, B);
    end

end
