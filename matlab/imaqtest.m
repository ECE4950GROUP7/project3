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
%nmaxframes = 200; % how many frames should be displayed during trial?
nmaxframes = 999999; % how many frames should be displayed during trial?
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

% Calculate difference image and display it.
while(vid.FramesAcquired <= nmaxframes) % stop after a user-specified number of frames
    
    data = getdata(vid,1); % get 1 frame from the video stream > defined using the second parameter
    im = data(:,:,:,1);
    
    dims = size(im);
    rows = dims(1);
    cols = dims(2);
    builder_image = im;
    lowThreshold = 100;
    highThreshold = 80;
    %varianceThreshold = 5;
    %disp(rows);
    %disp(cols);
    %disp(size(im));
    for y=1:rows
        for x=1:cols
            %disp(x);
            %disp(y);
            %disp(size(im));
            %disp('-------');
            red = im(y,x,1);
            green = im(y,x,2);
            blue = im(y,x,3);
            lowestVal = red;
            if green < lowestVal
                lowestVal = green;
            end
            if blue < lowestVal
                lowestVal = blue;
            end
            highestVal = red;
            if green > highestVal
                highestVal = green;
            end
            if blue > highestVal
                highestVal = blue;
            end
            %delta = max(red,green,blue);
            %delta = abs(red-green) + abs(red-blue) + abs(green-blue);
            if lowestVal > lowThreshold
                builder_image(y,x,1) = 0;
                builder_image(y,x,2) = 0;
                builder_image(y,x,3) = 0;
            elseif highestVal < highThreshold
                builder_image(y,x,1) = 0;
                builder_image(y,x,2) = 0;
                builder_image(y,x,3) = 0;
            else
                %variance = abs(red-green) + abs(red-blue) + abs(green-blue);
                if (x<40)||(y<40)||(x>600)||(y>440)
                    builder_image(y,x,1) = 0;
                    builder_image(y,x,2) = 0;
                    builder_image(y,x,3) = 0;
                else
                    builder_image(y,x,1) = im(y,x,1);
                    builder_image(y,x,2) = im(y,x,2);
                    builder_image(y,x,3) = im(y,x,3);
                end
            end
            %disp(im(y,x));
            %pause();
        end
    end
    thresholded_image = builder_image;
    binary_image = imbinarize(rgb2gray(builder_image));
    props = regionprops(binary_image);
    centroids = cat(1,props.Centroid);
    areas = cat(1,props.Area);
    numShapes = numel(props);
    
    MinAreaThreshold = 150;
    TriangleSquareThreshold = 350;
    CircleSquareThreshold = 800;
    output_image = im;
    shapes = [];
    if numShapes > 0
        for n =1:numShapes
            if areas(n) > MinAreaThreshold
                currentShape = ['','','',''];
                desc = '';
                if areas(n) > CircleSquareThreshold
                    %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-75)], 'Circle');
                    currentShape(1) = 1;
                    desc = 'Circle,';
                elseif areas(n) > TriangleSquareThreshold
                    %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-75)], 'Square');
                    currentShape(1) = 2;
                    desc = 'Square,';
                else
                    %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-75)], 'Triangle');
                    currentShape(1) = 3;
                    desc = 'Triangle,';
                end
                currentShape(2) = centroids(n,1);
                currentShape(3) = centroids(n,2);
                xcoord = round(centroids(n,1));
                ycoord = round(centroids(n,2));
                red = uint64(im(ycoord,xcoord,1));
                green = uint64(im(ycoord,xcoord,2));
                blue = uint64(im(ycoord,xcoord,3));
                bred = red*red;
                bgreen = green*green;
                bblue = blue*blue;
                %output_image(ycoord,xcoord,1) = 0;
                %output_image(ycoord,xcoord,2) = 255;
                %output_image(ycoord,xcoord,3) = 255;
                %desc = strcat(desc,',',int2str(xcoord),',',int2str(ycoord),',');
                %desc = strcat(desc,'(',int2str(red),',',int2str(green),',',int2str(blue),'),');
                if bblue - 100 > bred && bblue - 100 > bgreen
                    currentShape(4) = 1;
                    desc = strcat(desc,'blue');
                elseif bgreen - 1000 > bred && (red + green + blue) < 300po
                    currentShape(4) = 2;
                    desc = strcat(desc,'green');
                elseif bred - 2000 > bgreen
                    currentShape(4) = 3;
                    desc = strcat(desc,'red');
                else
                    currentShape(4) = 4;
                    desc = strcat(desc,'yellow');
                end
                %disp(desc);
                %disp(currentShape);
                horzcat(shapes,currentShape);
                output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], desc);
                %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], int2str(areas(n)));
                output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50]);
                output_image = insertShape(output_image,'circle',[centroids(n,1) centroids(n,2) 3],'LineWidth',2,'Color','red');
            end
        end
    end
    
    figure(fig_image);
    imshow(output_image);
    title_txt = sprintf('Image %d',vid.FramesAcquired);
    title(title_txt);
    
end

stop(vid);
delete(vid);
clear;