%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ver 1.0  27.03.2025  ISL
%  Функция классификации простая CNN
%  Вход : выборка X, метки y
%  Выход: res -результаты работы классификатора на базе CNN 
%  Примечание:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function res = classification_simple_CNN_fun( X,y)

inputs=transpose(X);                    % из столбиков делам строчки для нейросети
targets=transpose(y);

hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);


net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net.trainParam.showWindow = 0;       % сделать окно обучения невидимым
[net,tr] = train(net,inputs,targets);

outputs = net(inputs);
%errors = gsubtract(targets,outputs);
%performance = perform(net,targets,outputs)

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)

% Считаем показатели качества
%[values,pred_ind]=max(outputs,[],1);
%[~,actual_ind]=max(targets,[],1);
%accuracy=sum(pred_ind==actual_ind)/size(inputs,2);

%tp = sum((pred_ind == 1) & (actual_ind == 1));
%fp = sum((pred_ind == 1) & (actual_ind == 2));
%fn = sum((pred_ind == 2) & (actual_ind == 1));

%precision = tp / (tp + fp);
%recall = tp / (tp + fn);
%micro_fscore = (2 * precision * recall) / (precision + recall); %F1
%macro_fscore=0;
%TotalSamples=size(inputs,2);
%----------------------
%results=[accuracy precision recall macro_fscore micro_fscore TotalSamples];
res=outputs;  
                                    % передача показателей качества из функции
end