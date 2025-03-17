clc;clear;close all
path = 'D:\Work\Fig9';
fullPath =[path, '\Fig'];
files = dir(fullfile(fullPath, '*.jpg'));
sharpnessValues = zeros(length(files), 1);
for k=1:length(files)
    if ~files(k).isdir        
            filePath = fullfile(fullPath, files(k).name);
            img = imread(filePath);
            sharpnessValues(k) = compute_tenengrad(img);            
    end    
end  
save(fullfile(path, 'sharpness_Xianzhu.mat'), 'sharpnessValues')
figure;grid on;
plot(sharpnessValues/max(sharpnessValues));
xlabel('Index');ylabel('sharpness');