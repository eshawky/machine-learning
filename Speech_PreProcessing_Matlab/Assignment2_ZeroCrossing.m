function assignment2()

[mat,SignalDataFile]=Framing();
zc=zeroCrossing(mat);
E=getEnergy(mat);

    subplot(311)
    plot(SignalDataFile)
    title('the original speech signal');
    subplot(312)
    plot(zc)
    title('the zerocrossing of the speech signal');
    subplot(313)
    plot(E)
    title('the energy of the speech signal');

end
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
function [mat,SignalDataFile]=Framing()

FileName='ll';
WindowType='hamming';
frameSamples=20;
OlapSamples=10;

[SignalDataFile,fs,bps]=wavread(FileName);
len=size(SignalDataFile,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOLVE PADDING PROBLEM%%%%%%%%%%%%%%%%%%%%%%%%%%
[rrr ccc ddd]=size(SignalDataFile);
KamMarra=0;

%Do Overlap Of Size OlapSamples
   
    oldX=len-frameSamples ;
    oldY=frameSamples-OlapSamples-1 ;
    KamMarra=fix(oldX/oldY) ;
    newX=len ;
    newY=frameSamples+oldY*KamMarra ;
    
    %remainAlone must be in the range of 1 to frameSamples-OlapSamples...(7-3=4)    
    remainAlone=newX-newY ;
    z=zeros(frameSamples-remainAlone);%ha3mel padding with framesize-elly fedel lwa7do
    zz=z(1:size(z,1));%create only one row or zeros
    SignalDataFile=[SignalDataFile(:,1)'];
    [rr cc]=size(SignalDataFile);
    SignalDataFile=[SignalDataFile zz];
    [r c]=size(SignalDataFile);

%PUTTINY SIGNALDATAFILE VALUES IN THE MATRIX MAT%%%%%%
mat=zeros(KamMarra+2,frameSamples);
k=1;
x=0;
i=1;
count=1;

%KamMarra+2 we add 2 for the frist time and the final one that my need padding 
while count<=KamMarra+2
       
    %if first time ,3ady
    if(i==1)
           x=i+frameSamples-1;
           s=SignalDataFile(i:x); 
           mat(k,:)=s;
    else
        newpos=x-OlapSamples;
        x=newpos+frameSamples-1;
        if x>newY
            s=SignalDataFile(newpos:x);           
            mat(k,:)=s;               
            break;
        end
        s=SignalDataFile(newpos:x);
        mat(k,:)=s;    
    end
    k=k+1;
    i=i+frameSamples-1;
    i=i-OlapSamples;    
    count=count+1;
end

end%fun realframing2 end
