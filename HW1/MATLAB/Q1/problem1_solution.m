clc;
clear variables;

%% PART 1 - DETERMINING DEGREE OF POLYNOMIAL D

path = "N:\\My Drive\\Repositories\\ece-gy-6143\\HW1\\Figures\\Q1\\";       % Set path for saving figures

dataset = load('problem1.mat');     % Load the dataset which contains a structure

% Assigning structure values to variables
X = dataset.x;
y = dataset.y;

% Checking for the degree d from 1 to 7 to determine overfitting
for D=1:10
    [err, model] = polyreg(X, y, D);       % Returns the error and model coefficients
    
    title(sprintf('Degree of polynomial (d) = %d', D));     % Saving plot title with string formatting
    filename = sprintf(path + 'fig_d_%d.jpeg', D);      % Figure files are saved in Figures subfolder
    print(filename, '-djpeg');      % Saving the figures as .jpeg format for high-quality, low space requirements
    
    save('problem1_part1_values.mat', 'err', 'model');      % Save workspace variables
end

close all;

%% PART 2 - USING CROSS-VALIDATION & THEN DETERMINING DEGREE OF POLYNOMIAL D

% Dividing data into training and testing sets
[length, ~] = size(X);
[train, test] = crossvalind('HoldOut', length, 0.5);

% Training data
X_train = X(train);
y_train = y(train);

% Testing data
X_test = X(test);
y_test = y(test);

% Preallocating variables for speed optimization
model_training_errors = [];
model_testing_errors = [];
model_coefficients = {};

% Checking for the degree d from 1 to 60 to determine overfitting on training and testing data
for D=1:60
    [err, model, errT] = polyreg(X_train, y_train, D, X_test, y_test);        % Returns the error and model coefficients
    
    model_training_errors(D) = err;     
    model_testing_errors(D) = errT;     
    model_coefficients{D} = model;      
    
    save('problem1_part2_values.mat', 'err', 'errT', 'model');      % Save workspace variables
end

clf;        % Clear figure
hold on;        % Retain plot in current axes

% Plot model training and testing errors
plot(model_training_errors, 'b');
plot(model_testing_errors, 'r');

% Determine min testing error corresponding to D and mark with red X
[~, idx] = min(model_testing_errors);
plot(idx, model_testing_errors(idx), 'rX');

% Set plot labels and legend
xlabel('Degree of Polynomial (d) + 1');
ylabel('Error');
legend('Training', 'Testing');

title('Cross Validation Training and Testing Error');     % Saving plot title
filename = sprintf(path + 'fig_cross_validation_error.jpeg', D);      % Figure file saved in Figures subfolder
print(filename, '-djpeg');      % Saving the figures as .jpeg format for high-quality, low space requirements