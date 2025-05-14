function [bestnet,anfis_output,RMSE]=myanfis(data_all,epoch_n,mf,step_size,decrease_rate,increase_rate)


inputs=data_all(:,1:end-1);
output=data_all(:,end);
ndata=size(data_all,1);


ni=size(inputs,2);

nc=mf^ni;

Node_n = ni + ni*mf + 3*nc + 1;

min_RMSE=999999999999;

mparams=[];


kparams=zeros(nc,(ni+1));


config=zeros(Node_n);
nodes=zeros(Node_n,1);


st=ni;
for i=1:ni
    config(i,st+[1:mf])=1;
    st=st+mf;
end


st=ni+ni*mf+1;


for i=1:nc
    for j=1:nc
        config(ni+ni*mf+i,ni+ni*mf+nc+j)=1;
    end
end

for i=1:nc
    config(ni+ni*mf+nc+i,ni+ni*mf+2*nc+i)=1;
end


for i=1:nc
    config(ni+ni*mf+2*nc+i,end)=1;
end


for i=1:ni
    for j=1:nc
        config(i,ni+ni*mf+2*nc+j)=1;
    end
end


mynet.config=config;
mynet.mparams=mparams;
mynet.kparams=kparams;
mynet.nodes=nodes;
mynet.ni=ni;
mynet.mf=mf;
mynet.nc=nc;
mynet.last_decrease_ss=1;
mynet.last_increase_ss=1;



for iter=1:epoch_n
    for j=1:ndata
        
        mynet.nodes(1:mynet.ni)=inputs(j,:)';
        
        mynet=calculate_output1(mynet);
        mynet=calculate_output2(mynet);
        mynet=calculate_output3(mynet);
        
        layer_1_to_3_output(:,j)=mynet.nodes;
        

        kalman_data=get_kalman_data(mynet,output(j));

        mynet=mykalman(mynet,kalman_data,j);
        
    end

    mynet=clear_de_dp(mynet);
    
    for j=1:ndata
        

        mynet.nodes=layer_1_to_3_output(:,j);
        

        mynet=calculate_output4(mynet);
        

        mynet=calculate_output5(mynet);

        anfis_output(j,1)=mynet.nodes(end);
        target=output(j);

        de_dout = -2*(target - anfis_output(j,1));

        mynet=calculate_de_do(mynet,de_dout);
        mynet=update_de_do(mynet);
        
        
    end
    

    diff=anfis_output-output;
    total_squared_error=sum(diff.*diff);
    RMSE(iter,1) = sqrt(total_squared_error/ndata);
    fprintf('%g. rmse error : %g \n',iter,RMSE(iter,1));

    if RMSE(iter,1)<min_RMSE
        bestnet=mynet;
        min_RMSE=RMSE(iter,1);
    end
    

    mynet=update_parameter(mynet, step_size);
    [mynet step_size]=update_step_size(mynet,RMSE,iter,step_size,decrease_rate, increase_rate);
    
end


mynet=bestnet;
for j=1:ndata
    mynet.nodes(1:mynet.ni)=inputs(j,:)';
    mynet=calculate_output1(mynet);
    mynet=calculate_output2(mynet);
    mynet=calculate_output3(mynet);
    mynet=calculate_output4(mynet);
    mynet=calculate_output5(mynet);
    anfis_output(j,1)=mynet.nodes(end);
end