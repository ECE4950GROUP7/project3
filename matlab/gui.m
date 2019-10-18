

% define button positions
lbl1_pos = [10 390 200 22];
btn1_pos = [10 lbl1_pos(2)-22 200 22];
lbl2_pos = [10 btn1_pos(2)-22-20 200 22];
btn2_pos = [10 lbl2_pos(2)-22 200 22];
%lbl3_pos = [0 btn2_pos(2)-22 200 22];
btn3_pos = [10 btn2_pos(2)-22*4-5 200 22*4];
lbl4_pos = [10 btn3_pos(2)-22-20 200 22];
btn4_pos = [10 lbl4_pos(2)-22*2 300 22*2];

fig = uifigure('Name', 'Gameboard GUI', 'Position',[200 200 220 420]);

% Cycle through all the stickers on the board
uilabel(fig,...
    'Position',[lbl1_pos(1), lbl1_pos(2), lbl1_pos(3), lbl1_pos(4)],...
    'Text','Cycle to next sticker');
btn1 = uibutton(fig,...
   'Text', 'Next Sticker',...
   'Position',[btn1_pos(1), btn1_pos(2), btn1_pos(3), btn1_pos(4)],...
   'ButtonPushedFcn', @(btn,event) cycleButtonPushed(btn));

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

% Create the function for cycleButtonPushedFcn callback
function cycleButtonPushed(btn)
    % TODO reference global variable index of array representing 
    % shape that pointer is currently pointing to, and increment
    % index to point to NEXT shape. Update motor position
end

% Create the function for cycleButtonPushedFcn callback
function cycleSelectedColorButtonPushed(btn, color)
        % TODO reference global variable with index of current shape;
        % compute array index for next shape of selected color.
        % update motor position
        %msgbox(sprintf('%s', color.Text));
        if strcmp(color.Text,'Red')
            msgbox('Red');
        elseif strcmp(color.Text,'Green')
            msgbox('Green');
        elseif strcmp(color.Text,'Blue')
            msgbox('Blue');
        elseif strcmp(color.Text,'Yellow')
            msgbox('Yellow');
        else %something fucked up
        end
end

% Create the function for arbitraryButtonPushedFcn callback
% allows rotation of motor "clock hand" to the next shape of
% user-selected (arbitrary) shape and color.
function arbitraryButtonPushed(btn,color,shape)
    msgbox(sprintf('%s %s', color.Value, shape.Value));
end