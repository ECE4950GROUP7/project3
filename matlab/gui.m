global shapes
global iterator_current
global currentlySelected
global cycle_iterator;
shapes = [];
iterator_current = 1;
currentlySelected = 1;
cycle_iterator = 1;
% define button positions
lbl1_pos = [10 390 200 22];
btn1_pos = [10 lbl1_pos(2)-22+200 200 22];
lbl2_pos = [10 btn1_pos(2)-22-20 200 22];
btn2_pos = [10 lbl2_pos(2)-22 200 22];
%lbl3_pos = [0 btn2_pos(2)-22 200 22];
btn3_pos = [10 btn2_pos(2)-22*4-5 200 22*4];
lbl4_pos = [10 btn3_pos(2)-22-20 200 22];
btn4_pos = [10 lbl4_pos(2)-22*2 300 22*2];
lbl5_pos = [10 btn4_pos(2)-22*3-20 200 22];
btn5_pos = [10 lbl5_pos(2)-22*3 200 22*4];

fig = uifigure('Name', 'Gameboard GUI', 'Position',[5 200 220 620]);

% % Cycle through all the stickers on the board
% uilabel(fig,...
%     'Position',[lbl1_pos(1), lbl1_pos(2), lbl1_pos(3), lbl1_pos(4)],...
%     'Text','Cycle to next sticker');
% btn1 = uibutton(fig,...
%    'Text', 'Next Sticker',...
%    'Position',[btn1_pos(1), btn1_pos(2), btn1_pos(3), btn1_pos(4)],...
%    'ButtonPushedFcn', @(btn,event) cycleButtonPushed(btn));

% Cycle to next button of selected color
uilabel(fig,...
    'Position',[lbl2_pos(1), lbl2_pos(2), lbl2_pos(3), lbl2_pos(4)],...
    'Text','Cycle to next sticker of given color');

% Create Toggle buttons to allow selection of a color to cycle through.
bg = uibuttongroup(fig,'Position',btn3_pos);
tb1 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 0 190 22],'Text','Red');
tb2 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*1 190 22],'Text','Green');
tb3 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*2 190 22],'Text','Blue');
tb4 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*3 190 22],'Text','Yellow');
btn2 = uibutton(fig,...
    'Text', 'Next Colored Sticker',...
    'Position',btn2_pos,...
    'ButtonPushedFcn', @(btn,event) cycleSelectedColorButtonPushed(btn,bg.SelectedObject));


% tb2 = uitogglebutton(bg,'Position',[11 140 140 22],'Text','Green');
% tb3 = uitogglebutton(bg,'Position',[11 115 140 22],'Text','Blue');
% tb4 = uitogglebutton(bg,'Position',[11 90 140 22],'Text','Yellow');
%bg.Scrollable = 'on';

