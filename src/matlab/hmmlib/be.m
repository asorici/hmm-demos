function [ep] = mixture_fun(j, O, C, MU, SIGMA)
% MIXTURE_FUN computes the emission probabilities
%         Bfun(val, j) = P(O[t] = val | q[t] = Sj)
ep = zeros(size(O));
M = size(C,2);
for m=1:M
    ep(:) = ep(:) + mvnpdf(O,shiftdim(MU(j,m,:),1),shiftdim(SIGMA(j,m,:,:),2)) * C(j,m);
end