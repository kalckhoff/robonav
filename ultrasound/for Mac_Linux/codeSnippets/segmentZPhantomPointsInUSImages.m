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
%% IMAGE Process

%numImages=24;
% figure;
% 
% subplot(1,2,1)
% ims = plot(1);
% title('Image from Ultrasound device')
% 
% subplot(1,2,2)
% ims1 = plot(1);
% title('Segmented z-wire cross-sectional points')
% ims2 = plot(1);

number_of_pictures = numImages-1;
c1 = zeros (number_of_pictures,2);
c2 = zeros (number_of_pictures,2);
c3 = zeros (number_of_pictures,2);
for n=0:number_of_pictures
    %delete(ims); delete(ims1); delete(ims2);
    %data = ['data/ultrasoundImagesAndPoses/fileoutpos.txt_' num2str(n) '.jpg'];
    data = ['data/ultrasoundImagesAndPoses/fileout_' num2str(n) '.jpg'];
    I = imread(data);
    % subplot(1,2,1)
    % ims = imshow(I);
    title('Image from Ultrasound device')
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
    c1 (n+1,:) = centroids_selected_2 (1,:);
    c2 (n+1,:) = centroids_selected_2 (2,:);
    c3 (n+1,:) = centroids_selected_2 (3,:);
    check (n+1,1) = abs(c1 (n+1,2) - c2 (n+1,2) ) ;
    check (n+1,2) = abs(c1 (n+1,2) - c3 (n+1,2) ) ;
    check (n+1,3) = abs(c2 (n+1,2) - c3 (n+1,2) ) ;
    if check (n+1,1) > 14  || check (n+1,2)>14  || check (n+1,3) > 14
       % Zweite Filterschleife mit anderen Einstellungen
        level = graythresh(I);
        BW = im2bw(I,level);
        %[B,L,N] = bwboundaries(BW,8, 'holes')
        BW2 = bwareafilt(BW,[30 240]);
            for k = 1:20
                for i = 1:640
                    BW2 (k,i) = 0;
                end
            end
            imshow(BW2)
        s = regionprops(BW2,'centroid');
        centroids = cat(1, s.Centroid);
        centroids_sort = sortrows(centroids,2);
        centroids_selected_1 = centroids_sort(1:3,:);  
        centroids_selected_2 = sortrows(centroids_selected_1);
        c1 (n+1,:) = centroids_selected_2 (1,:);
        c2 (n+1,:) = centroids_selected_2 (2,:);
        c3 (n+1,:) = centroids_selected_2 (3,:);
        check (n+1,1) = abs(c1 (n+1,2) - c2 (n+1,2) ) ;
        check (n+1,2) = abs(c1 (n+1,2) - c3 (n+1,2) ) ;
        check (n+1,3) = abs(c2 (n+1,2) - c3 (n+1,2) ) ;    
    end 
    

    if check (n+1,1) > 10  || check (n+1,2)>10  || check (n+1,3) > 10 
        hold on
        imshow(I);
        new_points = zeros (3,2);
        [x, y] = ginputc(3, 'Color', 'b');
        new_points (:,1) = x;
        new_points (:,2) = y;
        %new_points = ginput(3);
        %plot(new_points(:,1),new_points(:,2), 'b*');
        hold off
        new_points_2 = sortrows(new_points);
        c1 (n+1,:) = new_points_2 (1,:);
        c2 (n+1,:) = new_points_2 (2,:);
        c3 (n+1,:) = new_points_2 (3,:);
        hold on
        imshow(I);
        title('Image from Ultrasound device')
        plot(new_points_2(1,1), new_points_2(1,2), 'bx');
        plot(new_points_2(2,1), new_points_2(2,2), 'bx');
        plot(new_points_2(3,1), new_points_2(3,2), 'bx');
        hold off
        pause (1)
    end
end

%%
% These are just example of expected segmentation results. You would
% eventually not need the following two lines.
filenamePrefSplit = strsplit(filenamePref, {'/','\'});

% filenameSegPref = [strjoin(filenamePrefSplit(1:end-1),'/') '/seg/seg'];
% ISeg = imread([filenameSegPref '0.jpg']);

% creating a figure with dummy structure
% scrsz = get(groot,'ScreenSize');
% figure('Position',[10 scrsz(4)*3/4 scrsz(3)*3/4 scrsz(4)*3/4]);
% 
% subplot(1,2,1)
% ims = imshow(I);
% title('Image from Ultrasound device')
% 
% subplot(1,2,2)
% ims1 = imshow(I);
% title('Segmented z-wire cross-sectional points')

sz = size(I);
allImages = zeros(sz(1),sz(2),numImages);

xmmPerPxAll = zeros(1,numImages);
ymmPerPx = 40.0 / 480; % known

for idx = 0:numImages-1
%     delete(ims); delete(ims1);
    disp(idx)
    % Reading the image
    I = imread([filenamePref num2str(idx) '.jpg']);
    allImages(:,:,idx+1) = I;
    
    %ISeg = imread([filenameSegPref num2str(idx) '.jpg']);
    % Showing the US image
%     subplot(1,2,1);
%     imshow(I)
%     title('Image from Ultrasound device')
    %
    % Implement here the segmentation
    % ...
    %
    % Showing the original thresholded image with centroids
%     subplot(1,2,2);
%     imshow(I)
%     title('Expected segmentation results')
    
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
end