% Provide input as text entry for functionality to
% go to any sticker chosen by user.
%sticker_color = uieditfield(fig,'Position',[btn4_pos(1), btn4_pos(2), btn4_pos(3), btn4_pos(4));
%sticker_color = uieditfield(fig,'Position',[btn4_pos(1), btn4_pos(2), btn4_pos(3), btn4_pos(4));
% Provide input as dropdown boxes for functionality to
% go to any sticker chosen by user.
uilabel(fig,...
    'Position',[lbl4_pos(1), lbl4_pos(2), lbl4_pos(3), lbl4_pos(4)],...
    'Text','Manually Select Color and Shape to move to:');
color = uidropdown(fig, 'Items',{'Red','Green','Blue','Yellow'},'Position',...
    [btn4_pos(1), btn4_pos(2), 100, btn4_pos(4)]);
shape = uidropdown(fig, 'Items',{'Circle','Square','Triangle'},'Position',...
    [btn4_pos(1)+100, btn4_pos(2), 100, btn4_pos(4)]);
btn3 = uibutton(fig,...
   'Text', 'Next Sticker Of Size and Color:',...
   'Position',[btn4_pos(1), btn4_pos(2)-22*2, 200, btn4_pos(4)],...
   'ButtonPushedFcn', @(btn,event) arbitraryButtonPushed(btn,color,shape));

% Cycle to next button of selected color
uilabel(fig,...
    'Position',[lbl5_pos(1), lbl5_pos(2), lbl5_pos(3), lbl5_pos(4)],...
    'Text','Cycle to next sticker of given shape');

% Create Toggle buttons to allow selection of a color to cycle through.
bg = uibuttongroup(fig,'Position',btn5_pos);
tb2_1 = uitogglebutton(bg,'Position',[btn5_pos(1)-5 22*1 190 22],'Text','Triangle');
tb2_2 = uitogglebutton(bg,'Position',[btn5_pos(1)-5 22*2 190 22],'Text','Square');
tb2_3 = uitogglebutton(bg,'Position',[btn5_pos(1)-5 22*3 190 22],'Text','Circle');
btn4 = uibutton(fig,...
    'Text', 'Next Shaped Sticker',...
    'Position',[btn5_pos(1)-5 22*5 190 22],...
    'ButtonPushedFcn', @(btn,event) cycleSelectedShapeButtonPushed(btn,bg.SelectedObject));
                                                %changed color to shape

%
%
%
%ABOVE IS UI
%=========================================================================================================
%
%
%
%
clc; close all; clear all;
imaqreset; % reset device configuration. helps release open device handles.

% user inputs 
%nmaxframes = 200; % how many frames should be displayed during trial?
nmaxframes = 999999; % how many frames should be displayed during trial?
nframegrab = 30; % get every nth frame from the camera

% create the video input object. specify the image format and size
%vid = videoinput('winvideo', 1, 'MJPG_160x120');
vid = videoinput('winvideo', 2, 'MJPG_640x480'); % capture a RGB image of size 640x480 pixels

% Set video input object properties for this application.
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = nframegrab; % grab every nth frame from the device

% Create a figure window.
fig_image = figure;

% Start acquiring frames.
start(vid);

currentlySelected = 1;
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
        if y == rows/2
            % Receive data from UI to CV
            iterator_current = getappdata(0,'iterator_current');
%             fprintf("ITERATOR CURR 121: %d\n", iterator_current);
            currentlySelected = getappdata(0,'currentlySelected');
        end
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
%         fprintf("NUM SHAPES: %d\n", numShapes);
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
                x = round(centroids(n,1));
                y = round(centroids(n,2));
                red = uint64(im(y,x,1));
                green = uint64(im(y,x,2));
                blue = uint64(im(y,x,3));
                bred = red*red;
                bgreen = green*green;
                bblue = blue*blue;
                %output_image(y,x,1) = 0;
                %output_image(y,x,2) = 255;
                %output_image(y,x,3) = 255;
                %desc = strcat(desc,',',num2str(x),',',num2str(y),',');
                %desc = strcat(desc,'(',num2str(red),',',num2str(green),',',num2str(blue),'),');
                if bblue - 100 > bred && bblue - 100 > bgreen
                    currentShape(4) = 1;
                    desc = strcat(desc,'blue');
                elseif bgreen - 1000 > bred && (red + green + blue) < 300
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
                shapes = [shapes; currentShape];
                %horzcat(shapes,currentShape);
                output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], desc);
                %output_image = insertText(output_image, [(centroids(n,1)-25) (centroids(n,2)-50)], num2str(areas(n)));
                if(n == currentlySelected)
                    output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50],'Color','red');
                else
                    output_image = insertShape(output_image,'rectangle',[(centroids(n,1)-25) (centroids(n,2)-25) 50 50]);
                end
                output_image = insertShape(output_image,'circle',[centroids(n,1) centroids(n,2) 3],'LineWidth',2,'Color','blue');
            end
        end
    end
    btn2.UserData = shapes;
    setappdata(0,'shapes',shapes);
    setappdata(0,'iterator_current',iterator_current);
%     fprintf("ITERATOR CURR 249: %d\n", iterator_current);
    setappdata(0,'currentlySelected',currentlySelected);
    %disp(size(shapes));
    figure(fig_image);
    imshow(output_image);
    title_txt = sprintf('Image %d',vid.FramesAcquired);
    title(title_txt);
    
end

stop(vid);
delete(vid);
clear;

function rVal = getShapes()
    global shapes
    rVal = shapes;
end

% Create the function for cycleButtonPushedFcn callback
function cycleButtonPushed(btn)
    % TODO reference global variable index of array representing 
    % shape that pointer is currently pointing to, and increment
    % index to point to NEXT shape. Update motor position
    % TODO reference global variable with index of current shape;
        % compute array index for next shape of selected color.
        % update motor position
        %msgbox(sprintf('%s', color.Text));
        %shapes = btn.UserData;
        shapes = getappdata(0,'shapes');
        iterator_current = getappdata(0,'iterator_current');
