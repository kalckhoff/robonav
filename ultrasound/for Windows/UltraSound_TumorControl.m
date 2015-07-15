function [ zInImageToCamera_P_Tumor ] = UltraSound_TumorControl()
%ULTRASOUND_TUMORCONTROL Summary of this function goes here
%   Detailed explanation goes here

tfImageToProbe= load('tfMatImageToProbe.txt');
image_tumor = 'TumorImageAndPose\fileout.jpg';
H_Matrix_ProbeToCamera = load('TumorImageAndPose\ProbePose.txt');
scaleToMm= load('scaleMat.txt');

    hold on
        imshow(image_tumor);
        zImage_Probe = zeros (2,1);
        [x, y] = ginputc(1, 'Color', 'b');
        zImage_Probe (1,1) = x;
        zImage_Probe (2,1) = y;
        %new_points = ginput(3);
        %plot(new_points(:,1),new_points(:,2), 'b*');
    hold off
% If the segmented locations are in pixels, convert them to 'mm'.

zImage_Probe_mm = scaleToMm * zImage_Probe;
zImage_Probe_mm (3,1) = 0;
zImage_Probe_mm (4,1) = 1;
zInImageToCamera_P_Tumor = H_Matrix_ProbeToCamera * tfImageToProbe * zImage_Probe_mm;


end


