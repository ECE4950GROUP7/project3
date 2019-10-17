% Test the image acquisition toolbox
% ECE 495 Fall 2012
%   ninad & matt, october 14 2012

% Notes
% 	- Source code modified from its original form ('Getting Started', pg 20) 
%   in Image Acquisition Toolbox User Guide for R2012a.
function imaqtest

%
clc; close all; clear all;
imaqreset; % reset device configuration. helps release open device handles.

% user inputs 
nmaxframes = 200000; % how many frames should be displayed during trial?
nframegrab = 15; % get every nth frame from the camera

% create the video input object. specify the image format and size
%vid = videoinput('winvideo', 1, 'MJPG_160x120');
vid = videoinput('winvideo', 1, 'MJPG_640x480'); % capture a RGB image of size 640x480 pixels

% Set video input object properties for this application.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = nframegrab; % grab every nth frame from the device

% Create a figure window.
fig_image = figure;

% Start acquiring frames.
start(vid);

%get background image
background_image = getdata(vid,1);
background_image = background_image(:,:,:,1);

% Calculate difference image and display it.
while(vid.FramesAcquired <= nmaxframes) % stop after a user-specified number of frames
    
    data = getdata(vid,1); % get 1 frame from the video stream > defined using the second parameter
    im = data(:,:,:,1);
    %you're just going to have to trust that this is a good set of filters to run through
    builder_image = imsubtract(background_image,im);
    builder_image = abs(builder_image);
    builder_image = rgb2gray(builder_image);
    builder_image = imadjust(builder_image,[0.01 1]);
    %wiener filter tries to remove noise from the image
    builder_image = wiener2(builder_image,[7 7]);
    %without a gaussian blur, triangle edges are VERY harsh and have many artifacts
    %if one of the artifacts is disconnected from the main triangle blob, regionprops
    %detects it as its own shape
    builder_image = imgaussfilt(builder_image);
    builder_image = imbinarize(builder_image, 0.01);
    builder_image = imerode(builder_image,strel('disk',2,4));
    builder_image = imdilate(builder_image,strel('disk',2,4));
    %we can use this if we want to find the edges of the shapes for whatever reason
    %edge_values = edge(output_image);
    %regionprops does a shazam transform to get centroids, bounding boxes, and area of
    %every shape in a binary image
    region_props = regionprops(builder_image);
    centroids = cat(1,region_props.Centroid);
    numShapes = numel(region_props);
    output_image = im;
    %matlab will freak out if we try to iterare from 1:0 later on, so I encapsulated our
    %for loop within this check to make sure that never happens
    if numShapes > 0
        %useful lines for debugging
        %disp(numShapes);
        %disp(centroids);
        %pause();
        for n =1:numShapes
            output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50]);
            %this line should be capable of plotting the centroids of the regions as well
            %output_image = insertShape(output_image,'circle',[centroids(n,1) centroids(n,2) 3],'LineWidth',2,'Color','red');
        end
    end
    figure(fig_image);
    %this shows us the real image with the detected shapes bounded
    imshow(output_image);
    %uncomment this instead to show the massively filtered image
    %imshow(builder_image);
    title_txt = sprintf('Image %d',vid.FramesAcquired);
    title(title_txt);
    hold on;
    %this plots the centroids of the regions detected
    if size(centroids) >= size([1 1])
        plot(centroids(:,1),centroids(:,2),'b*');
    end
    hold off;
    
end

stop(vid);
delete(vid);
clear;
