%% descriere
% vrem să copiem o matrice 2D într-o matrice 3D astfel încât
% pentru a treia coordonată toate elementele să fie identice

% dificultatea: respectarea ordinii dimensiunilor inițiale
% de exemplu (vezi matricea B):
% am matrice de dimensiune T X M și vreau să construiesc o matrice
% de dimensiune T x N x M astfel încât
% B3D(t, i, j) = B(t, j) oricare ar fi i=1:N

%% initializare
T = 3;
N = 4;
M = 5;

A3D = zeros(T,N,M);
B3D = zeros(T,N,M);
C3D = zeros(T,N,M);

A = rand(T,N);
B = rand(T,M);
C = rand(N,M);

%% copiere A

A3D = repmat(A, [1 1 M]);

%% copiere B

B3D_ = repmat(B, [1 1 N]);
B3D = permute(B3D_,[1 3 2]);

%% copiere C

C3D_ = repmat(C, [1 1 T]);
C3D = permute(C3D_,[3 1 2]);


%% testare
Acorect = 1;
for t=1:T
    for i=1:N
        x = A(t,i);
        for j=1:M
            if x ~= A3D(t,i,j)
                Acorect = 0;
            end
        end
    end
end

if Acorect == 1
    disp 'A corect'
else
    disp 'A incorect'
end

Bcorect = 1;
for t=1:T
    for j=1:M
        x = B(t,j);
        for i=1:N
            if x ~= B3D(t,i,j)
                Bcorect = 0;
            end
        end
    end
end

if Bcorect == 1
    disp 'B corect'
else
    disp 'B incorect'
end

Ccorect = 1;
for i=1:N
    for j=1:M
        x = C(i,j);
        for t=1:T
            if x ~= C3D(t,i,j)
                Ccorect = 0;
            end
        end
    end
end

if Ccorect == 1
    disp 'C corect'
else
    disp 'C incorect'
end