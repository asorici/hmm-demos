L = ceil(rand()*10000);
N = ceil(rand()*50);

TMax = 500;
T = ceil(rand(1, L) * TMax);
R = 5;
M = 10;

%O = rand(L,TMax,R);
O = zeros(L, TMax, R);
for l=1:L
    O(l, 1:T(l), :) = rand(1, T(l), R);
end

Gamma = rand(L,TMax,N,M);

t5 = cputime;
X = repmat(Gamma, [1 1 1 1 R]) .* permute(repmat(O, [1 1 1 N M]), [1 2 4 5 3]);
MU3 = reshape(sum(sum(X,1),2), [N M R]);
t6 = cputime;


t1 = cputime;
MU1 = zeros(N,M,R);
for i=1:N
    for m=1:M
        for l=1:L
            for t=1:T(l)
                MU1(i,m,:) = MU1(i,m,:) + Gamma(l,t,i,m) * O(l,t,:);
            end
        end
    end
end
t2 = cputime;
   
t3 = cputime;
MU2 = zeros(N,M,R);
for i=1:N
    for m=1:M
        for l=1:L
                MU2(i,m,:) = MU2(i,m,:) + ...
                    reshape(reshape(Gamma(l,1:T(l),i,m),[1 T(l)]) * ...
                    reshape(O(l,1:T(l),:), [T(l) R]), [1 1 5]);
        end
    end
end
t4 = cputime;

D12 = MU1~=MU2

MU1-MU2
MU1-MU3


sum(sum(sum(MU2~=MU3)))
sum(sum(sum(MU3~=MU1)))

t2-t1
t4-t3
t6-t5

