% Simulation Signal POCSAG entre TX et RX
% ---------------------------------------
% Auteur : Patrick Chêne
% QRZ : 14VK11
% Date : 25 avril 2025
% --------------------
% Configuration matérielle :
%          Ordinateur portable MSI Cyborg 14 A13VF-001FR
%          OS : Windows 11
%          Logiciel : MATLAB version 2024b
% ----------------------------------------
%% Nettoyage
clc; clear; close all;

%% Paramètres
fc = 1200;          % Fréquence porteuse
fs = 10*fc;         % Fréquence d'échantillonnage
bit_rate = 1200;    % Débit binaire
snr_dB = 50;         % Rapport signal/bruit

%% Message
address = '1234567';
message = 'URGENT: Contactez le bureau ASAP';
fprintf('Message original:\nAdresse: %s\nMessage: %s\n\n', address, message);

%% Émetteur
[pogsag_bits, preamble] = pogsag_encoder(address, message);
[modulated_signal, t] = pogsag_modulator(pogsag_bits, fc, fs, bit_rate);

%% Canal
received_signal = awgn(modulated_signal, snr_dB, 'measured');

%% Récepteur
demod_bits = pogsag_demodulator(received_signal, fc, fs, bit_rate, length(pogsag_bits));
[decoded_address, decoded_message] = pogsag_decoder(demod_bits, length(preamble));

%% Résultats
fprintf('Message décodé:\nAdresse: %s\nMessage: %s\n', decoded_address, decoded_message);

%% Visualisation des signaux
figure('Position', [100 100 1000 800]);

% 1. Signaux temporels
subplot(4,1,1);
plot(t(1:1000), modulated_signal(1:1000), 'b'); hold on;
plot(t(1:1000), received_signal(1:1000), 'r');
title('Signaux modulé (bleu) et reçu (rouge)');
xlabel('Temps (s)'); ylabel('Amplitude');
legend('Émis', 'Reçu');
grid on;

% 2. Trame démodulée complète
subplot(4,1,2);
stem(demod_bits, 'filled', 'MarkerSize', 2, 'Color', [0.5 0 0.5]);
title('Trame démodulée complète');
xlabel('Index du bit'); ylabel('Valeur');
xlim([0 length(demod_bits)]);
ylim([-0.1 1.1]);
grid on;

% 3. Zoom sur les 100 premiers bits
subplot(4,1,3);
stem(pogsag_bits(1:100), 'b', 'filled', 'MarkerSize', 4); hold on;
stem(demod_bits(1:100), 'r', 'filled', 'MarkerSize', 2);
title('Comparaison bits émis (bleu) vs reçus (rouge)');
xlabel('Index du bit'); ylabel('Valeur');
legend('Émis', 'Reçu');
grid on;

% 4. Détection des erreurs
error_positions = find(pogsag_bits(1:min(end,length(demod_bits))) ~= demod_bits(1:min(end,length(pogsag_bits))));
subplot(4,1,4);
stem(error_positions, ones(size(error_positions)), 'r', 'filled', 'MarkerSize', 4);
title('Position des bits erronés');
xlabel('Index du bit'); ylabel('Erreur');
xlim([0 length(demod_bits)]);
ylim([0 1.5]);
grid on;

%% Fonction pogsag_encoder
function [pogsag_bits, preamble] = pogsag_encoder(address, message)
    % Conversion adresse (21 bits)
    address_num = str2double(address);
    address_bits = de2bi(address_num, 21, 'left-msb');
    
    % Message en ASCII (7 bits par caractère)
    msg_bits = [];
    for c = message
        msg_bits = [msg_bits, de2bi(double(c), 7, 'left-msb')];
    end
    
    % Préambule allongé (1024 bits)
    preamble = repmat([1 0], 1, 512);
    
    % Mot de synchronisation très distinctif
    sync_word = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
    
    % Assemblage final
    pogsag_bits = [preamble, sync_word, address_bits(:)', msg_bits(:)'];
end

%% Fonction pogsag_modulator
function [signal, t] = pogsag_modulator(bits, fc, fs, bit_rate)
    samples_per_bit = round(fs/bit_rate);
    t = (0:length(bits)*samples_per_bit-1)/fs;
    signal = zeros(size(t));
    
    for i = 1:length(bits)
        idx = (i-1)*samples_per_bit+1:i*samples_per_bit;
        freq = fc * (1 + bits(i));
        signal(idx) = cos(2*pi*freq*t(idx));
    end
end

%% Fonction pogsag_demodulator
function bits = pogsag_demodulator(signal, fc, fs, bit_rate, expected_length)
    samples_per_bit = round(fs/bit_rate);
    bits = zeros(1, expected_length);
    t = (0:samples_per_bit-1)/fs;
    
    for i = 1:expected_length
        start = (i-1)*samples_per_bit+1;
        fin = min(start+samples_per_bit-1, length(signal));
        segment = signal(start:fin);
        
        % Détection différentielle améliorée
        I0 = sum(segment .* cos(2*pi*fc*t(1:length(segment))));
        I1 = sum(segment .* cos(2*pi*2*fc*t(1:length(segment))));
        
        bits(i) = I1 > I0;
    end
end

%% Fonction pogsag_decoder
function [address, message] = pogsag_decoder(bits, ~)
    % Mot de synchronisation étendu
    sync_word = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
    sync_length = length(sync_word);
    
    % Recherche par corrélation normalisée
    corr = normxcorr2(sync_word, bits);
    [max_corr, max_pos] = max(corr);
    
    % Debug: Afficher la courbe de corrélation
    figure('Name','Debug Corrélation');
    plot(corr); 
    title(sprintf('Corrélation (Score max: %.2f)', max_corr));
    xlabel('Position'); ylabel('Corrélation');
    grid on;
    
    % Validation détection
    if max_corr < 0.65
        error('Échec détection synchronisation (score: %.2f < 0.65)', max_corr);
    end
    
    % Position des données
    data_start = max_pos - sync_length + sync_length + 1;
    
    % Extraction adresse (21 bits)
    if data_start+20 > length(bits)
        error('Trame trop courte pour l''adresse');
    end
    address_bits = bits(data_start:data_start+20);
    address = num2str(bi2de(address_bits, 'left-msb'));
    
    % Extraction message (7 bits par caractère)
    message = '';
    msg_start = data_start + 21;
    for i = msg_start:7:length(bits)
        if i+6 > length(bits), break; end
        byte = bits(i:i+6);
        message = [message, char(bi2de(byte, 'left-msb'))];
    end
end