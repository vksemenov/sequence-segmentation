function model = xgboost_train(Xtrain,ytrain,params,max_num_iters,eval_metric,model_filename)

skipme = 1;
if skipme == 0
    load carsmall; Xtrain = [Acceleration Cylinders Displacement Horsepower MPG]; ytrain = cellstr(Origin); ytrain = double(ismember(ytrain,'USA'))
    params = struct;
    params.booster           = 'gbtree';
    params.objective         = 'binary:logistic';
    params.eta               = 0.1;
    params.min_child_weight  = 1;
    params.subsample         = 1;
    params.colsample_bytree  = 1;
    params.num_parallel_tree = 1;
    params.max_depth         = 5;
    num_iters                = 3;
    model = xgboost_train(Xtrain,ytrain,params,num_iters,'None',[]);
    Yhat = xgboost_test(Xtrain,model,0);
    figure; plot(Yhat)
    figure; scatter(Yhat,ytrain + 0.1*rand(length(ytrain),1)); grid on
end


skipme = 1;
if skipme == 0
    
    save_model_to_disk = 0;
    eval_metric        = 'Accuracy';
    
    if save_model_to_disk == 1
        model_filename = 'xgb_model.xgb';
    else
        model_filename = [];
    end
    
    folds = 5;
    cvind = ceil(folds*[1:size(Xtrain,1)]/(size(Xtrain,1)))';
    rand('state', 0); u1 = rand(size(Xtrain,1),1); cvind = sortrows([u1 , cvind],1); cvind = cvind(:,2:end); clear u1
    
    params = struct;
    params.booster           = 'gbtree';
    params.objective         = 'binary:logistic';
    params.eta               = 0.1;
    params.min_child_weight  = 1;
    params.subsample         = 1;
    params.colsample_bytree  = 1;
    params.num_parallel_tree = 1;
    
    
	params.max_depth_all     = [1:5];
    num_iters_all            = 2.^(1:10);
    
    CVACC = [];
    CVAUC = [];
    for i=1:length(params.max_depth_all)
        params.max_depth = params.max_depth_all(i);
        for j=1:length(num_iters_all)
            disp(['i=' num2str(i) '/' num2str(length(params.max_depth_all)) ', j=' num2str(j) '/' num2str(length(num_iters_all))])
            YhatCV_all = zeros(size(Xtrain,1),1);
            for kk=1:folds
                num_iters = num_iters_all(j);
                model = xgboost_train(Xtrain(cvind~=kk,:),ytrain(cvind~=kk),params,num_iters,'None',[]);
                YhatCV_all(cvind==kk) = xgboost_test(Xtrain(cvind==kk,:),model,0);
            end
            if strcmp(eval_metric,'Accuracy')
                CVACC = [CVACC; [sum(ytrain == round(YhatCV_all))/length(ytrain) params.max_depth num_iters]];
            elseif strcmp(eval_metric,'AUC')
                [~,~,~,AUC] = perfcurve(ytrain,YhatCV_all,0);
                CVAUC = [CVAUC; [AUC params.max_depth num_iters]];
            end
        end
    end
    if strcmp(eval_metric,'Accuracy')
        CV_metric_optimal = CVACC(CVACC(:,1) == max(CVACC(:,1)),:);
    elseif strcmp(eval_metric,'AUC')
        CV_metric_optimal = CVAUC(CVAUC(:,1) == max(CVAUC(:,1)),:);
    end
    params.max_depth = CV_metric_optimal(1,2);
    num_iters        = CV_metric_optimal(1,3);
    model = xgboost_train(Xtrain,ytrain,params,num_iters,'None',model_filename);
    YhatTrain = xgboost_test(Xtrain,model,save_model_to_disk);
    if isfield(model,'h_booster_ptr')
        calllib('xgboost', 'XGBoosterFree',model.h_booster_ptr);
        model = rmfield(model,'h_booster_ptr');
    end

    figure; scatter(YhatTrain, ytrain + 0.1*rand(length(ytrain),1)); grid on

    if strcmp(eval_metric,'Accuracy')
        CVperf = CVACC;
        CV_performance = 'CV Accuracy';
    elseif strcmp(eval_metric,'AUC')
        CVperf = CVAUC;
        CV_performance = 'CV AUC';
    end
    [Z1,Z2] = meshgrid(params.max_depth_all,num_iters_all);
    Z = reshape(CVperf(:,1),size(Z1,1),size(Z1,2));
    figure; surfc(Z1,Z2,Z); alpha(0.2); xlabel('max depth'); ylabel('num iters'), zlabel(CV_performance)
    
