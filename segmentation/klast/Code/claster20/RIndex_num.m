%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Разбиение количества кластеров различными способами
%  Прогон всей выборки через классификаторы
%  Вход : файл выборки через config файл 
%  D:\klast\klast_iran\config\config_num.txt в нем количество класстеров
%  Выход: результаты работы указание кластера для записей разными способами
%  кластеризации:
%                           numklast_sqeuclidean.txt
%                           numklast_cosine.txt
%                           numklast_cityblock.txt
%                           numklast_correlation.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
set(gcf,'Visible','off')              % turns current figure "off"
set(0,'DefaultFigureVisible','off');  % all subsequent figures "off"

clear all;
rng('default')  % For reproducibility

fid = fopen('D:\klaster\klast_iran\config\config_num.txt');
filename = fgetl(fid) % прочитанная строка без символа новой строки
catalog = fgetl(fid) % прочитанная строка без символа новой строки
str = fgetl(fid) % прочитанная строка без символа новой строки
num=str2num(str);
%filename = 'D:\klast\klast_iran\all_4m.txt'; % Основная выборка

delimiterIn = ' ';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);

i=0;
%figure;
for k = [1:2]
  X=A.data(:,k)
  plot(X) ;% Выбор области окна для построения
 scatter(A.data(:,1),A.data(:,2),1,A.data(:,3));
end

oldFolder = cd(catalog) % смена каталога

% кластеризация с евклидово расстоянием
figure;
opts = statset('Display','final');
[idx,C] = kmeans(A.data,num,'Distance','sqeuclidean',...
    'Replicates',20,'Options',opts);

gscatter(A.data(:,1),A.data(:,2),idx,'rbgmyc')
hold on
plot(C(:,1),C(:,2),'kx') 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


fileID = fopen('numklast_sqeuclidean.txt','w');
fprintf(fileID,'%d \n',idx);
fclose(fileID);


% кластеризация с манхеттенским расстоянием
figure;
opts = statset('Display','final');
[idx,C] = kmeans(A.data,num,'Distance','cityblock',...
    'Replicates',20,'Options',opts);

gscatter(A.data(:,1),A.data(:,2),idx,'rbgmyc')
hold on
plot(C(:,1),C(:,2),'kx') 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


fileID = fopen('numklast_cosine.txt','w');
fprintf(fileID,'%d \n',idx);
fclose(fileID);


% кластеризация с косинусным расстоянием
figure;
opts = statset('Display','final');
[idx,C] = kmeans(A.data,num,'Distance','cosine',...
    'Replicates',20,'Options',opts);

gscatter(A.data(:,1),A.data(:,2),idx,'rbgmy')
hold on
plot(C(:,1),C(:,2),'kx') 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


fileID = fopen('numklast_cityblock.txt','w');
fprintf(fileID,'%d \n',idx);
fclose(fileID);



% кластеризация с корреляционным расстоянием
figure;
opts = statset('Display','final');
[idx,C] = kmeans(A.data,num,'Distance','correlation',...
    'Replicates',20,'Options',opts);

gscatter(A.data(:,1),A.data(:,2),idx,'rbgmy')
hold on
plot(C(:,1),C(:,2),'kx') 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


fileID = fopen('numklast_correlation.txt','w');
fprintf(fileID,'%d \n',idx);
fclose(fileID);

fileID = fopen("signal_stop_Rindex.txt",'w');
fprintf(fileID,"Process Stop"  );
fclose(fileID);