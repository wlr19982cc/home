function [output_img] = Bicubic(input_img, scale)
    % Get the input image size
	[row, col, depth] = size(input_img);  
    % Calculate the output image size
	row_scale = round(row*scale); 
	col_scale = round(col*scale);
	output_img = zeros(row_scale,col_scale,depth);
    
    % Extended fill
    img = zeros(row+4,col+4,depth);
    img(3:row+2,3:col+2,:) = input_img;
    img(1,1,:) = input_img(1,1,:);img(1,2,:) = input_img(1,1,:);
    img(2,1,:) = input_img(1,1,:);img(2,2,:) = input_img(1,1,:);
    img(1,col+3,:) = input_img(1,col,:);img(1,col+4,:) = input_img(1,col,:);
    img(2,col+3,:) = input_img(1,col,:);img(2,col+4,:) = input_img(1,col,:);
	img(row+3,1,:) = input_img(row,1,:);img(row+4,2,:) = input_img(row,1,:);
    img(row+3,1,:) = input_img(row,1,:);img(row+4,2,:) = input_img(row,1,:);
    img(row+3,col+3,:) = input_img(row,col,:);img(row+3,col+4,:) = input_img(row,col,:);
    img(row+4,col+3,:) = input_img(row,col,:);img(row+4,col+4,:) = input_img(row,col,:);
    
	img(1,3:col+2,:)=input_img(1,:,:);
    img(2,3:col+2,:)=input_img(2,:,:);
    img(row+3,3:col+2,:)=input_img(row-1,:,:);
    img(row+4,3:col+2,:)=input_img(row,:,:);
	img(3:row+2,1,:)=input_img(:,1,:);
    img(3:row+2,2,:)=input_img(:,2,:);
    img(3:row+2,col+3,:)=input_img(:,col-1,:);
    img(3:row+2,col+4,:)=input_img(:,col,:);
    img = double(img);

    for i=1:row_scale
        v=rem(i,scale)/scale;
        i1=floor(i/scale)+2;
        % CalculationA
        A=[S(1+v) S(v) S(1-v) S(2-v)];
        for j=1:col_scale
            u=rem(j,scale)/scale;
            j1=floor(j/scale)+2;
            % CalculationB
            B=[img(i1-1,j1-1,:) img(i1-1,j1,:) img(i1-1,j1+1,:) img(i1-1,j1+2,:); 
               img(i1,j1-1,:) img(i1,j1,:) img(i1,j1+1,:) img(i1,j1+2,:);
               img(i1+1,j1-1,:) img(i1+1,j1,:) img(i1+1,j1+1,:) img(i1+1,j1+2,:);
               img(i1+2,j1-1,:) img(i1+2,j1,:) img(i1+2,j1+1,:) img(i1+2,j1+2,:)];
           % CalculationC
            C=[S(1+u);S(u);S(1-u);S(2-u)];
            output_img(i,j,1)=(A*B(:,:,1)*C);
            output_img(i,j,2)=(A*B(:,:,2)*C);
            output_img(i,j,3)=(A*B(:,:,3)*C);
        end
    end
    output_img=uint8(output_img);
end

function [y] = S(x)
    if(abs(x)>=0&&abs(x)<1)
        y=1-2*x*x+abs(x^3);
    end
    if(abs(x)>=1&&abs(x)<2)
        y=4-8*abs(x)+5*x*x-abs(x^3);
        end
    if(abs(x)>=2)
        y=0;
    end
end