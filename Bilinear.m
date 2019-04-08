function [output_img] = Bilinear(input_img, scale)
    % Get the input image size
	[row, col, depth] = size(input_img);  
    % Calculate the output image size
	row_scale = round(row*scale); 
	col_scale = round(col*scale);
	output_img = zeros(row_scale,col_scale,depth);
    % Extended fill
    img = zeros(row+2,col+2,depth);
    img(2:row+1,2:col+1,:) = input_img;
    img(1,1,:) = input_img(1,1,:);
    img(1,col+2,:) = input_img(1,col,:);
	img(row+2,1,:) = input_img(row,1,:);
    img(row+2,col+2,:) = input_img(row,col,:);
	img(1,2:col+1,:)=input_img(1,:,:);
    img(row+2,2:col+1,:)=input_img(row,:,:);
	img(2:row+1,1,:)=input_img(:,1,:);
    img(2:row+1,col+2,:)=input_img(:,col,:);
    %  Bilinear
    for x = 1:col_scale         
	    for y = 1:row_scale
            % The position of the scaled image coordinates at the original image
	        dy = y/scale; 
	        dx = x/scale;
            j = floor(dx)+1;
            i = floor(dy)+1;
	        dy = dy-floor(dy); 
	        dx = dx-floor(dx); 
	        output_img(y,x,:) = (1-dx)*(1-dy)*img(i,j,:) +(1-dx)*dy*img(i,j+1,:) + dx*(1-dy)*img(i+1,j,:) +(dx)*(dy)*img(i+1,j+1,:);
	    end
    end
	output_img = uint8(output_img);  
   end  