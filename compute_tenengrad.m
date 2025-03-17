function tenengrad_value = compute_tenengrad(gray_img)

if size(gray_img, 3) == 3
    gray_img = rgb2gray(gray_img); 
end
% Calculate grayscale histograms and probability distributions
histogram = imhist(gray_img);
prob = histogram / numel(gray_img);

% Create a significance lookup table
gray_levels = 0:255;
saliency_lut = zeros(256, 1);
for k = 0:255
    saliency_lut(k+1) = sum(abs(k - gray_levels) .* prob');
end
saliency_map = saliency_lut(double(gray_img) + 1);
saliency_map = saliency_map / max(saliency_map(:));

% Subregional summation and binarization
block_size = [32, 32]; 
sum_blocks = blockproc(saliency_map, block_size, @(b) sum(b.data(:)));

% Automatic threshold determination
threshold = mean(sum_blocks(:)) * 0.5;
binary_blocks = sum_blocks > threshold;
binary_map = repelem(binary_blocks, block_size(1), block_size(2));
binary_map = binary_map(1:size(gray_img,1), 1:size(gray_img,2));

% Calculation of first-order moments
[m, n] = size(binary_map);
[x, y] = meshgrid(1:n, 1:m);
m00 = sum(binary_map(:));
if m00 == 0
    error('No significant areas detected, adjust parameters');
end
xc = round(sum(x(:).*binary_map(:)) / m00);
yc = round(sum(y(:).*binary_map(:)) / m00);
win_size = 900;
half_win = floor(win_size/2);
xmin = max(1, xc - half_win);
xmax = min(n, xc + half_win);
ymin = max(1, yc - half_win);
ymax = min(m, yc + half_win);
focus_window = gray_img(ymin:ymax, xmin:xmax);

% Tenengrad
sobel_kernel = fspecial('sobel');
Gx = imfilter(double(focus_window), sobel_kernel, 'replicate');
Gy = imfilter(double(focus_window), sobel_kernel', 'replicate');
tenengrad_value = sum(Gx(:).^2 + Gy(:).^2);