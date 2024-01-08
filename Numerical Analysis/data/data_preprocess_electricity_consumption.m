clc;
clear;
close all
%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 2);
% Specify sheet and range
opts.Sheet = "Fill in data";
opts.DataRange = "A2:B157";
% Specify column names and types
opts.VariableNames = ["date1", "electricityconsumption"];
opts.VariableTypes = ["datetime", "double"];
% Specify variable properties
opts = setvaropts(opts, "date1", "InputFormat", "");
% Import the data
tbl = readtable(".\electricity consumption of primary industries.xlsx", opts, "UseExcel", false);
% Convert to output type
date1 = tbl.date1;
electricityconsumption = tbl.electricityconsumption;
% Clear temporary variables
clear opts tbl
%% Monthly data to quarterly data
m = 3;
n = length(electricityconsumption)/m;
electricitymatrix = reshape(electricityconsumption, m, n)';
electricityquarter= sum(electricitymatrix,2);
datequarter = date1(3:3:end);
% data set setting
train_data_length = 24;
val_data_length = 16;
test_data_length = 12;
% plot
figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5, 5, 30,15],'PaperSize',[30,15]);
plot(datequarter,electricityquarter,'-o','LineWidth',1.5)
rectangle('Position', [-55, 0, 2185, 600],'FaceColor',[0.05 0.05 0.05 0.05]);
rectangle('Position', [2130, 0, 365*4, 600],'FaceColor',[0.9290 0.6940 0.1250 0.05]);
rectangle('Position', [2130+365*4, 0, 365*3, 600],'FaceColor',[.8500 0.3250 0.0980 0.10]);
xline(dateshift(datequarter(train_data_length+4),'start','day',30),'--','HandleVisibility','off')
xline(dateshift(datequarter(train_data_length+8),'start','day',30),'--','HandleVisibility','off')
xline(dateshift(datequarter(train_data_length+12),'start','day',30),'--','HandleVisibility','off')
xline(dateshift(datequarter(train_data_length+val_data_length+4),'start','day',30),'--','HandleVisibility','off')
xline(dateshift(datequarter(train_data_length+val_data_length+8),'start','day',30),'--','HandleVisibility','off')
% xline(valdate,'--','HandleVisibility','off')
% Create textbox
annotation(gcf,'textbox',...
    [0.25 0.84 0.15 0.05],...
    'String','training set',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',14);
% Create textbox
annotation(gcf,'textbox',...
    [0.55 0.84 0.15 0.05],...
    'String','validation set',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',14);
% Create textbox
annotation(gcf,'textbox',...
    [0.785 0.84 0.08 0.05],...
    'String','test set',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',14);
% val subset
% Create textbox
annotation(gcf,'textbox',...
    [0.49 0.74 0.15 0.05],...
    'String','subset1',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
annotation(gcf,'textbox',...
    [0.49+0.058 0.74 0.15 0.05],...
    'String','subset2',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
annotation(gcf,'textbox',...
    [0.49+2*0.058 0.74 0.15 0.05],...
    'String','subset3',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
annotation(gcf,'textbox',...
    [0.49+3*0.058 0.74 0.15 0.05],...
    'String','subset4',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
% test subset
annotation(gcf,'textbox',...
    [0.495+4*0.058 0.74 0.15 0.05],...
    'String','subset1',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
% test subset
annotation(gcf,'textbox',...
    [0.495+5*0.058 0.74 0.15 0.05],...
    'String','subset2',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
% test subset
annotation(gcf,'textbox',...
    [0.495+6*0.058 0.74 0.15 0.05],...
    'String','subset3',...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontName','Book Antiqua','FontSize',12);
% figure setting
set(gca,'FontName','Book Antiqua','FontSize',10); % 'YLim',ylim(i,:),
xlabel('Date','FontSize',12);
xtickformat('yyyy-MM')
ylabel({'electricity consumption (Twh)'},'FontSize',14);
savefig(gcf,'..\figure\electricity_consumption.fig');
exportgraphics(gcf,'F:\博士\Nonlinear grey Fourier model\manuscript\figure\electricity_consumption.pdf')
% save
save('electricityconsumption.mat','electricityquarter','datequarter')
writematrix(electricityquarter,'D:\workspace\R\NGFM\data\electricityquarter.csv');

