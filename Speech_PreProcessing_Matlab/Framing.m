function[mat,SignalDataFile]= Framing(FsizePsec,OlapPsec,FileName,WindowType)
clc;
% FileName='11';
% WindowType='hamming';
% FsizePsec=20;
% OlapPsec=10;
[SignalDataFile,fs,bps]=wavread(FileName);
len=size(SignalDataFile,1);
% figure;
% plot(SignalDataFile);
% title('origin y ');
%frameSamples=20;
%OlapPsec=5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOLVE PADDING PROBLEM%%%%%%%%%%%%%%%%%%%%%%%%%%
[rrr ccc ddd]=size(SignalDataFile);
KamMarra=0;
%Do Overlap Of Size OlapPsec
   
    oldX=len-FsizePsec ;
    oldY=FsizePsec-OlapPsec-1 ;
    KamMarra=fix(oldX/oldY) ;
    newX=len ;
    newY=FsizePsec+oldY*KamMarra ;
    
    %remainAlone must be in the range of 1 to FsizePsec-OlapPsec...(7-3=4)    
    remainAlone=newX-newY ;
    z=zeros(FsizePsec-remainAlone);       %ha3mel padding with framesize-elly fedel lwa7do
    zz=z(1:size(z,1));                     %create only one row or zeros
    SignalDataFile=[SignalDataFile(:,1)'];
    [rr cc]=size(SignalDataFile);
    SignalDataFile=[SignalDataFile zz];
    [r c]=size(SignalDataFile);

%PUTTINY SIGNALDATAFILE VALUES IN THE MATRIX MAT%%%%%%
mat=zeros(KamMarra+2,FsizePsec);
k=1;
x=0;
i=1;
count=1;
%KamMarra+2 we add 2 for the frist time and the final one that my need padding 
while count<=KamMarra+2
       
    %if first time ,3ady
    if(i==1)
           x=i+FsizePsec-1;
           s=SignalDataFile(i:x); 
           mat(k,:)=s;
    else
        newPos=x-OlapPsec;
        x=newPos+FsizePsec-1;
        if x>newY
            s=SignalDataFile(newPos:x);           
            mat(k,:)=s;               
            break;
        end
        s=SignalDataFile(newPos:x);
        mat(k,:)=s;    
    end
    k=k+1;
    %change i value
    i=i+FsizePsec-1;
    i=i-OlapPsec;    
    count=count+1;
end

% el mafrood afrde el matrix mat fe vector
[roww coll]=size(mat);
matvect=[];

for i=1:size(mat,1)
    matvect=[matvect mat(i,:)];
end

Start=1;
End=Start+coll-1;
[nr nc]=size(matvect(Start:End));
[mr mc]=size(mat(1,:));
mc ;%20
for i=1:mr
    % read row by row 
    matvect(Start:End)=mat(i,:);
    Start=End;
    End=End+roww-1;
end
% figure;
% plot(matvect);
% title('y after fard');
%%%%%%%%%%Apply hamming and rectangle window type windowing%%%%%%%%
%initialize the new mat matrix to be of the same size as the old mat
R=size(mat,1);
C=size(mat,2); 
NewMat=zeros(R,C);

if strcmp(WindowType,'hamming')
    NewMat=mat;
else
    HammingRow=hamming(FsizePsec)';     
    i=1;
    for  i=1:size(mat,1)                      %loop on the old matrix rows          
       %multiply each mat row i value with the corresponding value in hamming window  
       NewMat(i,:)=mat(i,:).*HammingRow(1,:);              
   end
end

% figure;
% plot(NewMat);
% title('new mat');
