jsonText = fileread('LAH10k.json');
% jsonText = fileread('vanguard10k.json');
data = jsondecode(jsonText);

tally = struct();
index = 0;

for i = 1:length(data)

if length(data(i).battles) ~= 2
    data(i).time = NaN;
    continue
end

index = index + 1;

single = 0;

DA = 0;

otorp = 0;

ctorp = 0;

cvshell = 0;


for j = 1:2
    if data(i).battles(j).data.api_opening_flag == 1
        % otorp
        otorp = otorp + 1;
    end
    
    % count all attacks first, deduct DA and cv shelling
    single = length(data(i).battles(j).data.api_hougeki1.api_at_list);
    for k = 1:length(data(i).battles(j).data.api_hougeki1.api_at_list)
        % tally first shelling
        if data(i).battles(j).data.api_hougeki1.api_at_eflag(k) == 1
        if data(i).battles(j).data.api_ship_ke(data(i).battles(j).data.api_hougeki1.api_at_list(k)+1) == 1528 
            % cv shelling
            cvshell = cvshell + 1;
            single = single - 1;
        end
        end

        if data(i).battles(j).data.api_hougeki1.api_at_type(k) == 2
            DA = DA + 1;
            single = single - 1;
        end
    end

    if data(i).battles(j).data.api_hourai_flag(2) == 1
        for k = 1:length(data(i).battles(j).data.api_hougeki2.api_at_list)
            % tally second shelling
            if data(i).battles(j).data.api_hougeki2.api_at_eflag(k) == 1
            if data(i).battles(j).data.api_ship_ke(data(i).battles(j).data.api_hougeki2.api_at_list(k)+1) == 1528 
                % cv shelling
                cvshell = cvshell + 1;
                single = single - 1;
            end
            end
    
            if data(i).battles(j).data.api_hougeki2.api_at_type(k) == 2
                DA = DA + 1;
                single = single - 1;
            end
        end
    end

    if data(i).battles(j).data.api_hourai_flag(4) == 1  
        % closing torp
        ctorp = ctorp + 1;
    end

end

tally(index).single = single;
tally(index).DA = DA;
tally(index).otorp = otorp;
tally(index).ctorp = ctorp;
tally(index).cvshell = cvshell;

baseline = 180; % time of sortie excluding all attack aninmations
tally(index).time = baseline + [1.7 2.8 3.5 5.3 3.7]*[single;DA;otorp;ctorp;cvshell];

end

avgtime = mean([tally.time])











