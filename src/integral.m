function I=integral(f, a, b, n)
%Numerical integration using simpson's 3/8 method
%a=initial value, b=final value, n=number of segments for the algorithm
if mod(n,3) ~=0
    n = n + (3 - mod(n,3));
end
h = (b-a) / n;
x=a;
sum = f(x);
for i=1:n-1
    x = x+h;
    if mod(i,3)~=0
        sum = sum + 3*f(x);
    else
        sum = sum + 2*f(x);
    end
end
x = x+h;
sum = sum + f(x);
I = (3/8) * h * sum;
end