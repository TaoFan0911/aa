function tenengrad_value = compute_tenengrad_First(gray_img, win_size)

if size(gray_img, 3) == 3
    gray_img = rgb2gray(gray_img); 
end
gray_img = im2double(gray_img);

[rows, cols] = size(gray_img);

if win_size > min(rows, cols)
error('Window size exceeds image range');
end

% Calculation of first-order moments
[x_grid, y_grid] = meshgrid(1:cols, 1:rows);
sum_total = sum(gray_img(:));
xc = round(sum(x_grid(:).*gray_img(:)) / sum_total);
yc = round(sum(y_grid(:).*gray_img(:)) / sum_total);

% Calculating Window Boundaries
half_win = floor(win_size/2);
xmin = max(1, xc - half_win);
xmax = min(cols, xc + half_win);
ymin = max(1, yc - half_win);
ymax = min(rows, yc + half_win);

focus_window = gray_img(ymin:ymax, xmin:xmax);

% Tenengrad
sobel_kernel = fspecial('sobel');
Gx = imfilter(focus_window, sobel_kernel, 'replicate');
Gy = imfilter(focus_window, sobel_kernel', 'replicate');
tenengrad_value = sum(Gx(:).^2 + Gy(:).^2);