%         fprintf("ITERATOR CURR 283: %d\n", iterator_current);
        currentlySelected = getappdata(0,'currentlySelected');
        cycle_iterator = getappdata(0,'cycle_iterator');
                 
            [rows, cols] = size(shapes);
            angles = [];
            
            if cycle_iterator+1 > rows
                cycle_iterator = 1;
            else
                    cycle_iterator = cycle_iterator + 1;
                    fprintf("cycle_iterator 323: %d\n", cycle_iterator);
                    

                    x = shapes(cycle_iterator,2);
                     y = shapes(cycle_iterator,3);
%                     x = shapes(,2);
%                     y = shapes(7,3);
%                     fprintf("X: %d Y: %d\n", currentlySelected);
                    
%                     if (abs(x) > 20) && (abs(y) > 20)
                        % invert y axis
                        y = 480 - y;
                        % set origin & 4 quadrants
                        y = y - 201;
                        x = x - 257;
                        angle = atan2(y,x);
                        if angle < 0
                            angle = 2*pi - angle;
                        end;
                        angle = angle*(180/pi); 
                        while angle > 360
                            angle = angle - 360;
                        end
                        if y > 0
                            angle = angle * -1;
                        end;
                        angles = [angles ; angle];
                        %redShapes = [redShapes ; shapes(n,:)];
                        set_param('controller/Constant','Value',int2str(ceil(angle)));
                        set_param(gcs,'SimulationCommand','update');
                        %msgbox(strcat(num2str(x),' ',num2str(y)));
                        msgbox(int2str(angle));
%                     end
            end
            setappdata(0,'cycle_iterator', cycle_iterator);
            
            
            
            
%              fprintf("SHAPES:::ROWS: %d COLS: %d\n", rows, cols);
%             if rows > 0
%                 numRed = 0;
%                 redShapes = [];
%                 for n=1:rows
% %                     fprintf("n: %d ", n);
% %                         fprintf("FOUND A RED\n");
%                         numRed = numRed + 1;
%                         redShapes = [redShapes ; shapes(n,:)];
%                         disp(redShapes);
% %                         fprintf("%d %d %d %d\n", redShapes(1), redShapes(2),redShapes(3),redShapes(4));
%                 end
% %                 fprintf("IT CURR 308: %d\n", iterator_current);
%                 iterator_current = iterator_current+1;
%                 
% %                 fprintf("ITERATOR CURR 310: %d\n", iterator_current);
%                 
%                 if iterator_current > numRed
%                     iterator_current = 1;
% %                     fprintf("ITERATOR CURR 315: %d\n", iterator_current);
%                 end
%                 for n=1:rows
% %                     if((shapes(n,2) == redShapes(iterator_current,2) && shapes(n,3) == redShapes(iterator_current,3)))
%                         currentlySelected = n;
% %                     end
%                 end
%                 
% %                 fprintf("ITERATOR CURRENT 323: %d\n", iterator_current);
% %                 fprintf("CURRENTLY SELECTED: %d\n", currentlySelected);
%                 
%                 setappdata(0,'iterator_current',iterator_current);
% %                 fprintf("ITERATOR CURR 327: %d\n", iterator_current);
%                 setappdata(0,'currentlySelected',currentlySelected);
%                 x = redShapes(iterator_current,2);
%                 y = redShapes(iterator_current,3);
%                 
%  
%                 end
%             else
%                 disp('no red');
%             end
end

% Create the function for cycleButtonPushedFcn callback
function cycleSelectedColorButtonPushed(btn, color)
        % TODO reference global variable with index of current shape;
        % compute array index for next shape of selected color.
        % update motor position
        %msgbox(sprintf('%s', color.Text));
        %shapes = btn.UserData;
        shapes = getappdata(0,'shapes');
        iterator_current = getappdata(0,'iterator_current');
%         fprintf("ITERATOR CURR 283: %d\n", iterator_current);
        currentlySelected = getappdata(0,'currentlySelected');
        %
        %Red
        %
        if strcmp(color.Text,'Red')
            fprintf("RED CALLBACK 286\n");
            
            [rows, cols] = size(shapes);
             
%             fprintf("SHAPES:::ROWS: %d COLS: %d\n", rows, cols);
            if rows > 0
                numRed = 0;
                redShapes = [];
                for n=1:rows
%                     fprintf("n: %d ", n);
                    if shapes(n,4) == 3
