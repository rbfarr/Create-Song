function cA = makeMusic(file)
% Given the name of a text file containing musical data, this function will
% create a structure for both the treble and the base cleft, each with
% fields 'keynum' and 'duration'.

cd Library

% Open the .txt file.
fh = fopen(file);

% Initialize line.
line = fgetl(fh);

% Initialize key and duration counters.
keyCount = 1;
durCount = 1;

% Start with first cleft.
cleftCount = 1;
cleft = sprintf('cleft%d', cleftCount);

% Iterate through each line of the file.
while ischar(line)
    
    % If we find equal signs, switch to next cleft.
    if any(line == '=')
        cleftCount = cleftCount + 1;
        cleft = sprintf('cleft%d', cleftCount);
        keyCount = 1;
        durCount = 1;
        fgetl(fh);
        line = fgetl(fh);
    end
    
    % Iterate through the line.
    [key rest] = strtok(line, ',');
    while ~isempty(key)
        
        % Locate rests.
        if any(key == 'R')
            eval(sprintf('%s(keyCount).keynum = 0;', cleft));
        else
            eval(sprintf('%s(keyCount).keynum = str2num(key);', cleft));
        end
        
        % Increment counter and move to next key.
        keyCount = keyCount + 1;
        [key rest] = strtok(rest, ',');
    end
    
    % Don't go to next line when the line is empty. Prevents lines from
    % getting out of sync.
    if ~isempty(line)
        line = fgetl(fh);
    end
    
    % Iterate through line to get durations.
    [dur rest] = strtok(line, ',');
    while ~isempty(dur)
        eval(sprintf('%s(durCount).duration = 1/str2num(dur);', cleft));
        
        % Increment counter and move to next duration.
        durCount = durCount + 1;
        [dur rest] = strtok(rest, ',');
    end
    
    % Next line.
    line = fgetl(fh);
end

% Output clefts.
allClefts = sprintf('cleft%d ', 1:cleftCount);
allClefts(end) = [];
allClefts = ['{' allClefts '}'];
cA = eval(allClefts);

% Close file.
fclose(fh);

cd ..

end
