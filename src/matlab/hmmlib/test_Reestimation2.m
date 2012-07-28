%% test pentru calculul matircelor A,B în Baum-Welch discret
% momentan merge cu copy-paste la celula /actual computation/

%% init random variables
L = ceil(rand()*30);
M = 1 + ceil(rand()*20); % eroare fiindcă dispare o dimensiune a matricelor
N = 1 + ceil(rand()*15); % eroare fiindcă dispare o dimensiune a matricelor
T = ones(1,L) + ceil(rand(1,L)*40);

TMax = max(T);

V = 1:M;
O = zeros(L, TMax);
for l=1:L
    O(l,1:T(l)) = randi(M,1,T(l));
end

Pi = zeros(1,N);
Pi(1) = 1.0;

A = rand(N,N);
A = A ./ repmat(sum(A,2),1,N);

B = rand(N,M);
B = B ./ repmat(sum(B,2),1,M);

Pold = -1;

P = zeros(1,L);
Scale = zeros(L, TMax);
% Forward and Backward variables
Alpha = zeros(L, TMax, N); % L x TMax x N matrix
Beta = zeros(L, TMax, N); % L x TMax x N matrix

% Auxiliary variables
A_3D = zeros(L,TMax,N,N);
B_3D = zeros(L,TMax,N,N);
Alpha_3D = zeros(L,TMax,N,N);
Beta_3D = zeros(L,TMax,N,N);

% Compute initial P (and forward and backward variables)
for l=1:L
    [P(l), Alpha(l, 1:T(l), :), Beta(l, 1:T(l), :), Scale(l, 1:T(l))] = ...
        forward_backward(O(l,1:T(l)), Pi, A, B);
end

%% actual computation

for l=1:L
    % Add dimension to multiply element by element
    Alpha_3D(l,1:(T(l)-1),:,:) = ...
        repmat(Alpha(l,1:(T(l)-1),:),[1 1 1 N]);
    
    A_3D(l,1:(T(l)-1),:,:) = ...
        permute(repmat(A,[1 1 1 (T(l)-1)]), [3 4 1 2]);
    
    B_3D(l,1:(T(l)-1),:,:) = ...
        permute(repmat(B(:,O(2:T(l))),[1 1 1 N]), [3 2 4 1]);
    
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

B = shiftdim(sum(sum( ...
    (permute(repmat(repmat(O,[1 1 M]) == ...
    permute(repmat(V,[L 1 TMax]), [1 3 2]),[1 1 1 N]), [1 2 4 3])) .* ...
    repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
    ,1),2),2) ./ ...    
    shiftdim(sum(sum( ...
    repmat(Alpha .* Beta .* repmat(Scale,[1 1 N]),[1 1 1 M]) ...
    ,1),2),2);

%% verification
correctA = 1;
correctB = 1;

for i=1:N
    for j=1:N
        Z1 = 0;
        Z2 = 0;
        for l=1:L
            for t=1:(T(l)-1)
                Z1 = Z1 + Alpha(l,t,i) * A(i,j) * B(j,O(l,t+1)) * Beta(l,t+1,j);
                Z2 = Z2 + Alpha(l,t,i) * Beta(l,t,i) * Scale(l,t);
            end
        end
        if A(i,j) ~= (Z1/Z2)
            correctA = 0;
            fprintf('%f ~= %f\t',A(i,j),(Z1/Z2))
        end
    end
end
if correctA == 1
    fprintf('\nA correct\n')
else
    fprintf('\nA incorrect\n')
    
end


for j=1:N
    for k=1:M
        Z1 = 0;
        Z2 = 0;
        for l=1:L
            for t=1:T(l)
                if O(t)==V(k)
                    Z1 = Z1 + Alpha(l,t,i)*Beta(l,t,i)*Scale(l,t);
                end
                Z2 = Z2 + Alpha(l,t,i)*Beta(l,t,i)*Scale(l,t);
            end
        end
        if B(j,k) ~= (Z1/Z2)
            correctB = 0;
            fprintf('%f ~= %f\t',B(j,k),(Z1/Z2))
        end
    end
end

if correctB == 1
    fprintf('\nB correct\n')
else
    fprintf('\nB incorrect\n')
end