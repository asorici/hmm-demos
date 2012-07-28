%% test reestimation

%% init random variables
M = ceil(rand()*20)
N = ceil(rand()*15)
T = ceil(rand()*30)


V = 1:M;
O = randi(M,1,T);
Gamma = rand(T,N);
Xi = rand(T-1,N,N);

%% actual computation

size(shiftdim(sum(Xi,1),1))

size(repmat(sum(Gamma(1:(T-1),:),1)',1,N))

A_ = shiftdim(sum(Xi,1),1) ./ repmat(sum(Gamma(1:(T-1),:),1)',1,N);
B_ = ((repmat(O,M,1)==repmat(V',1,T))*Gamma)' ./ repmat(sum(Gamma,1)',1,M);

%% verification
correctA = 1;
correctB = 1;

for i=1:N
    for j=1:N
        Z1 = 0;
        Z2 = 0;
        for t=1:(T-1)
            Z1 = Z1 + Xi(t,i,j);
            Z2 = Z2 + Gamma(t,i);
        end
        if A_(i,j) ~= (Z1/Z2)
            correctA = 0;
            fprintf('%f ~= %f',A_(i,j),(Z1/Z2))
        end
    end
end
if correctA == 1
    disp 'A correct'
else
    disp 'A incorrect'
    
end


for j=1:N
    for k=1:M
        Z1 = 0;
        Z2 = 0;
        for t=1:T
            if O(t)==V(k)
                Z1 = Z1 + Gamma(t,j);
            end
            Z2 = Z2 + Gamma(t,j);
        end
        if B_(j,k) ~= (Z1/Z2)
            correctB = 0;
            fprintf('%f ~= %f\n',B_(j,k),(Z1/Z2))
        end
    end
end

if correctB == 1
    disp 'B correct'
else
    disp 'B incorrect'
end