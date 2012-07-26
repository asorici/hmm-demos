x=0:0.1:10;
alpha = 2;
y=gaussmf(x,[2 5]);
z=gaussmf(x,[2/alpha 5]);
w=y/alpha;
plot(x,y)
hold on
plot(x,z)
hold on
plot(x,w)
