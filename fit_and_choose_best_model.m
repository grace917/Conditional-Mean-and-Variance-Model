%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A: Use ARMA(2,2)-GARCH(1,1)-t %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res=nan(length(returns.temp_returns),1);
[temp_theta,temp_sig2,temp_vcv,temp_res,temp_yhat]=ARMAX_2(returns.temp_returns,2,2); %fit ARMA(2,2)
res(:,1)=[zeros(2,1);temp_res];

N=1; %using N to control GRACH and ARCH lags
vol=nan(length(temp_returns),N);
for i=1:N
    var_model=garch('GARCHLags',1:N,'ARCHLags',1:N);
    Mdl.var_model="t";
    var_model=estimate(var_model,res);
    var=infer(var_model,res);
    vol(:,i)=var;
end
std_ret=res./sqrt(vol);
plot(returns.Date,std_ret);
title('Standardized Residuals using ARMA(2,2)-GARCH(1,1)-t');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B: Use ARMA(2,2)-EGARCH(1,1,1)-t %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res=nan(length(returns.temp_returns),1);
[temp_theta,temp_sig2,temp_vcv,temp_res,temp_yhat]=ARMAX_2(returns.temp_returns,2,2); %fit ARMA(2,2)
res(:,1)=[zeros(2,1);temp_res];

N=1; %using N to control GRACH and ARCH lags and Leverage lags
vol=nan(length(temp_returns),N);
for i=1:N
    var_model=egarch('GARCHLags',1:N,'ARCHLags',1:N,'LeverageLags',1:N,'Distribution','t');
    var_model=estimate(var_model,res);
    var=infer(var_model,res);
    vol(:,i)=var;
end
std_ret=res./sqrt(vol);
plot(returns.Date,std_ret);
title('Standardized Residuals using ARMA(2,2)-EGARCH(1,1)-t');

%Alternative method
model_var=egarch('GARCHLags',1:N,'ARCHLags',1:N,'LeverageLags',1:N,'Distribution','t');
model=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var);
estimate_model1=estimate(model1,table2array(returns(:,2)));
[res_alt,v_alt,logL_alt]=infer(estimate_model1,table2array(returns(:,2)));
std_ret_alt=res_alt./sqrt(v_alt);

%plot
plot(returns.Date,std_ret);
hold on
plot(returns.Date,std_ret_alt);
hold off
title('Standardized Residuals');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C: use AIC to choose the best model among ARMA(2,2)-GARCH(1,1)/EGARCH(1,1,1)/GJR(1,1,1)-t %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model_var1=garch('GARCHLags',1,'ARCHLags',1,'Distribution','t');
model1=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var1);
[Estmodel1,EstParam1,logL1]=estimate(model1,table2array(returns(:,2)));
numParams1=sum(any(EstParam1));
[aic1,bic1]=aicbic(logL1,numParams1,length(table2array(returns(:,2))));

model_var2=egarch('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Distribution','t');
model2=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var2);
[Estmodel2,EstParam2,logL2]=estimate(model2,table2array(returns(:,2)));
numParams2=sum(any(EstParam2));
[aic2,bic2]=aicbic(logL2,numParams2,length(table2array(returns(:,2))));

model_var3=gjr('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Distribution','t');
model3=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var3);
[Estmodel3,EstParam3,logL3]=estimate(model3,table2array(returns(:,2)));
numParams3=sum(any(EstParam3));
[aic3,bic3]=aicbic(logL3,numParams3,length(table2array(returns(:,2))));

aic=[aic1, aic2, aic3];
[val,idx]=min(aic); %idx=2 means aic2 is the smallest aic