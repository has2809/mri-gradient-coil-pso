Bz_desired = @(z) 0.001*z;
fit = @(z,Zi) ( Bz(z,a,Zi,I) - Bz_desired(z) )^2;
gbest_val = integral(@(z)fit(z,[0 0 0 0 0 0]), -0.25, 0.25, 50);
gbest = [0 0 0 0 0 0];
for i=linspace(0,0.3,10)
    i
    for j=linspace(0,0.3,10)
        for k=linspace(0,0.3,10)
            for n=linspace(0,0.3,10)
                for m=linspace(0,0.3,10)
                    for l=linspace(0,0.3,10)
                        
                        f = integral(@(z)fit(z,[i j k n l m]), -0.25, 0.25, 15);
                        if f < gbest_val
                            gbest_val = f
                            gbest = [i j k n m l]
                        end
                    end
                end
            end
        end
    end
end