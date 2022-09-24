%readin data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Date", "AdjClose"];
opts.VariableTypes = ["datetime", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Date", "InputFormat", "MM/dd/yyyy");

% Import the data
TSLA = readtable("C:\......\TSLA.csv", opts);

%% Clear temporary variables
clear opts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step1: deal with missing data%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%way 1: remove NaN records
prices=rmmissing(TSLA);

%way 2: replace NaN by the avergae value of 11 days' prices
temp=TSLA([10:20],[2]); %10-20 rows
temp_prices=table2array(temp);
mean_value=mean(temp_prices);
TSLA.AdjClose(isnan(TSLA.AdjClose)) = mean_value;
prices=TSLA;

%%%%%%%%%%%%%%%%%%%%%%%%
% Step2: obtain returns%
%%%%%%%%%%%%%%%%%%%%%%%%

%simple return
temp_returns=price2ret(TSLA.AdjClose); 
table_temp_returns=array2table(temp_returns); 
temp_date=TSLA(2:end,1);
returns=[temp_date, table_temp_returns]; 

%log-return
temp_returns=diff(log(prices.AdjClose)); 
table_temp_returns=array2table(temp_returns); 
temp_date=TSLA(2:end,1);
returns=[temp_date, table_temp_returns]; 