%% clear data and figure
clc;
clear;
close all;
tic
% add path to MATLAB
addpath('..\Modelcode')
% load data
load .\data\roadhour.mat;
load .\data\order.mat;
load .\data\parameter.mat;
% data set setting
train_data_length = 30*24;
% val_data_length = 16*24;
% from August 1st to September 15th
% train_val_data_index = [1:train_data_length+val_data_length]';
test_data_length = 15*24;
% from September 15 to 30
train_test_data_index = [(length(roadhour)-test_data_length-train_data_length)+1:length(roadhour)]';
% val_step = 24;
test_step = 24;
% model setting
omega=pi/12; % angular frequency
%% read data from .csv
road4fit_ARIMA = readtable(".\benchmark_statistical_model_data\road4fit_ARIMA.csv",'VariableNamingRule','preserve');
road4fit_ARIMA.Var1=[];
road4fit_ARIMA = table2array(road4fit_ARIMA);
road4pre_ARIMA = readtable(".\benchmark_statistical_model_data\road4pre_ARIMA.csv",'VariableNamingRule','preserve');
road4pre_ARIMA.Var1=[];
road4pre_ARIMA = table2array(road4pre_ARIMA);
road4fit_ets = readtable(".\benchmark_statistical_model_data\road4fit_ets.csv",'VariableNamingRule','preserve');
road4fit_ets.Var1=[];
road4fit_ets = table2array(road4fit_ets);
road4pre_ets = readtable(".\benchmark_statistical_model_data\road4pre_ets.csv",'VariableNamingRule','preserve');
road4pre_ets.Var1=[];
road4pre_ets = table2array(road4pre_ets);
%% figure setting
% figure setting
fig=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5, 5, 30,15],'PaperSize',[30,15]);
tit={['(a) Road ',num2str(roadindex(1))],['(b) Road ',num2str(roadindex(2))],['(c) Road ',num2str(roadindex(3))],['(d) Road ',num2str(roadindex(4))]};
tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact'); % new subfigure
len={["Actual data","SARIMA","HW","NGFM(1,1,1)"],...
    ["Actual data","SARIMA","HW","NGFM(1,1,4)"],...
    ["Actual data","SARIMA","HW","NGFM(1,1,3)"],...
    ["Actual data","SARIMA","HW","NGFM(1,1,3)"]};
timestart=datetime(2016,09,16,0,0,0); % from September 22st
time=dateshift(timestart,'start','hour',0:test_data_length-1); 
%% begin loop
for l=1:4
    orderi=order(l,1);
    gammai=gammaopt(l,1);
    sigmai=sigmaopt(l,1);
    road_train_test=roadhour(train_test_data_index,roadsample(l));
    datalength=length(road_train_test);
    k=1; % Mark the first position of the data to be calculated
    road_train_all=[];
    road_fit_all=[];
    road_test_all=[];
    road_pre_all=[];
    while (k+train_data_length+test_step-1)<=datalength
        % train data
        road_train=road_train_test(k:k+train_data_length-1);
        road_train_all=[road_train_all;road_train];
        % test data
        road_test=road_train_test(k+train_data_length:k+train_data_length+test_step-1);
        road_test_all=[road_test_all;road_test];
        % call model code
        road_fit_pre = NGFM(road_train,omega,orderi,gammai,sigmai,test_step);
        % fitting data
        road_fit=road_fit_pre(1:train_data_length);
        % all fitting data
        road_fit_all=[road_fit_all;road_fit];
        % predictive data
        road_pre=road_fit_pre(train_data_length+1:end);
        % all predictive data
        road_pre_all=[road_pre_all;road_pre];
        % location update
        k=k+test_step;
    end
    road4_train_all=repmat(road_train_all,1,3);
    road4_fit_all=[road4fit_ARIMA(:,l),road4fit_ets(:,l),road_fit_all];
    road4_test_all=repmat(road_test_all,1,3);
    road4_pre_all=[road4pre_ARIMA(:,l),road4pre_ets(:,l),road_pre_all];
    % compute mean absolute error
    mae_fit=mean(abs(road4_fit_all-road4_train_all),1,'omitnan'); 
    mae_pre=mean(abs(road4_pre_all-road4_test_all),1,'omitnan');
    mae2latex(:,2*l-1)=mae_fit';
    mae2latex(:,2*l)=mae_pre';
    nexttile % next subfigure
    plot(time,road4_test_all)
    hold on
    plot(time,road4_pre_all)
    grid on
    set(gca,'FontName','Book Antiqua','FontSize',8); % 'YLim',ylim(i,:),
    xlabel('Time','FontSize',10);
    xtickformat('yy-MM-dd')
    ylabel({'Speed (km/h)'},'FontSize',10);
    title(tit(l),'FontWeight','bold','FontSize',10);
    legend(len{l},'FontSize',8,'NumColumns',2,'Location','southeast');
end
% save figure
% savefig(gcf,'.\figure\compare_statistic.fig');
toc