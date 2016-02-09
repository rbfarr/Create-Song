function noteOUT = key2note(key, dur8, fsamp, duration)
% Given the number of a key on a piano with respect to A (440 Hz), a
% factor by which to multiple the duration, a sampling frequency, and a
% duration, this function will create a sinusoid that represents that key.
% Interestingly, this function will also improve the sinusoid using an ADSR
% envelope and frequency harmonics.

% Create a time vector for the sinusoid.
t1 = 0;
t2 = duration * dur8;
tt = t1:(1/fsamp):t2;

% Set the frequency based on the key number. If the key number is 0, that
% means we want to rest for the duration specified.
if key == 0
    freq = 0;
else
    freq = 440*2^((key - 49)/12);
end

% Add an ADSR envelope by first finding the length of the time vector.
lgth = length(tt);

% Individual functions of the envelope.
A = linspace(0, 1, floor(0.17*lgth));
D = linspace(1, 0.8, floor(0.08*lgth));
S = linspace(0.8, 0.7, floor(0.58*lgth));
R = linspace(0.7, 0, floor(0.17*lgth));

% Put everything together.
E = [A D S R];

% Fill with 0's to match the length of the original time vector.
E = [E zeros(1, length(tt)-length(E))];

% Add the 2nd and 3rd harmonics to the sinusoid.
freqs = freq * (1:3);
amps = linspace(3, 1, length(freqs));

% Calculate the sinusoid.
noteOUT = 0;
for k = 1:length(freqs)
    noteOUT = noteOUT + real(amps(k) * exp(2i*pi*freqs(k)*tt));
end

% Apply the envelope.
noteOUT = noteOUT .* E;

end