end



early_stopping_rounds = 10;
folds = 5;
missing = single(NaN);


if isempty(Xtrain)
    load carsmall
    Xtrain = [Acceleration Cylinders Displacement Horsepower MPG];
    ytrain = cellstr(Origin);
    ytrain = double(ismember(ytrain,'USA'));
end


if isempty(max_num_iters)
    max_num_iters = 999;
end    
        

if isempty(params)
    params.booster           = 'gbtree';
    params.objective         = 'binary:logistic';
    params.max_depth         = 5;
    params.eta               = 0.1;
    params.min_child_weight  = 1;
    params.subsample         = 0.9;
    params.colsample_bytree  = 1;
    params.num_parallel_tree = 1;
end


param_fields = fields(params);
for i=1:length(param_fields)
    eval(['params.' param_fields{i} ' = num2str(params.' param_fields{i} ');'])
end

if not(libisloaded('xgboost'))
    cwd = pwd; cd D:\r\xgboost\lib
    loadlibrary('xgboost')
    cd(cwd)
end

if ~strcmp(eval_metric,'None')
    cvind = ceil(folds*[1:size(Xtrain,1)]/(size(Xtrain,1)))';
    rand('state', 0); u1 = rand(size(Xtrain,1),1); cvind = sortrows([u1 , cvind],1); cvind = cvind(:,2:end); clear u1
    iters_reached_per_fold = zeros(folds,1);
    for kk = 1:folds

        rows = uint64(sum(cvind~=kk));
        cols = uint64(size(Xtrain,2));

        train_ptr = libpointer('singlePtr',single(Xtrain(cvind~=kk,:)'));
        train_labels_ptr = libpointer('singlePtr',single(ytrain(cvind~=kk)));

        h_train_ptr = libpointer;
        h_train_ptr_ptr = libpointer('voidPtrPtr', h_train_ptr);

        calllib('xgboost', 'XGDMatrixCreateFromMat', train_ptr, rows, cols, missing, h_train_ptr_ptr);

        labelStr = 'label';
        calllib('xgboost', 'XGDMatrixSetFloatInfo', h_train_ptr, labelStr, train_labels_ptr, rows);

        h_booster_ptr = libpointer;
        h_booster_ptr_ptr = libpointer('voidPtrPtr', h_booster_ptr);
        len = uint64(1);

        calllib('xgboost', 'XGBoosterCreate', h_train_ptr_ptr, len, h_booster_ptr_ptr);
        for i=1:length(param_fields)
            eval(['calllib(''xgboost'', ''XGBoosterSetParam'', h_booster_ptr, ''' param_fields{i} ''', ''' eval(['params.' param_fields{i}]) ''');'])
        end

        AUC_ = [];
        Acc_ = [];

        h_test_ptr = libpointer;
        h_test_ptr_ptr = libpointer('voidPtrPtr', h_test_ptr);
        test_ptr = libpointer('singlePtr',single(Xtrain(cvind==kk,:)'));
        yCV      = ytrain(cvind==kk);
        rows = uint64(sum(cvind==kk));
        cols = uint64(size(Xtrain,2));
        calllib('xgboost', 'XGDMatrixCreateFromMat', test_ptr, rows, cols, missing, h_test_ptr_ptr);

       for iter = 0:max_num_iters
            calllib('xgboost', 'XGBoosterUpdateOneIter', h_booster_ptr, int32(iter), h_train_ptr);

            out_len = uint64(0);
            out_len_ptr = libpointer('uint64Ptr', out_len);
            f = libpointer('singlePtr');
            f_ptr = libpointer('singlePtrPtr', f);
            option_mask = int32(0);
            ntree_limit = uint32(0);
            training = int32(0);
            calllib('xgboost', 'XGBoosterPredict', h_booster_ptr, h_test_ptr, option_mask, ntree_limit, training, out_len_ptr, f_ptr);

            n_outputs = out_len_ptr.Value;
            setdatatype(f,'singlePtr',n_outputs);

            YhatCV = double(f.Value);

            switch eval_metric
                case 'AUC'
                    [~,~,~,AUC] = perfcurve(yCV,YhatCV,1);
                    AUC_ = [AUC_; AUC];
                    if length(AUC_) > early_stopping_rounds && AUC_(iter-early_stopping_rounds+2) == max(AUC_(iter-early_stopping_rounds+2:end))
                        iters_reached_per_fold(kk) = iter-early_stopping_rounds+2;
                        break
                    end
                case 'Accuracy'
                    Acc = [sum(yCV == round(YhatCV)) / length(yCV)];
                    Acc_ = [Acc_; Acc];
                    if length(Acc_) > early_stopping_rounds && Acc_(iter-early_stopping_rounds+2) == max(Acc_(iter-early_stopping_rounds+2:end))
                        iters_reached_per_fold(kk) = iter-early_stopping_rounds+2;
                        break
                    end
                otherwise
                    if exist('h_train_ptr','var')
                        calllib('xgboost', 'XGDMatrixFree',h_train_ptr); clear h_train_ptr
                    end
                    if exist('h_test_ptr','var')
                        calllib('xgboost', 'XGDMatrixFree',h_test_ptr); clear h_test_ptr
                    end
                    if exist('h_booster_ptr','var')
                        calllib('xgboost', 'XGBoosterFree',h_booster_ptr); clear h_booster_ptr
                    end
                    disp('Evaluation metric not supported')
                    return
            end
        end

        if exist('h_train_ptr','var')
            calllib('xgboost', 'XGDMatrixFree',h_train_ptr); clear h_train_ptr
        end
        if exist('h_test_ptr','var')
            calllib('xgboost', 'XGDMatrixFree',h_test_ptr); clear h_test_ptr
        end
        if exist('h_booster_ptr','var')
            calllib('xgboost', 'XGBoosterFree',h_booster_ptr); clear h_booster_ptr
        end
    end
    iters_optimal = round(mean(iters_reached_per_fold));
    disp('optimal iterations per cv fold:')
    disp(iters_reached_per_fold)
else
    iters_optimal = max_num_iters;
end


rows = uint64(size(Xtrain,1));
cols = uint64(size(Xtrain,2));
Xtrain = Xtrain';

train_ptr = libpointer('singlePtr',single(Xtrain));
train_labels_ptr = libpointer('singlePtr',single(ytrain));

h_train_ptr = libpointer;
h_train_ptr_ptr = libpointer('voidPtrPtr', h_train_ptr);

calllib('xgboost', 'XGDMatrixCreateFromMat', train_ptr, rows, cols, missing, h_train_ptr_ptr);

labelStr = 'label';
calllib('xgboost', 'XGDMatrixSetFloatInfo', h_train_ptr, labelStr, train_labels_ptr, rows);

h_booster_ptr = libpointer;
h_booster_ptr_ptr = libpointer('voidPtrPtr', h_booster_ptr);
len = uint64(1);

calllib('xgboost', 'XGBoosterCreate', h_train_ptr_ptr, len, h_booster_ptr_ptr);
for i=1:length(param_fields)
    eval(['calllib(''xgboost'', ''XGBoosterSetParam'', h_booster_ptr, ''' param_fields{i} ''', ''' eval(['params.' param_fields{i}]) ''');'])
end

for iter = 0:iters_optimal
    calllib('xgboost', 'XGBoosterUpdateOneIter', h_booster_ptr, int32(iter), h_train_ptr);
end


model                = struct;
model.iters_optimal  = iters_optimal;
model.h_booster_ptr  = h_booster_ptr;
model.params         = params;
model.missing        = missing;
model.model_filename = '';

if ~(isempty(model_filename) || strcmp(model_filename,''))
    calllib('xgboost', 'XGBoosterSaveModel', h_booster_ptr_ptr, model_filename);
    model.model_filename = model_filename;
end

if exist('h_train_ptr','var')
    calllib('xgboost', 'XGDMatrixFree',h_train_ptr); clear h_train_ptr
end
if exist('h_booster_ptr','var')
end