function End_Point_Detection()
clc;
[SignalDataFile,fs,bps]=wavread('11');
[mat,SignalDataFile]=Framing(20,10,'11','hamming');
Zc=zeroCrossing(mat);
E=getEnergy(mat);

%Calculate the ITU and ITL thresholds of the energy
IMN=min(E);
IMX=max(E);
I1=0.03*(IMX-IMN)+IMN;
I2=4*IMN;
ITL=min(I1,I2);
ITU=3*ITL;

%getting the first 100 msec samples.
%Samples_Num=fs*0.01         %as .1  represent the 100 ms
Samples_Num=150;

%calculate the mean and the sd of these number of samples 
SZCRm=mean(Zc(1:Samples_Num));
SZCR_std=std(Zc(1:Samples_Num));

%calculate the ZeroCrossing threshold TZCRS for all Zc values
AVZC=mean(Zc);%el mean bta3 l zc koloh
%assuming A,B=1
A=1;
B=1;
%V = A* ( AVZC/SZCRm ) + B*( 1 + SZCR_std/SZCRm );
V=0.00001
TZCRS = SZCRm + SZCR_std*V;

%loop on the E vector
N1=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %assumd values
% E =[50 60 40 60 90 110 150 200 230 150 130 110 90 70 40 30 40 40]; 
% Zc =[20 30 35 25 20 13 10 7 8 7 7 3 2 14 23 30 35 30];
% ITL = 36;
% ITU = 108;
% TZCRS = 26.7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[E_row E_col]=size(E);
%obtaining N1
for i=1:E_col
   if E(i) > ITU
        N1=i;
        for j=N1:-1:1
            if E(i) < ITL
                N1=j;
                break;
            end
        end
        break;
    end
end
N1

%obtaining N2
N2=E_col;
for i=E_col:-1:1
   if E(i) > ITU
        N2=i;
        for j=N2:E_col
            if E(j) < ITL
                N2=j;
                break;
            end
        end
        break;
    end
end
N2

[Zc_row Zc_col]=size(Zc);

%chk for padding to work on the first 100ms samples only
new_Zc1 = zeros(1,Samples_Num);
if N1 < Samples_Num
    new_Zc1(1:N1) = Zc(1:N1);
else
    new_Zc1 = Zc(1:Samples_Num);
end

%obtaining N1^
N1_hat=N1;
counter=0;
index=1;
for i=N1:-1:1
   
    if new_Zc1(i) < TZCRS
       counter=counter+1;
       if counter == 1
          index=i;
       end       
       if counter >= 3
           N1_hat=index;
       end       
    end
    
end

%chk for padding to work on the last 100ms samples only
new_Zc2 = zeros(1,Samples_Num);
lastRemain = Zc_col - N2;

if  lastRemain < Samples_Num
    new_Zc2(1:lastRemain) = Zc(N2,:);
else
    new_Zc2 = Zc(1:Samples_Num);
end

counter=0;
%obtaining N2^
N2_hat=N2;
for i=N2:Zc_col
   
   if new_Zc1(i) < TZCRS
       counter=counter+1;
       if counter == 1
          index=i;
       end       
       if counter >= 3
           N2_hat=index;
       end       
    end
end
N2_hat


%newFileSize = N2-N1;
%new_SignalDataFile = zeros(1,newFileSize);
new_SignalDataFile = SignalDataFile(N1:N2);
subplot(211)
plot(SignalDataFile);
subplot(212)
plot(new_SignalDataFile);


end%end of fun ass3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E=getEnergy(mat)

E=zeros(1,size(mat,1));
%loop over all the mat rows
    for n=1:size(mat,1)   
           mult_value=mat(n,:).*mat(n,:);
           E(n)=sum(mult_value);
    end%for end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function zc=zeroCrossing(mat)

zc=zeros(1,size(mat,1));
% initialize the nxt index sign by 1,         
nxt_index_sign=0;       

%identify zn as the sum of zero corssing of frame n
zn=0;

%loop over all the mat rows
    for n=1:size(mat,1)   % 1:r

           frame_n=mat(n,:);       
           sum_value=0;
           for i=1:length(frame_n)           

               index_sign= sgn(frame_n(i));           
               %check for reaching the last index
               if(i+1>length(frame_n))
                   nxt_index_sign=1;
               else
                   nxt_index_sign=sgn(frame_n(i+1));
               end           
               sub_value = index_sign - nxt_index_sign;
               sub_value_abs = abs(sub_value);
               sum_value = sum_value + sub_value_abs;
               
           end%for end
           zn=sum_value/2;
           zc(n)=zn;
           
    end%for end

end%fun zeroCrossing()end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sign=sgn(m)
sign=0;
if m>=0
    sign=1;
else
   sign=-1; 
end
end %fun sgn() end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 
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

end%fun realframing2 end
