function createSong(file, dur8, play)
% Given a file name, a factor by which to multiply note durations, and a
% boolean indicating whether or not to actually play the song, this
% function will write a .wav file containing the song.

% Parse the text file to get the clefts of the song.
cA = makeMusic(file);
fs = 11025;

% Initialize song.
song = 0;

for ndx = 1:length(cA)
    
    % Get keys and duration vectors.
    keys = [cA{ndx}.keynum];
    dur = [cA{ndx}.duration];
    
    % Initialize current cleft.
    cleft = [];
    for k = 1:length(keys)
        
        % Convert current key number to a sinusoid.
        note = key2note(keys(k), dur8, fs, dur(k));
        
        % Concatenate with cleft.
        cleft = [cleft note];
    end
    
    % Zero fill to make all clefts the same length.
    if length(song) < length(cleft)
        song = [song zeros(1, length(cleft)-length(song))];
    elseif length(cleft) < length(song)
        cleft = [cleft zeros(1, length(song)-length(cleft))];
    end
    
    % Synthesize clefts.
    song = song + cleft;
    
end

% Transpose song.
song = song';

% Write song.
name = strtok(file, '.txt');
wavwrite(song, fs, 32, ['Library/' name '.wav'])

% Play song if instructed to do so.
if nargin > 2
    if play
        soundsc(song, fs)
    end
end

end
