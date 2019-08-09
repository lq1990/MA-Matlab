% Goal: 
%   use C++ to train & validate RNN model and get parameters.
%   Parameters are going to be used in Matlab

% More details:
%   Dataset is divided into 3 parts: Training / Cross Validation / Test
%   To be trained data: list_data that may contains all scenarios-signals of Arteon and Geely
%       list_data is a list whose elements are structs {id, score, matData}
%       like this [ {id, score, matData} , {} , {}, ...]
%   How to obtain list_data:
%       list_train should be 
%           transformed from dataSArr and dataSArr_Geely
%           divided into 3 parts: training/cv/test
%           the training dataset is going to be z-score normalized.
%         
%               the mean/std values are saved 
%                   to norm new test data in the post-phase

% Hints:
%   For the training: matDataZScore & score are needed.
