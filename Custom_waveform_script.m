% Custom waveform script for IQtools
% Author: Ashvin Scott
% Date created: 26/07/24
% Details: Creates custom waveform from binary inputs & accounts for a
% requested duty cycle. Uses a sample rate of 64e9 & pulse rate of 1e9 but
% this can be changed as required.

clear, clc;

%% Generate waveform

% Get digit binary - Sequency of 1s & 0s
binary_column = input("\nInput digit binary string (e.g. [1 0 1 0 ...]):\n");

% Get duty cycle - Percent of pulse which will be on (1)
duty_cycle = input("\nInput duty cycle as a percentage (e.g. 10 for 10%):\n") / 100;

% No. of pulses - Directly determined by no. of bits
pulses = length(binary_column);

% No. cells per pulse - Total cells used, includes on (1) & off (0)
cells_per_pulse = 6400 / pulses;

% Prepare array - Improves performance to set up now
waveform = zeros(6400, 1); % 6400 rows - as expected by AWG

% Create waveform - Using all of the above info

for i = 1 : pulses  % Loops for each pulse

    % Calculate START & END indices for current pulse
    start_index = floor(1 + cells_per_pulse * (i - 1));
    end_index = floor(start_index + duty_cycle * cells_per_pulse - 1);
    
    % Replace each cell, within the duty cycle, with respective bit value
    waveform(start_index:end_index) = binary_column(i);

end

%% Paste into .txt file

% Create file
file_name = sprintf('Custom, non-adjusted, 1010 16bit, dc=%d.txt', duty_cycle*100);
file_ID = fopen(file_name, 'w+');

% Write
for i = 1:length(waveform)
    fprintf(file_ID, '%d\n', waveform(i));
end

% Close file
fclose(file_ID);
