function wins = secondaryObjective(numEpisodes,numStimSets,numTrialsPerC,scheme)

    % This version is combined for overlapping and non overlapping stimuli
    % function must be called with [int, int, int, str] [number of
    % Episodes, number of Stimumli Sets, number of Trials Per Condition,
    % which scheme should be used, 'hard'/'soft')
    % numEpisodes/numStimSets must be an integer
    % ex: secondaryObjective(12, 6, 10, 'soft');

    % to do
    % prob is fixed length and fixed for stimuli sets
    % no data is saved yet

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
    % numEpisodes=12;
    % numStimSets=6; % numEpisodes/numStimSets must be an integer
    % numTrialsPerC=4;
    % scheme='hard';
    stimWidth=135;
    stimHeight=102;
    stimRect=center + [floor(-stimWidth/2) floor(-stimHeight/2) floor(stimWidth/2) floor(stimHeight/2)];

    cond=nan(numEpisodes,1);
    count=1;
    for i=0:numStimSets/2-1
        for k=1:numEpisodes/numStimSets  % this ratio determines how many times each stimset is repeated in a block
            for j=1:2
                cond(count)=i*2+j;
                count=count+1;
            end
        end
    end
    if (strcmp(scheme,'soft'))  % overlapping stimsets
        cond(1:end-1,2)=cond(2:end,1);
        cond(end,2)=cond(end-1,1);
    else  % non overlapping stimsets
        cond(:,2)=cond(:,1)+repmat([1;-1],numEpisodes/2,1);
    end

    % prob=[0.8,0.2; 0.4,0.6; 0.9,0.1; 0.75,0.25; 0.75,0.25; 0.75,0.25; 0.75,0.25]; % needs to be the length of [cond+1,2]
    prob=round([0.8,0.2; 0.4,0.6; 0.9,0.1; 0.75,0.25; 0.75,0.25; 0.75,0.25; 0.75,0.25]); % for testing purposes as the payoffs become deterministic

    npair=condNums(randperm(maxConditions,numStimSets+1));    % random permutation of the integers 1:numConditions, needed to randomize stimuli between subjects 

    for k=1:numStimSets+1
        nstim=randperm(2); % vector of 2 randomized 1 and 2
        stim_A{k,1}=uint8(imread(fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(1)),'.bmp')))); % allocate/order stimuli  #session #pair(randomized) #stim(randomized between 1 and 2)
        texStim_A{k,1}=Screen('MakeTexture', win, stim_A{k,1});
        stim_B{k,1}=uint8(imread(fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(2)),'.bmp'))));
        texStim_B{k,1}=Screen('MakeTexture', win, stim_B{k,1});
        stimuli{k,1}=fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(1)),'.bmp'));%stimuli A
        stimuli{k,1+1}=fullfile('Stimfiles', strcat('Stim',num2str(npair(k)),num2str(nstim(2)),'.bmp'));%stimuli B
    end

    xSpan=300; % seperation of stimset from centre
    ySpan=300; %make these screen size dependent
    stimXseparation=round((stimWidth)/2); %seperation between Rew and Sec stimuli on same side
    stimYseparation=round((stimHeight)/2);

    stimRX=round(rand(numTrialsPerC,numEpisodes))*2-1;  % randomizing location of Rew stimuli
    stimRY=round(rand(numTrialsPerC,numEpisodes))*2-1;
    % stimSX=round(rand(numTrialsPerC,numEpisodes))*2-1;  % randomizing location of Sec stimuli
    % stimSY=round(rand(numTrialsPerC,numEpisodes))*2-1;

    if(ispc)
        RestrictKeysForKbCheck([32, 37, 38, 39, 40]);
    elseif(ismac) 
        RestrictKeysForKbCheck([44, 79, 80, 81, 82]);
    end


    for episode=1:numEpisodes
        for numTri=1:numTrialsPerC
            sideFlip=rand;
            if sideFlip>0.5 % 
                Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %

                Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %

                Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %

                Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
            else
                Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %

                Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %

                Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %

                Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %        
            end
            Screen('Flip',win);

            [keyTime, keyCode]=KbWait([],2);
            keyName=KbName(keyCode);
            if(iscell(keyName))
                keyName=keyName{1};
            end

            if sideFlip>0.5
                switch keyName
                    case 'LeftArrow'
                        if (stimRX(numTri,episode)>0)
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=2;
                        else
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=1;                        
                        end
                    case 'RightArrow'
                        if (stimRX(numTri,episode)<0)
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=2;                        
                        else
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=1;                        
                        end
                    case 'UpArrow'
                        if (stimRY(numTri,episode)<0)
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=2;                        
                        else
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=1;                        
                        end
                    case 'DownArrow'
                        if (stimRY(numTri,episode)>0)
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=2;                        
                        else
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=1;                        
                        end                    
                    otherwise

                end
            else
                switch keyName
                    case 'LeftArrow'
                        if (stimRX(numTri,episode)>0)
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=1;
                        else
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=2;                        
                        end
                    case 'RightArrow'
                        if (stimRX(numTri,episode)<0)
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0-stimYseparation) -1*xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[-1*xSpan*stimRX(numTri,episode) (0+stimYseparation) -1*xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=1;                        
                        else
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0-stimYseparation) xSpan*stimRX(numTri,episode) (0-stimYseparation)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[xSpan*stimRX(numTri,episode) (0+stimYseparation) xSpan*stimRX(numTri,episode) (0+stimYseparation)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=2;                        
                        end
                    case 'UpArrow'
                        if (stimRY(numTri,episode)<0)
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=1;                        
                        else
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=2;                        
                        end
                    case 'DownArrow'
                        if (stimRY(numTri,episode)>0)
                            Screen('DrawTexture', win, texStim_A{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) ySpan*stimRY(numTri,episode) (0-stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_A{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) ySpan*stimRY(numTri,episode) (0+stimXseparation) ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=1;
                            secoChoice(numTri,episode)=1;                        
                        else
                            Screen('DrawTexture', win, texStim_B{cond(episode,1),1}, [], stimRect+[(0-stimXseparation) -1*ySpan*stimRY(numTri,episode) (0-stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            Screen('DrawTexture', win, texStim_B{cond(episode,2),1}, [], stimRect+[(0+stimXseparation) -1*ySpan*stimRY(numTri,episode) (0+stimXseparation) -1*ySpan*stimRY(numTri,episode)]);  %
                            primChoice(numTri,episode)=2;
                            secoChoice(numTri,episode)=2;                        
                        end                    
                    otherwise

                end
            end
                Screen('Flip',win);
                WaitSecs(1);
                primWin(numTri,episode)=double(rand<prob(cond(episode,1),primChoice(numTri,episode)));
                secoWin(numTri,episode)=double(rand<prob(cond(episode,2),secoChoice(numTri,episode)));
                DrawFormattedText(win,['You win: ' num2str(primWin(numTri,episode)) ' Euros'], center(1)-250, center(2)-200,[255 255 255]);
                DrawFormattedText(win,['Other value: ' num2str(secoWin(numTri,episode)) ' Euros'], center(1)-250, center(2),[255 255 255]);
                Screen('Flip',win);
                WaitSecs(1);
    %         WaitSecs(1);
    % secondaryTrials;
        end
    end
    wins=sum(sum(primWin));
    sca;

end