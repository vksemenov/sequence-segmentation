%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Функция классификации
%  Вход : выборка X, метки y, номер классификатора Handle 
%  Выход: результаты работы классификатора res
%  Примечание:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function res = classification_fun( X,y,Handle)
arguments
    X(:,1)
    y(:,1)
    Handle {mustBeNumeric}
end

classifier = {'Naive Bayes','Discriminant Analysis', % используемые классификаторы
    'Classification Tree','Nearest Neighbor',
    'SVM','Ansamble'};

switch Handle                                        % номер классификатора
    case 1
        disp(classifier{1});
        Mdl1 = fitcnb(X,y);
    case 2
        disp(classifier{2});
        Mdl1 = fitcdiscr(X,y);
    case 3
        disp(classifier{3});
        Mdl1 = fitctree(X,y);
    case 4
        disp(classifier{4});
        Mdl1 = fitcknn(X,y);
    case 5
        disp(classifier{2});
         Mdl1=fitcecoc(X,y);
    case 6
        disp(classifier{6});
        Mdl1 = fitcensemble(X,y);      
    otherwise
        disp('other value')
end


isLabels1 = resubPredict(Mdl1);                     % построение матрицы результатов    

%ConfusionMat1 = confusionchart(y,categorical(isLabels1));
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
accuracy = mean(Ai,'omitnan');                               % вычисление показателей качества
precision=mean(Pi,'omitnan');
recall=mean(Ri,'omitnan');
macro_fscore=mean(macroFi,'omitnan');
micro_precision=nansum(TP)/(nansum(TP)+nansum(FP));
micro_recall=nansum(TP)/(nansum(TP)+nansum(FN));
micro_fscore=2*(micro_precision*micro_recall)/(micro_precision+micro_recall);
results=[accuracy precision recall macro_fscore micro_fscore TotalSamples];
%----------------------

res=results;                                                  % передача показателей качества из функции
end