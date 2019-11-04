function [A,payoff,iterations,err] = npg2(M,U)

p = 1;  V = 1;  n = length(M);  s = sum(M);
A = zeros(max(M),n);
payoff = zeros(1,n);

 p=prod (M(1,:));
 
if p ~= size(U,1) || n ~= size(U,2)
    error('Error: Dimension mismatch!');
end

P = zeros(1,n);
N = zeros(1,n);
P(n) = 1;

for i = n-1 : -1 : 1
    P(i) = P(i+1) * M(i+1);
end

N = p./P;
 x0 = zeros(s,1); 
k = 1;

for i = 1 : n
    for j = 1 : M(1,i)
        x0(k) = 1 / M(1,i);
        k = k + 1;
    end
end

Us = sum(U,2);

for i = 1 : n
    V = V * (1 / M(i)) ^ M(i);
end

x0 = [x0 ; V * (sum(U,1)')];
Aeq = zeros(n,s+n); cnt = 0;

for i = 1 : n
    if i ~= 1
        cnt = cnt + M(i-1);
    end
    for j = 1 : s
        if j <= sum(M(1:i)) &&  j > cnt
            Aeq(i,j) = 1;
        end
    end
end

beq = ones(n,1);
I = ones(p,n);
counter = 0; count = 1;

for i = 1 : n
    for j = 1 : N(i)
        counter = counter + 1;
        if i ~= 1
            if counter > sum(M(1:i))
                counter = counter-M(i);
            end
        end
        for k = 1 : P(i)
            I(count) = counter;
            count = count + 1;
        end
    end
end

lb = zeros(s+n,1);
ub = ones(s+n,1);
pay = zeros(s,1);
counter = 0;

for i = 1 : n
    for j = 1 : M(i)
        counter = counter + 1;
        pay(counter) = i + s;
    end
end

for i = 1 : n
    lb(s+i) = -inf;
    ub(s+i) = inf;
end

[x,fval,exitflag,output] = gamer(n,Us,p,I,s,ub,lb,x0,Aeq,beq,pay,U);

count = 0;

for i = 1 : n
    for j = 1 : M(i)
        count = count + 1;
        A(j,i) = abs(x(count));
    end
    payoff(1,i) = x(s+i);
end

iterations = output.iterations;
err = abs(fval);
end