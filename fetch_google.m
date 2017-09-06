
function close = fetch_google(symbol, days)
    
    url = strcat('http://www.google.com/finance/historical?q=',symbol,'&output=csv');
    data = textscan(urlread(url),'%s');

    for j = 2:days+1
        csv{1,j-1} = strsplit(data{1,1}{j,1}, ',');
        close(1,j-1) = str2double(csv{1,j-1}{1,5});
    end
    
    close = fliplr(close);
    if length(close) > 300
        for i = 1:10
            disp('Call Shane!!!!!!!');
        end
        return;
    end
    

end
