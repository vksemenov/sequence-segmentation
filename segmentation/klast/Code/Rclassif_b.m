%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Прогон всей выборки через классификаторы
%  Вход : файл выборки через config файл D:\klast\klast_iran\config\config.txt
%  Выход: результаты работы exp<1-5>_<классификатор>.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"

clear all
rng('default')  % For reproducibility

fid = fopen('D:\klaster\klast_iran\config\config.txt');
filename = fgetl(fid) % прочитанная строка без символа новой строки
catalog = fgetl(fid) % прочитанная строка без символа новой строки

%filename = 'D:\klast\klast_iran\all_4m.txt'; %основная выборка

delimiterIn = ' ';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);

i=0;
%figure;
for k = [1:2]
  X=A.data(:,k)
end

figure;
y = categorical(A.data(:,3));
labels = categories(y);
gscatter(A.data(:,1),A.data(:,2),y);
xlabel('Sepal length');
ylabel('Sepal width');

X(:,1)=A.data(:,1)
X(:,2)=A.data(:,2)
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

oldFolder = cd(catalog) % смена каталога
legend(labels,'Location',[0.35,0.01,0.35,0.05],'Orientation','Horizontal')

Mdl1 = fitcnb(X,y) ; %,'ClassNames',{'0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'});
isLabels1 = resubPredict(Mdl1);


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
fileID = fopen('exp5_nb.txt','w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);



Mdl1 = fitcdiscr(X,y);
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
fileID = fopen('exp5_dicr.txt','w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);

Mdl1 = fitctree(X,y); %,'ClassNames',{'1','2'});
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
fileID = fopen('exp5_tree.txt','w');
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
fileID = fopen('exp5_knn.txt','w');
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
fileID = fopen('exp5_svm.txt','w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);

Mdl1 = fitcensemble(X,y) ; %,'ClassNames',{'1','2'});
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
fileID = fopen('exp5_ens.txt','w');
fprintf(fileID,'%f %f %f %f %f %d\n', accuracy, precision, recall, macro_fscore, micro_fscore, TotalSamples  );
fclose(fileID);

fileID = fopen("signal_stop_Rclassif.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);


