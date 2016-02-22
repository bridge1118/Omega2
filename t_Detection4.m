% Detection

load 'mdls/bowModel.mat'
load 'mdls/vocabulary.mat'
%load 'trainWorkspace.mat'

testDetectFolder = 'imgs/pedestrian_nuu';

disp('----------Detecting Pedestrian----------');
[imsD, imsDn] = ReadVideo(testDetectFolder);

for frame = 1 : 1
    
    imWidth = size(imsD{frame}, 2);
    imHeight= size(imsD{frame}, 1);

    windowWidth = 100;
    windowHeight= 100;

    % sliding window
    for j = 1 : 10 : imHeight - windowHeight + 1
        for i = 1 : 10 : imWidth - windowWidth + 1
            window = imsD{frame}(j:j + windowHeight - 1, i:i + windowWidth - 1, :);
            result(i,j)=SiftBowDetector(window, vocabulary, model);
        end
    end
    
    
    return
    
end