%%
% scrpit to screen for stocks that have dropped 3-4% below their 60d MA
% and run a mote carlo simulation on those that have. Only stocks that
% are expected to exceed today 60d MA price within the next 60 days will be
% displayed

%%screen
clear all;
fid = fopen('nas100.csv'); %using the NASDAQ100 because it's google's most complete index (that i've found)
symbols = textscan(fid,'%s');
contestants = {};

for i = 1:1:length(symbols{1,1})
    try
        closes = fetch_google(symbols{1,1}{i,1},60);
        today = closes(length(closes)); %today is the last element
        MA = mean(closes); %60d average 
        delta = (today - MA)/MA; %check for a drop
        if delta < -0.03 && delta > -0.04
            contestants{length(contestants)+1} = symbols{1,1}{i,1};
        end
    catch
        disp(symbols{1,1}{i,1})
        continue
    end
    
end



%%Run monte carlo simulations on the contestants
disp(contestants);
for i = 1:1:length(contestants)
    try
        disp(contestants{i})
        closes = fetch_google(contestants{i}, 60);
        strike = mean(closes);
        disp(strike);
        MC = monte_carlo(closes,60, 1000);
        MC(:,2:end+1)=MC;
        MC(:,1)=closes(length(closes));
        [r,c] = size(MC);
        mcBit = 0;
        exceed = 0;
        maxExceed = 0;
        expectedVal = zeros(60,1);
        for q = 1:c
            expectedVal(q,1) = mean(MC(:,q)); %calculate expected value each day, where the 
                                              %expected value is the formal def E[x] of a 
                                              %randomly distributed gaussian variable
            if expectedVal(q,1) >= strike %if the expected val at any day exceeds the strike price, we buy
                mcBit = 1;
            end
        end
        strikeArray(1:c,1) = strike;
        figure(i)
        plot(1:c,expectedVal,'r',1:c,strikeArray,'g');
        title(contestants{i});
        legend('Expected Value','Strike','Location', 'southeast');
        if mcBit
            disp('Buy');
        else
            disp('Pass');
        end
    catch
        continue
    end
end
%%end

