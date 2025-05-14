 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Вычисление значений классификаторов на кластераз
%  Прогон всех файлов кластеров выборки через классификаторы
%  Вход : файл выборки через config файл D:\klast\klast_iran\config\config.txt
%  Выход: результаты работы классификаторов для всех файлов кластеров:
%                            exp1_<классификатор>.txt
%                            exp2_<классификатор>.txt
%                            exp3_<классификатор>.txt
%                            exp4_<классификатор>.txt
%                            exp5_<классификатор>.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"

clear all;
rng('default')  % For reproducibility

fid = fopen('D:\klaster\klast_iran\calc\conf_temp.txt');
catalog = fgetl(fid) % каталог

num = 0;
while ~feof(fid)
    filename = fgetl(fid);
    if isempty(filename) || strncmp(filename,'%',1) || ~ischar(filename)
        continue
    end
    num = num + 1;



%filename = 'D:\klast\klast_iran\numklast_davis.txt.res\res_0_1_num_1_numklast_silh.txt';
%cd 'D:\klast\klast_iran\numklast_silh.txt.res\'

delimiterIn = ' ';
headerlinesIn = 1;

filename = strcat(catalog,filename);
A = importdata(filename,delimiterIn); %,headerlinesIn);



i=0;
for k = [1:2]
 X=A(:,k);
end

figure;
y = categorical(A(:,3));
labels = categories(y);
gscatter(A(:,1),A(:,2),y);
xlabel('Sepal length');
ylabel('Sepal width');


X(:,1)=A(:,1)
X(:,2)=A(:,2)

%______________________________________________

figure;
classifier_name = {'Naive Bayes','Discriminant Analysis','Classification Tree','Nearest Neighbor','SVM','Ansamble'};
classifier{1} = fitcnb(X,y);
classifier{2} = fitcdiscr(X,y);
classifier{3} = fitctree(X,y);
classifier{4} = fitcknn(X,y);
%classifier{5} = fitcsvm(X,y);
 classifier{5} = fitcecoc(X,y);
classifier{6} = fitcensemble(X,y);


x1range = min(X(:,1)):.5:max(X(:,1));
x2range = min(X(:,2)):.5:max(X(:,2));
[xx1, xx2] = meshgrid(x1range,x2range);
XGrid = [xx1(:) xx2(:)];

for i = 1:numel(classifier)
   predictedspecies = predict(classifier{i},XGrid);
  
   subplot(3,2,i);
   gscatter(xx1(:), xx2(:), predictedspecies,'rgb');
   title(classifier_name{i})
   legend off, axis tight
end

legend(labels,'Location',[0.35,0.01,0.35,0.05],'Orientation','Horizontal')

Mdl1 = fitcnb(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure
ConfusionMat1 = confusionchart(y,categorical(isLabels1));

oldFolder = cd(catalog) % смена каталога

string sname;

%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------
sname=num+"exp5_nb.txt"
fileID = fopen(sname,'w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );

fclose(fileID);



Mdl1 = fitcdiscr(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure
ConfusionMat1 = confusionchart(y,categorical(isLabels1));
%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------

sname=num+"exp5_dicr.txt"
fileID = fopen(sname,'w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);

Mdl1 = fitctree(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure
ConfusionMat1 = confusionchart(y,categorical(isLabels1));
%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------
sname=num+"exp5_tree.txt"
fileID = fopen(sname,'w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );

fclose(fileID);


Mdl1 = fitcknn(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure;
ConfusionMat1 = confusionchart(y,categorical(isLabels1));

%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------


sname=num+"exp5_knn.txt"
fileID = fopen(sname,'w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );

fclose(fileID);



Mdl1 = fitcecoc(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure;
ConfusionMat1 = confusionchart(y,categorical(isLabels1));

%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------

sname=num+"exp5_svm.txt"
fileID = fopen(sname,'w');
%fileID = fopen('1exp5_svm.txt','w');
%fprintf(fileID,'%f %d %d %d %d\n',AUCsvm, ConfusionMat1.NormalizedValues   );
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );

fclose(fileID);

Mdl1 = fitcensemble(X,y); %,'ClassNames',{'1','2'});
isLabels1 = resubPredict(Mdl1);
figure
ConfusionMat1 = confusionchart(y,categorical(isLabels1));


%----------------------
[mat,~] = confusionmat(y,categorical(isLabels1));
len=size(mat,1);
TP=zeros(len,1);
TN=zeros(len,1);
FP=zeros(len,1);
FN=zeros(len,1);
Ai=zeros(len,1);
Pi=zeros(len,1);
Ri=zeros(len,1);
macroFi=zeros(len,1);
TotalSamples = sum(sum(mat));
for i=1:len
    TP(i)=mat(i,i);
    FP(i)=sum(mat(:, i))-mat(i,i);
    FN(i)=sum(mat(i,:))-mat(i,i);
    
    tempMat = mat;
    tempMat(:,i) = []; % remove column
    tempMat(i,:) = []; % remove row    
    TN(i) = sum(sum(tempMat));
    
    Ai(i)  = (TP(i)+TN(i)) / TotalSamples;           
    Pi(i) = TP(i)/(TP(i)+FP(i));
    Ri(i) = TP(i)/(TP(i)+FN(i));
    macroFi(i) = 2*Pi(i)*Ri(i)/(Pi(i)+Ri(i));
    
end
accuracy = mean(Ai,'omitnan');
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore];
%----------------------
sname=num+"exp5_ens.txt"
fileID = fopen(sname,'w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);
end

fileID = fopen("signal_stop.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);

fileID = fopen("signal_stop1.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);
