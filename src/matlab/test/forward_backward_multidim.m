%%  Descriere
%   Vrem sa testam comportamentul algoritmului forward-backward pe cazul
%   observatiilor multi-dimensionale.
%   Se vor compara inmultirile vectoriale cu cele explicite pentru a testa
%   validitatea implementarii.

%%  initializare
T = 10;
N = 5;
M = 10;
R = 2;

A = rand(N, N);
B = rand(N, M, R);
pi = rand(1, N);

O = randint(R, T, [1 M]);

%% algoritm cu for-uri
scale1 = zeros (1, T);
alpha1 = zeros (T, N);
beta1 = ones (T, N);

% init
for i=1:N
    idx_symbols = O(:, 1)';
    prod_r = 1;
    for r = 1 : R
        prod_r = prod_r * B(i, idx_symbols(1, r), r);
    end
    alpha1(1, i) = pi(i) * prod_r;
end

scale1(1) = sum(alpha1(1, :));
alpha1(1,:) = alpha1(1, :) / scale1(1);

% recurssion
for t = 2 : T
    for j = 1 : N
        sa = alpha1(t-1, :) * A(:, j);
        idx_symbols_alpha = O(:, t)';
        
        prod_r = 1;
        for r = 1 : R
            prod_r = prod_r * B(j, idx_symbols_alpha(1, r), r);
        end
        
        alpha1(t, j) = sa * prod_r;
    end
    
    scale1(1, t) = sum(alpha1(t, :));
    alpha1(t, :) = alpha1(t, :) / scale1(1, t);
end

% ----- backward -----
beta1(T, :) = beta1(T, :) / scale1(1, T);
for t = (T-1):-1:1
    idx_symbols = O(:, t + 1)';
    for i = 1:N
        beta1(t, i) = 0;
        for j = 1 : N
            s_elem = A(i, j) * beta1(t + 1, j);
            
            prod_r = 1;
            for r = 1 : R
                prod_r = prod_r * B(j, idx_symbols(1, r), r);
            end
            
            s_elem = s_elem * prod_r;
            beta1(t, i) = beta1(t, i) + s_elem;
        end
    end
    
    beta1(t, :) = beta1(t, :) / scale1(1, t);
end

%% algoritm vectorial

scale2 = zeros (1, T);
alpha2 = zeros (T, N);
beta2 = ones (T, N);

obs_symbol_idx = O(:, 1)';
B_prod = ones(1, N);

% multiplication of independent observation dimension probabilities for
% each state
for r = 1 : R
    b_idx = sub2ind(size(B), 1:N, ...
        repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
    B_prod_line = B(b_idx);
    B_prod = B_prod .* B_prod_line;
end

alpha2(1,:) = pi .* B_prod;
scale2(1) = sum(alpha2(1, :));
alpha2(1,:) = alpha2(1, :) / scale2(1);

for t = 2:T
    % multiplication of independent observation dimension probabilities 
    % for each state
    obs_symbol_idx = O(:, t)';
    B_prod = ones(1, N);

    for r = 1 : R
        b_idx = sub2ind(size(B), 1:N, ...
            repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
        B_prod_line = B(b_idx);
        B_prod = B_prod .* B_prod_line;
    end

    alpha2(t,:) = (alpha2(t-1,:) * A) .* B_prod;
    scale2(t) = sum(alpha2(t, :));
    alpha2(t, :) = alpha2(t, :) / scale2(t);
end

beta2(T, :) = beta2(T, :) / scale2(T);
for t = (T-1):-1:1
    % multiplication of independent observation dimension probabilities 
    % for each state
    obs_symbol_idx = O(:, t + 1)';
    B_prod = ones(1, N);

    for r = 1 : R
        b_idx = sub2ind(size(B), 1:N, ...
            repmat(obs_symbol_idx(r), 1, N), repmat(r, 1, N));
        B_prod_line = B(b_idx);
        B_prod = B_prod .* B_prod_line;
    end

    beta2(t,:) = A * (B_prod' .* beta2(t+1,:)');
    beta2(t, :) = beta2(t, :) / scale2(t);
end
%scale = ones(size(scale)) ./ scale;
P = prod(scale2);

%% testare egalitate
scale1 - scale2


alpha1 - alpha2

if alpha1 == alpha2
    disp 'alpha1 EGAL alpha2'
else
    disp 'alpha1 DIFERIT DE alpha2'
end


beta1 - beta2
if beta1 == beta2
    disp 'beta1 EGAL beta2'
else
    disp 'beta1 DIFERIT DE beta2'
end
