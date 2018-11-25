clc;clear;
a = 6:-1:1;
p1 = a./sum(a)
prop = cumsum(a./sum(a));
total = 10000;
c = zeros(1, 6);
for i = 1:total
    index = roulette(a);
    c(index) = c(index)+1;
end
c