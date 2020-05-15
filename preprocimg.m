function [bounded_skel_image, boundary_x, boundary_y] = preprocimg(input_image)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes a gray scale image and return its minimum
% bounded box skeleton image and the x-y coordinates of boundary points
% here boundary_x and boundary_y are coordinates with reference to lower
% left hand side of image, i.e. analogous to geometric (cartesian)
% coordinate system
%%%%%%%%%%% by Kalyan S Dash

% size_image=size(input_image);

input_image_inv=255.-input_image;

input_image_bin1=im2bw(input_image_inv);


% to compute the bounding box

[label_input_image_bin1 num]=bwlabel(input_image_bin1,8);


Iprops = regionprops(label_input_image_bin1);


Ibox = [Iprops.BoundingBox];


Ibox = reshape(Ibox,[4 num]);


% to extract bounded image

[~, ind]=sort(Ibox(3:4,:),2,'descend');

Iboxfinal=Ibox(:,ind(1));


 bounded_image=input_image_bin1(round(Iboxfinal(2)):round(Iboxfinal(2))+Iboxfinal(4)-1,round(Iboxfinal(1)):round(Iboxfinal(1))+Iboxfinal(3)-1);
 
 
% figure,imshow(bounded_image_scale)  % FIGURE 2


% % create an edge image
% % 
% input_image_bin2 = edge(bounded_image_scale);
% 
%        
% figure; imshow(input_image_bin2,[]);


bounded_image_scale=bwmorph(bounded_image,'dilate',2);


% create a skeleton image

skel_image = bwmorph(bounded_image_scale,'thin',Inf);

% figure;imshow(~skel_image,[])  % FIGURE 3



% compute the bounding box of a skeleton image

[label_input_image_bin1 num]=bwlabel(skel_image,8);


Iprops = regionprops(label_input_image_bin1);


Ibox = [Iprops.BoundingBox];


Ibox = reshape(Ibox,[4 num]);


% to extract bounded image


[~, ind]=sort(Ibox(3:4,:),2,'descend');

Iboxfinal=Ibox(:,ind(1));


 bounded_skel_image=skel_image(round(Iboxfinal(2)):round(Iboxfinal(2))+Iboxfinal(4)-1,round(Iboxfinal(1)):round(Iboxfinal(1))+Iboxfinal(3)-1);


figure,imshow(~bounded_skel_image)  


[B,L]=bwboundaries(bounded_skel_image);

boundary=B{1};

boundary=unique(boundary,'rows');

boundary_x=boundary(:,2);

boundary_y=size(L,1)-boundary(:,1)+1;


%%% alternate finding of boundary pixels
%%% here col_edge is x coordinate and row_edge is y

[row_edge ,col_edge]=find(bounded_skel_image==1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on, plot(boundary_x,boundary(:,1),'r.'); hold off


