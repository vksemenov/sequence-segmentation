function Yhat = xgboost_test(Xtest,model,loadmodel)



if loadmodel == 0
    h_booster_ptr = model.h_booster_ptr;
else
    if not(libisloaded('xgboost'))
        cwd = pwd; cd D:\r\xgboost\lib
        loadlibrary('xgboost')
        cd(cwd)
    end
    h_train_ptr = libpointer;
    h_train_ptr_ptr = libpointer('voidPtrPtr', h_train_ptr);
    h_booster_ptr = libpointer;
    h_booster_ptr_ptr = libpointer('voidPtrPtr', h_booster_ptr);
    len = uint64(0);
    calllib('xgboost', 'XGBoosterCreate', h_train_ptr_ptr, len, h_booster_ptr_ptr);
    res = calllib('xgboost', 'XGBoosterLoadModel', h_booster_ptr_ptr, model.model_filename);
    if res == -1
        disp('Model could not be loaded')
        return
    end
end


rows = uint64(size(Xtest,1));
cols = uint64(size(Xtest,2));
Xtest = Xtest';

h_test_ptr = libpointer;
h_test_ptr_ptr = libpointer('voidPtrPtr', h_test_ptr);
test_ptr = libpointer('singlePtr',single(Xtest));   

calllib('xgboost', 'XGDMatrixCreateFromMat', test_ptr, rows, cols, model.missing, h_test_ptr_ptr);

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

Yhat = double(f.Value);

if exist('h_test_ptr','var')
    calllib('xgboost', 'XGDMatrixFree',h_test_ptr); clear h_test_ptr
end

if loadmodel == 1
    if exist('h_booster_ptr','var')
        calllib('xgboost', 'XGBoosterFree',h_booster_ptr); clear h_booster_ptr
    end
end