%                         fprintf("FOUND A RED\n");
                        numRed = numRed + 1;
                        redShapes = [redShapes ; shapes(n,:)];
                        disp(redShapes);
%                         fprintf("%d %d %d %d\n", redShapes(1), redShapes(2),redShapes(3),redShapes(4));
                    end
                end
%                 fprintf("IT CURR 308: %d\n", iterator_current);
                iterator_current = iterator_current+1;
                
%                 fprintf("ITERATOR CURR 310: %d\n", iterator_current);
                
                if iterator_current > numRed
                    iterator_current = 1;
%                     fprintf("ITERATOR CURR 315: %d\n", iterator_current);
                end
                for n=1:rows
                    if((shapes(n,2) == redShapes(iterator_current,2) && shapes(n,3) == redShapes(iterator_current,3)))
                        currentlySelected = n;
                    end
                end
                
%                 fprintf("ITERATOR CURRENT 323: %d\n", iterator_current);
%                 fprintf("CURRENTLY SELECTED: %d\n", currentlySelected);
                
                setappdata(0,'iterator_current',iterator_current);
%                 fprintf("ITERATOR CURR 327: %d\n", iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = redShapes(iterator_current,2);
                y = redShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no red');
            end
        elseif strcmp(color.Text,'Green')
            %
            %Green
            %
            fprintf("GREEN AT LINE 333\n");
            
            [rows, cols] = size(shapes);
            if rows > 0
                numRed = 0;
                greenShapes = [];
                for n=1:rows
                    if shapes(n,4) == 2
                        numRed = numRed + 1;
                        greenShapes = [greenShapes ; shapes(n,:)];
                    end
                end
                iterator_current = iterator_current+1;
                if iterator_current > numRed
                    iterator_current = 1;
                end
                for n=1:rows
                    if(shapes(n,2) == greenShapes(iterator_current,2) && shapes(n,3) == greenShapes(iterator_current,3))
                        currentlySelected = n;
                    end
                end
                setappdata(0,'iterator_current',iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = greenShapes(iterator_current,2);
                y = greenShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no green');
            end
        elseif strcmp(color.Text,'Blue')
            %
            %Blue
            %
            [rows, cols] = size(shapes);
            if rows > 0
                numRed = 0;
                blueShapes = [];
                for n=1:rows
                    if shapes(n,4) == 1
                        numRed = numRed + 1;
                        blueShapes = [blueShapes ; shapes(n,:)];
                    end
                end
                iterator_current = iterator_current+1;
                if iterator_current > numRed
                    iterator_current = 1;
                end
                for n=1:rows
                    if(shapes(n,2) == blueShapes(iterator_current,2) && shapes(n,3) == blueShapes(iterator_current,3))
                        currentlySelected = n;
                    end
                end
                setappdata(0,'iterator_current',iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = blueShapes(iterator_current,2);
                y = blueShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
                
            else
                disp('no blue');
            end
        elseif strcmp(color.Text,'Yellow')
            %
            %Yellow
            %
            [rows, cols] = size(shapes);
            if rows > 0
                numRed = 0;
                yellowShapes = [];
                for n=1:rows
                    if shapes(n,4) == 4
                        numRed = numRed + 1;
                        yellowShapes = [yellowShapes ; shapes(n,:)];
                    end
                end
                iterator_current = iterator_current+1;
                if iterator_current > numRed
                    iterator_current = 1;
                end
                for n=1:rows
                    if(shapes(n,2) == yellowShapes(iterator_current,2) && shapes(n,3) == yellowShapes(iterator_current,3))
                        currentlySelected = n;
                    end
                end
                setappdata(0,'iterator_current',iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = yellowShapes(iterator_current,2);
                y = yellowShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no yellow');
            end
        else %something fucked up
        end
end

function cycleSelectedShapeButtonPushed(btn, shape)
        % TODO reference global variable with index of current shape;
        % compute array index for next shape of selected color.
        % update motor position
        %msgbox(sprintf('%s', color.Text));
        %shapes = btn.UserData;
        shapes = getappdata(0,'shapes');
        iterator_current = getappdata(0,'iterator_current');
%         fprintf("ITERATOR CURR 283: %d\n", iterator_current);
        currentlySelected = getappdata(0,'currentlySelected');
        %
        %Red
        %
        if strcmp(shape.Text,'Circle')
            fprintf("CIRCLE CALLBACK 654\n");
            
            [rows, cols] = size(shapes);
             
%             fprintf("SHAPES:::ROWS: %d COLS: %d\n", rows, cols);
            if rows > 0
                numCircle = 0;
                circleShapes = [];
                for n=1:rows
%                     fprintf("n: %d ", n);
                    if shapes(n,1) == 1
%                         fprintf("FOUND A RED\n");
                        numCircle = numCircle + 1;
                        circleShapes = [circleShapes ; shapes(n,:)];
                        disp(circleShapes);
%                         fprintf("%d %d %d %d\n", redShapes(1), redShapes(2),redShapes(3),redShapes(4));
                    end
                end
%                 fprintf("IT CURR 308: %d\n", iterator_current);
                iterator_current = iterator_current+1;
                
%                 fprintf("ITERATOR CURR 310: %d\n", iterator_current);
                
                if iterator_current > numCircle
                    iterator_current = 1;
%                     fprintf("ITERATOR CURR 315: %d\n", iterator_current);
                end
                for n=1:rows
                    if((shapes(n,2) == circleShapes(iterator_current,2) && shapes(n,3) == circleShapes(iterator_current,3)))
                        currentlySelected = n;
                    end
                end
                
%                 fprintf("ITERATOR CURRENT 323: %d\n", iterator_current);
%                 fprintf("CURRENTLY SELECTED: %d\n", currentlySelected);
                
                setappdata(0,'iterator_current',iterator_current);
%                 fprintf("ITERATOR CURR 327: %d\n", iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = circleShapes(iterator_current,2);
                y = circleShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no circle');
            end
        elseif strcmp(shape.Text,'Triangle')
            %
            %Green
            %
            fprintf("TRIANGLE AT LINE 333\n");
            
            [rows, cols] = size(shapes);
            if rows > 0
                numCircle = 0;
                triangleShapes = [];
                for n=1:rows
                    if shapes(n,1) == 3
                        numCircle = numCircle + 1;
                        triangleShapes = [triangleShapes ; shapes(n,:)];
                    end
                end
                iterator_current = iterator_current+1;
                if iterator_current > numCircle
                    iterator_current = 1;
                end
                for n=1:rows
                    if(shapes(n,2) == triangleShapes(iterator_current,2) && shapes(n,3) == triangleShapes(iterator_current,3))
                        currentlySelected = n;
                    end
                end
                setappdata(0,'iterator_current',iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = triangleShapes(iterator_current,2);
                y = triangleShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no triangle');
            end
        elseif strcmp(shape.Text,'Square')
            %
            %Yellow
            %
            [rows, cols] = size(shapes);
            if rows > 0
                numCircle = 0;
                squareShapes = [];
                for n=1:rows
                    if shapes(n,1) == 2
                        numCircle = numCircle + 1;
                        squareShapes = [squareShapes ; shapes(n,:)];
                    end
                end
                iterator_current = iterator_current+1;
                if iterator_current > numCircle
                    iterator_current = 1;
                end
                for n=1:rows
                    if(shapes(n,2) == squareShapes(iterator_current,2) && shapes(n,3) == squareShapes(iterator_current,3))
                        currentlySelected = n;
                    end
                end
                setappdata(0,'iterator_current',iterator_current);
                setappdata(0,'currentlySelected',currentlySelected);
                x = squareShapes(iterator_current,2);
                y = squareShapes(iterator_current,3);
                
                if abs(x) > 20 && abs(y) > 20
                    % invert y axis
                    y = 480 - y;
                    % set origin & 4 quadrants
                    y = y - 201;
                    x = x - 257;
                    angle = atan2(y,x);
                    if angle < 0
                        angle = 2*pi - angle;
                    end;
                    angle = angle*(180/pi); 
                    while angle > 360
                        angle = angle - 360;
                    end
                    if y > 0
                        angle = angle * -1;
                    end;
                    set_param('controller/Constant','Value',int2str(ceil(angle)));
                    set_param(gcs,'SimulationCommand','update');
                    %msgbox(strcat(num2str(x),' ',num2str(y)));
                    msgbox(int2str(angle));
                end
            else
                disp('no square');
            end
        else %something fucked up
        end
end

% Create the function for arbitraryButtonPushedFcn callback
% allows rotation of motor "clock hand" to the next shape of
% user-selected (arbitrary) shape and color.
function arbitraryButtonPushed(btn,color,shape)
    msgbox(sprintf('%s %s', color.Value, shape.Value));
end