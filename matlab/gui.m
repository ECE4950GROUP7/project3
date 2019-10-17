% define 2d array that controls button position
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
btn1 = uibutton(fig,'state',...
   'Text', 'Next Sticker',...
   'Position',[btn1_pos(1), btn1_pos(2), btn1_pos(3), btn1_pos(4)]);

% Cycle to next button of selected color
uilabel(fig,...
    'Position',[lbl2_pos(1), lbl2_pos(2), lbl2_pos(3), lbl2_pos(4)],...
    'Text','Cycle to next sticker of given color');
btn2 = uibutton(fig,'state',...
    'Text', 'Next Colored Sticker',...
    'Position',btn2_pos);

% Create Toggle buttons to allow selection of a color to cycle through.
bg = uibuttongroup(fig,'Position',btn3_pos);
tb1 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 0 190 22],'Text','Red');
tb2 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*1 190 22],'Text','Green');
tb3 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*2 190 22],'Text','Blue');
tb4 = uitogglebutton(bg,'Position',[btn3_pos(1)-5 22*3 190 22],'Text','Yellow');

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
    'Position',[btn4_pos(1), lbl4_pos(2), lbl4_pos(3), lbl4_pos(4)],...
    'Text','Manually Select Color and Shape to move to:');
color = uidropdown(fig, 'Items',{'Red','Green','Blue','Yellow'},'Position',...
    [btn4_pos(1), btn4_pos(2), 100, btn4_pos(4)]);
shape = uidropdown(fig, 'Items',{'Circle','Square','Triangle'},'Position',...
    [btn4_pos(1)+100, btn4_pos(2), 100, btn4_pos(4)]);