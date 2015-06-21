function [c1, c2, c3, xmmPerPx, ymmPerPx, allImages] = segmentZPhantomPointsInUSImages(filenamePref, numImages)
%SEGMENTZPHANTOMPOINTSINUSIMAGES Segments the Ultrasound images
%   SEGMENTZPHANTOMPOINTSINUSIMAGES(FILENAMEPREF, NUMIMAGES)
%   Reads in NUMIMAGES images with the prefix FILENAMEPREF and outputs the
%   locations of the cross-sectional points of z-wire phantom.
%
%   Modified 22th May 2015
%   Omer Rajput - MTEC, TUHH.

% Read images
%I = imread([filenamePref 'fileout_0.jpg']);
number_of_pictures = 19;
c1 = zeros (number_of_pictures,2);
c2 = zeros (number_of_pictures,2);
c3 = zeros (number_of_pictures,2);
for n=1:number_of_pictures
    data = ['data/ultrasoundImagesAndPoses/fileout_' num2str(n) '.jpg'];
I = imread(data);
%imshow(I)
%[centers, radii, metric] = imfindcircles(I,[15 30])
%background = imopen(I,strel('disk',5));
%I = I - background;
level = graythresh(I);
BW = im2bw(I,level);
%[B,L,N] = bwboundaries(BW,8, 'holes')
BW2= bwareafilt(BW,[5 120]);
for k = 1:20
    for i = 1:640
        BW2 (k,i) = 0;
    end
end
s = regionprops(BW2,'centroid');
centroids = cat(1, s.Centroid);
centroids_sort = sortrows(centroids,2);
centroids_selected_1 = centroids_sort(1:3,:);  
centroids_selected_2 = sortrows(centroids_selected_1);
c1 (n,:) = centroids_selected_2 (1,:);
c2 (n,:) = centroids_selected_2 (2,:);
c3 (n,:) = centroids_selected_2 (3,:);
imshow(BW2)
hold on
plot(centroids_selected_2(:,1),centroids_selected_2(:,2), 'b*')
%pause (1)
end
% These are just example of expected segmentation results. You would
% eventually not need the following two lines.
filenamePrefSplit = strsplit(filenamePref, {'/','\'});

filenameSegPref = [strjoin(filenamePrefSplit(1:end-1),'/') '/seg/seg'];
ISeg = imread([filenameSegPref '0.jpg']);

% creating a figure with dummy structure
scrsz = get(groot,'ScreenSize');
figure('Position',[10 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);

subplot(1,2,1)
ims = imshow(I);
title('Image from Ultrasound device')

subplot(1,2,2)
ims1 = imshow(ISeg);
title('Segmented z-wire cross-sectional points')

sz = size(I);
allImages = zeros(sz(1),sz(2),numImages);

xmmPerPxAll = zeros(1,numImages);
ymmPerPx = 40.0 / 480; % known

for idx = 0:numImages-1
    delete(ims); delete(ims1);
    disp(idx)
    % Reading the image
    I = imread([filenamePref num2str(idx) '.jpg']);
    allImages(:,:,idx+1) = I;
    
    ISeg = imread([filenameSegPref num2str(idx) '.jpg']);
    % Showing the US image
    subplot(1,2,1);
    imshow(I)
    title('Image from Ultrasound device')
    %
    % Implement here the segmentation
    % ...
    %
    % Showing the original thresholded image with centroids
    subplot(1,2,2);
    imshow(ISeg)
    title('Expected segmentation results')
    
    % It is also helpful to estimate mm per pixel
    % Counting the white pixels in each column, to find out the width in
    % pixels. This will correspond to 38mm (from the probe).
    sumRow = sum(I,1);
    indF = find(sumRow, 1, 'first');
    indL = find(sumRow, 1, 'last');
    widthPxUS = indL - indF + 1;
    xmmPerPxAll(idx+1) = 38.0 / widthPxUS;
    pause(0.1);
end
xmmPerPx = mean(xmmPerPxAll);

% Outputting all zeros - please modify it based on the segmentation above.
c1 = zeros(numImages,2);
c2 = zeros(numImages,2);
c3 = zeros(numImages,2);

end