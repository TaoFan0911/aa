function tenengrad_value = compute_tenengrad_Central(gray_img, win_size)
if size(gray_img, 3) == 3
    gray_img = rgb2gray(gray_img); 
end
[height, width] = size(gray_img);

%central window calculation
half_size = floor(win_size/2);
center_x = floor(width/2);
center_y = floor(height/2);

% Calculating Window Boundaries
x_start = max(1, center_x - half_size);
x_end = min(width, center_x + half_size);
y_start = max(1, center_y - half_size);
y_end = min(height, center_y + half_size);

focus_window = gray_img(y_start:y_end, x_start:x_end);

% Tenengrad
sobel_kernel = fspecial('sobel');
Gx = imfilter(double(focus_window), sobel_kernel, 'conv');
Gy = imfilter(double(focus_window), sobel_kernel', 'conv');
tenengrad_value = sum(Gx(:).^2 + Gy(:).^2);