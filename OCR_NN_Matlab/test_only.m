clc;
%% 
%Read all feature matrix from file .txt
pwd = 'D:/3.Pre-PHD Courses/Optimization_Dr.Hoda/6.Project/2.Data Hand Gesture/0.My new Data/TrainingPhase/FeaturesMatrices/';
files = dir( fullfile(pwd,'*.txt') );
%files now has all files with .txt extention

featureVectorLength = 31;
numberOfsamples = 70;
numberOfGestures = 10;

%%
%loop on them
Matrix_Features = [];
idx = 0;

for k = 1 : numel(files) 
    %%%% reading the txt file
    fid01 = fopen(fullfile(pwd,files(k).name));    
    %tmparray = []; %stores  all features of one gestures
    tline = fgetl(fid01); % rwad only the first line
    
    while ischar(tline)
        idx = idx + 1;
        Matrix_Features(:,idx) = str2num(tline);
        %[a b] = size (Matrix_Features(:,idx))
        tline = fgetl(fid01);
    end
    fclose(fid01);
    
end
[rrr ccc] = size(Matrix_Features)

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
    net=newff(Matrix_Features,TargetOutput,[3 4 3],{'logsig','tansig','logsig','tansig'});
    
    net.trainParam.epochs = 80;
    net.trainParam.lr = 0.5;
    net.TrainParam.ebook=1000;
    
    %[r c] = size(Matrix_Features) 
    %[rr cc] = size(TargetOutput)
    
    net_Train=train(net,Matrix_Features,TargetOutput);
    
   
