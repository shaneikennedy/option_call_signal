function [MC, mcBit] = monte_carlo( price, days, numSims)
%price is the price data of the stock closed at, days is the number of days into
%the future that you are simulating, numSims is number of monte carlo sims


 orgPrice = price;
 trueLength = length(price);
%  days = 60;
%  numSims = 50;

for k = 1:numSims %number of simulations
        price = orgPrice;

        for i = 1:days %number of days per simulation

            for j = 2:length(price) %pdr loop updates each day

                pdr(j) = log(price(j) / price(j-1));
                if isnan(pdr(j))
                    pdr(j) =[];
                end


            end

            adr = mean(pdr);
            standDev = std(pdr);
            drift = 0;
            x = rand;

            RVal = norminv(x,adr,standDev);
            price(trueLength+i) = price(trueLength+i-1)*exp(drift+RVal);

            MC(k,i) = price(trueLength+i);
            
        end
        
        
end



