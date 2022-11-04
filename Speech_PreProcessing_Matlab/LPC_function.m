function LPC_function()
clc;
%kol dool el mafrood inputs
FileName='11';WinType='hamming';framesize=20;olapSize=10;p=4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mat,SignalDataFile]=Framing(20,10,'11','hamming');                 %return matrix mat' of size 20 rows w 2367 cols
%ba3mel lel mat transpose to enter as an input lel LPC built in function
%ya3ny lkol frame ana bageeb el p+1 predicted value fel matrix A 
%mat=[1 12 13 5 5 6 4;6 7 8 9 10 7 3;8 5 4 3 7 2 4;5 4 3 2 1 6 7]
A=lpc(mat',p) ;                                 % return matrix A of size 2367 rows w 5 (p+1)cols

%copy the first p values mn el original matrix into the predicted one.
%wel pa2y fel predicted lsa fady
[matR matC]=size(mat);
predicted=zeros(matR,matC);
for i=1:matR
  predicted(i,1:p)=mat(i,1:p);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate the remaining values of the predicted matrix
[predR predC]=size(predicted);
%1- loop on each row of the prediced matrix
for i=1:predR
    %2- at each row calculate the remaining values mn 5 lel a5er
    %7ot el ba2y fe vector 
    v = predicted(i,p+1:predC);
    for ind = p+1 : predC
        a = A(i,2:p+1);
        x = predicted(i,ind-1:-1:ind-p);
        Xn=sum(-a.*x);
        predicted(i,ind)=Xn;
    end
end 
predicted;
%we need to calc el error of prediction
Error = zeros(matR,matC);
for i = 1:matR
    Error(i,:) = mat (i,:) - predicted (i,:);
end
Error;

% el mafrood afrde el matrix mat fe vector
matvect=[];
for i=1:size(mat,1)
    matvect=[matvect mat(i,:)];
end
% % el mafrood afrde el matrix predicted fe vector
% predvect=[];
% for i=1:size(mat,1)
%     predvect=[predvect mat(i,:)];
% end

[row col]=size(mat);
Start=1;
End=Start+col-1;
[nr nc]=size(matvect(Start:End));
[mr mc]=size(mat(1,:));
mc ;%20
for i=1:mr
    % read row by row 
    matvect(Start:End)=mat(i,:);
    Start=End;
    End=End+row-1;
end
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
function [mat,SignalDataFile]=Framing(FsizePsec,OlapPsec,FileName,WindowType)

% FileName='ll';
% WindowType='hamming';
% FsizePsec=20;
% OlapPsec=10;

[SignalDataFile,fs,bps]=wavread(FileName);
len=size(SignalDataFile,1);

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
    z=zeros(FsizePsec-remainAlone);%ha3mel padding with framesize-elly fedel lwa7do
    zz=z(1:size(z,1));%create only one row or zeros
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
        newpos=x-OlapPsec;
        x=newpos+FsizePsec-1;
        if x>newY
            s=SignalDataFile(newpos:x);           
            mat(k,:)=s;               
            break;
        end
        s=SignalDataFile(newpos:x);
        mat(k,:)=s;    
    end
    k=k+1;
    i=i+FsizePsec-1;
    i=i-OlapPsec;    
    count=count+1;
end
   subplot(111)
   plot(SignalDataFile)
   title('the original speech signal');

end  %fun framing end
