%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step4: forcast conditional variance%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use ARMA(2,2)-EGARCH(1,1)-t 
model_var_egarch=egarch('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Distribution','t');
model_egarch=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var_egarch);
[Estmodel_egarch,EstParam_egarch,logL_egarch]=estimate(model_egarch,table2array(returns(:,2)));
[E_egarch,V_egarch]=infer(Estmodel_egarch,table2array(returns(:,2)));
cast_period=10;%forcast period
[cast_returns_egarch,~,cast_variance_egarch]=forecast(Estmodel_egarch,cast_period,table2array(returns(:,2)),'E0',E_egarch,'V0',V_egarch);
mean(cast_variance_egarch);
plot(returns.Date,cast_variance_egarch);

% Use ARMA(2,2)-GJR(1,1)-t 
model_var_gjr=gjr('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Distribution','t');
model_gjr=arima('ARLags',[1,2],'MALags',[1,2],'Variance',model_var_gjr);
[Estmodel_gjr,EstParam_gjr,logL_gjr]=estimate(model_gjr,table2array(returns(:,2)));
[E_gjr,V_gjr]=infer(Estmodel_gjr,table2array(returns(:,2)));
cast_period=10;%forcast period
[cast_returns_gjr,~,cast_variance_gjr]=forecast(Estmodel_gjr,cast_period,table2array(returns(:,2)),'E0',E_gjr,'V0',V_gjr);
mean(cast_variance_gjr);
plot(returns.Date,cast_variance_gjr);
