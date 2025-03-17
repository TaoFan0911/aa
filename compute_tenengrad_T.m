function tenengrad_value = compute_tenengrad_T(gray_img)

if size(gray_img, 3) == 3
    gray_img = rgb2gray(gray_img); 
end
gray_img = im2double(gray_img);
horizontal_ratio = 0.3;        
vertical_ratio = 0.2;          
overlap_ratio = 0.15;          
[rows, cols] = size(gray_img);

% Bottom Horizontal Strip Parameters
h_height = round(rows * horizontal_ratio);
h_y_start = rows - h_height + 1;  

% Top Vertical Strip Parameters
v_width = round(cols * vertical_ratio);
v_x_start = round(cols/2 - v_width/2);

% Overlap area adjustment
overlap_pixels = round(h_height * overlap_ratio);
horizontal_mask = false(rows, cols);
horizontal_mask(h_y_start:end, :) = true;
vertical_mask = false(rows, cols);
vertical_end = h_y_start - 1 + overlap_pixels;  
vertical_mask(1:vertical_end, v_x_start:v_x_start+v_width-1) = true;
inverted_t_mask = horizontal_mask | vertical_mask;
sobel_kernel = fspecial('sobel');
Gx_full = imfilter(gray_img, sobel_kernel, 'replicate');
Gy_full = imfilter(gray_img, sobel_kernel', 'replicate');

Gx_window = Gx_full(inverted_t_mask);
Gy_window = Gy_full(inverted_t_mask);
tenengrad_value = sum(Gx_window(:).^2 + Gy_window(:).^2);