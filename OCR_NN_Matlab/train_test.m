clc;
%% read all feature matrix from file .txt
pwd = 'D:/3.Pre-PHD Courses/Optimization_Dr.Hoda/6.Project/2.Data Hand Gesture/0.My new Data/TrainingPhase/FeaturesMatrices/';
files = dir( fullfile(pwd,'*.txt') );
%files now has all files with .txt extention

featureVectorLength = 31;
numberOfsamples = 70;
numberOfGestures = 10;

%%
%
% %create matrix of labels
% TargetOutput = [];
% for i=1:numberOfsamples
%      for j=1: numberOfGestures
%         TargetOutput(i,j)  = j-1; 
%      end
% end
% %[a b] = size(TargetOutput)
% 
% %transpose to be of length 10 * 70
% TargetOutput = TargetOutput';

% [a b] = size(TargetOutput)
% 
%%
%do another target
TargetOutput = [];
b=zeros(10,1);
z=1;

for i=1:numberOfGestures %num of labels or gestures
   for j=1:numberOfsamples % num of samples in each gesture
       b(i,1)=1;
       TargetOutput(:,z) = b;
       z=z+1;
   end
   b=zeros(10,1);
end
TargetOutput';
%b
%[r c] = size(b)
%[row col] = size(TargetOutput)
%TargetOutput(1,:)

%%
%loop on them
Matrix_Features = [];
idx = 0;

for k = 1 : 1 % or numel(files) 
    %%%% reading the txt file
    fid01 = fopen(fullfile(pwd,files(k).name));    
    %tmparray = []; %stores  all features of one gestures
    tline = fgetl(fid01); % rwad only the first line
    
    while ischar(tline)
        idx = idx + 1;
        Matrix_Features(idx,:) = str2num(tline);
        tline = fgetl(fid01);
    end
    fclose(fid01);
    
end
[rrr ccc] = size(Matrix_Features)

    %% pre-processess
    %1. initialize net
    Matrix_Features = Matrix_Features';
    %[r c] = size(tmparray);
    
    %% 2.may reshape into one vector
    %tmparray = reshape(tmparray, [1 featureVectorLength*numberOfsamples]);
    %[r c] = size(tmparray);
    %value = tmparray (1,199);
    
    %% 
    %[py, pys] = mapminmax(tmparray');
    %net = newff(minmax(py),[6 1], {'logsig','logsig'}, 'triangdm'); 
    %net = newff(tmparray,TargetOutput, 10); 
    
    
    net=newff(Matrix_Features,TargetOutput,[3 4 3],{'logsig','tansig','logsig','tansig'});
    
    net.trainParam.epochs = 80;
    net.trainParam.lr = 0.5;
    net.TrainParam.ebook=1000;
    
    [r c] = size(Matrix_Features) 
    [rr cc] = size(TargetOutput)
    
    %net_Train=train(net,Matrix_Features,TargetOutput);
    
    
%     y = sim(net,ay);

%     tmparray = reshape(tmparray, [1 featureVectorLength*numberOfsamples]);
%     [r c] = size(tmparray)
%     tmparray (1,10)
%     

%net2 = newff( p, t, H ); % obsolete
%net = newff(tmparray,[3 1],{'tansig' 'purelin'},'traingdm');    

%     %%%simulate net
%     output = sim(net, tmparray);   
%     %%%% save the output
%     filename = strcat(regexprep(files(k).name,'.txt',''),'-output.txt');
%     fid02 = fopen(filename,'w');
%     fprintf(fid02,'%.2f\n',output');    
%     fclose(fid02);
  