data_all = xlsread('D:\S.xlsx');
data_all = data_all(:,2:5); % Получить набор данных
data_train = data_all(1:2:end,:); % Получить набор данных обучения
data_test = data_all(2:2:end,:); % Получить набор тестовых данных
opt = anfisOptions('InitialFIS',3,'EpochNumber',10);
fis = anfis(data_train,opt); % Параметры обучения системы
data_test_input = data_test(:,1:3); % Ввод набора данных тестового набора данных

anfisOutput = evalfis(fis,data_test_input); % Проверка
figure 
len = length(data_test);
xlabel =(1:len)'; % Проверка серийного числа как горизонтальная координата
data_test_output = data_test(:,end);
plot(xlabel,data_test_output,'*r')
hold on
plot(xlabel,anfisOutput,'ob')
legend('Real Output','ANFIS Output') 