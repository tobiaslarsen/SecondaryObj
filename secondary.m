% psychExpInit;
Screen('Preference', 'SkipSyncTests', 2); % 2 to skip tests, as we don't need milisecond precision, 0 otherwise
screens=Screen('Screens');
screenNumber=max(screens);
KbName('UnifyKeyNames');
[win, rect] = Screen('OpenWindow', screenNumber, 0);
[xc, yc] = RectCenterd(rect); % Get coordinates of screen center 
center=[xc yc xc yc];
maxConditions=20;
condNums=10:29;
numConditions=3;
numTrialsPerC=10;
stimWidth=135;
stimHeight=102;
stimRect=center + [floor(-stimWidth/2) floor(-stimHeight/2) floor(stimWidth/2) floor(stimHeight/2)];
prob=[0.8,0.2; 0.4,0.6; 0.9,0.1; 0.75,0.25];

npair=condNums(randperm(maxConditions,numConditions+1));    % random permutation of the integers 1:numConditions, needed to randomize stimuli between subjects 

for k=1:numConditions+1
    nstim=randperm(2); % vector of 2 randomized 1 and 2
    stim_A{k,1}=uint8(imread(fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(1)),'.bmp')))); % allocate/order stimuli  #session #pair(randomized) #stim(randomized between 1 and 2)
    texStim_A{k,1}=Screen('MakeTexture', win, stim_A{k,1});
    stim_B{k,1}=uint8(imread(fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(2)),'.bmp'))));
    texStim_B{k,1}=Screen('MakeTexture', win, stim_B{k,1});
    stimuli{k,1}=fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(1)),'.bmp'));%stimuli A
    stimuli{k,1+1}=fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(2)),'.bmp'));%stimuli B
end

xSpan=300;
ySpan=300; %make these screen size dependent
stimXseparation=round((stimWidth)/2);
stimYseparation=round((stimHeight)/2);

stimRX=round(rand(numTrialsPerC,numConditions))*2-1;
stimRY=round(rand(numTrialsPerC,numConditions))*2-1;
stimSX=round(rand(numTrialsPerC,numConditions))*2-1;
stimSY=round(rand(numTrialsPerC,numConditions))*2-1;

if(ispc)
    RestrictKeysForKbCheck([32, 37, 38, 39, 40]);
elseif(ismac) 
    RestrictKeysForKbCheck([44, 79, 80, 81, 82]);
end

for cond=1:numConditions
    for numTri=1:numTrialsPerC
        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0-stimYseparation) xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0+stimYseparation) xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %
        
        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0-stimYseparation) -1*xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0+stimYseparation) -1*xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %

        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,cond) (0-stimXseparation) ySpan*stimRY(numTri,cond)]);  %
        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,cond) (0+stimXseparation) ySpan*stimRY(numTri,cond)]);  %
        
        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,cond) (0-stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %
        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,cond) (0+stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %

        Screen('Flip',win);

        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        if(iscell(keyName))
            keyName=keyName{1};
        end

            switch keyName
                case 'LeftArrow'
                    if (stimRX(numTri,cond)>0)
                        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0-stimYseparation) -1*xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
                        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0+stimYseparation) -1*xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %
                        primChoice(numTri,cond)=2;
                        secoChoice(numTri,cond)=2;
                    else
                        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0-stimYseparation) xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
                        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0+stimYseparation) xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %
                        primChoice(numTri,cond)=1;
                        secoChoice(numTri,cond)=1;                        
                    end
                case 'RightArrow'
                    if (stimRX(numTri,cond)<0)
                        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0-stimYseparation) -1*xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
                        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[-1*xSpan*stimRX(numTri,cond) (0+stimYseparation) -1*xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %
                        primChoice(numTri,cond)=2;
                        secoChoice(numTri,cond)=2;                        
                    else
                        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0-stimYseparation) xSpan*stimRX(numTri,cond) (0-stimYseparation)]);  %
                        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[xSpan*stimRX(numTri,cond) (0+stimYseparation) xSpan*stimRX(numTri,cond) (0+stimYseparation)]);  %
                        primChoice(numTri,cond)=1;
                        secoChoice(numTri,cond)=1;                        
                    end
                case 'UpArrow'
                    if (stimRY(numTri,cond)<0)
                        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,cond) (0-stimXseparation) ySpan*stimRY(numTri,cond)]);  %
                        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,cond) (0+stimXseparation) ySpan*stimRY(numTri,cond)]);  %
                        primChoice(numTri,cond)=1;
                        secoChoice(numTri,cond)=2;                        
                    else
                        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,cond) (0-stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %
                        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,cond) (0+stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %
                        primChoice(numTri,cond)=2;
                        secoChoice(numTri,cond)=1;                        
                    end
                case 'DownArrow'
                    if (stimRY(numTri,cond)>0)
                        Screen('DrawTexture', win, texStim_A{cond,1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,cond) (0-stimXseparation) ySpan*stimRY(numTri,cond)]);  %
                        Screen('DrawTexture', win, texStim_B{cond+1,1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,cond) (0+stimXseparation) ySpan*stimRY(numTri,cond)]);  %
                        primChoice(numTri,cond)=1;
                        secoChoice(numTri,cond)=2;                        
                    else
                        Screen('DrawTexture', win, texStim_B{cond,1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,cond) (0-stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %
                        Screen('DrawTexture', win, texStim_A{cond+1,1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,cond) (0+stimXseparation) -1*ySpan*stimRY(numTri,cond)]);  %
                        primChoice(numTri,cond)=2;
                        secoChoice(numTri,cond)=1;                        
                    end                    
                otherwise
                    
            end
        
            Screen('Flip',win);
            WaitSecs(1);
            primWin(numTri,cond)=double(rand<prob(cond,primChoice(numTri,cond)));
            secoWin(numTri,cond)=double(rand<prob(cond+1,secoChoice(numTri,cond)));
            DrawFormattedText(win,['You win: ' num2str(primWin(numTri,cond)) ' Euros'], center(1)-250, center(2)-200,[255 255 255]);
            DrawFormattedText(win,['Other value: ' num2str(secoWin(numTri,cond)) ' Euros'], center(1)-250, center(2),[255 255 255]);
            Screen('Flip',win);
            WaitSecs(1);
%         WaitSecs(1);
% secondaryTrials;
    end
end

sca;