
%Project Title: Brain Tumor Detection using Machine Learning ALgorithm 
%Author: Boto A Ayemi
%Contact: botoresearchworks@gmail.com



function varargout = BTTest(varargin)
% BTTEST MATLAB code for BTTest.fig
%      BTTEST, by itself, creates a new BTTEST or raises the existing
%      singleton*.
%0.10441
%      H = BTTEST returns the handle to a new BTTEST or the handle to
%      the existing singleton*.
%
%      BTTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BTTEST.M with the given input arguments.
%
%      BTTEST('Property','Value',...) creates a new BTTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BTTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BTTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BTTest

% Last Modified by GUIDE v2.5 29-May-2020 22:20:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BTTest_OpeningFcn, ...
                   'gui_OutputFcn',  @BTTest_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BTTest is made visible.
function BTTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BTTest (see VARARGIN)

% Choose default command line output for BTTest
handles.output = hObject;
handles.output = hObject;
img = ones(200,200);
axes(handles.axes1);
%imshow(img);
axes(handles.axes2);
%imshow(img);
axes(handles.axes3);
%imshow(img);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BTTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BTTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uploadPBtn.
function uploadPBtn_Callback(hObject, eventdata, handles)
% hObject    handle to uploadPBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick an MRI Image');
if isequal(FileName,0)||isequal(PathName,0)
    warndlg('User Press Cancel');
else
    %I = imread([PathName,FileName]);
    I = imresize(I,[200,200]);
    
    
  

   %using median filter
  % I = medfilt2(P);
 % N = imnoise(rgb2gray(I),'salt & pepper',0.02);
  %subplot(1,2,1);

  %title('Noise adition and removal using median filter');

  img = medfilt2(N);


  %subplot(1,2,2);
   axes(handles.axes1)
 % imshow(img);
  title('Brain MRI Image');
  handles.ImgData = I;

  
%  handles.FileName = FileName;
guidata(hObject,handles);
  
%Selecting the portion of the tumor 
 
%level = graythresh(IMMM);
%img = im2bw(IMMM,level);


     
end


% --- Executes on button press in detectPBtn.
function detectPBtn_Callback(hObject, eventdata, handles)
% hObject    handle to detectPBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'ImgData')
    %if isfield(handles,'imgData')
    %I = handles.ImgData;
    

%gray = rgb2gray(I);


%level = graythresh(I);
%gray = gray>80;
%img = im2bw(I,.6);
%img = bwareaopen(img,80); 
%img2 = im2bw(I);

 I = handles.ImgData;

gray = rgb2gray(I);
% Otsu Binarization for segmentation
level = graythresh(I);
%gray = gray>80;
img = im2bw(I,.6);
img = bwareaopen(img,80); 
imgbw = im2bw(I);
% Try morphological operations
%gray = rgb2gray(I);
%tumor = imopen(gray,strel('line',15,0));

axes(handles.axes2)
%imshow(img);
title('Segmented Image');
%filter 
%segmentaion


%axes(handles.axes2)
%imshow(img);
%title('Pre-Processed Image');

%imshow(tumor);title('Segmented Image');

handles.ImgData2 = imgbw;
guidata(hObject,handles);

signal1 = imgbw(:,:);

%Feat = getmswpfeat(signal,winsize,wininc,J,'matlab');
%Features = getmswpfeat(signal,winsize,wininc,J,'matlab');

[cA1,cH1,cV1,cD1] = dwt2(signal1,'db4');
[cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
[cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');

DWT_feat = [cA3,cH3,cV3,cD3];
G = pca(DWT_feat);
whos DWT_feat
whos G
g = graycomatrix(G);
stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(G);
Standard_Deviation = std2(G);
Entropy = entropy(G);
RMS = mean2(rms(G));
%Skewness = skewness(img)
Variance = mean2(var(double(G)));
a = sum(double(G(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(G(:)));
Skewness = skewness(double(G(:)));
% Inverse Difference Movement
m = size(G,1);
n = size(G,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
feat = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];

load Trainset.mat
 xdata = meas;
 group = label;
 svmStruct1 = svmtrain(xdata,group,'kernel_function', 'linear');
 species = svmclassify(svmStruct1,feat,'showplot',false);
 
 if strcmpi(species,'BENIGN')
     
     %helpdlg(' Benign Tumor ');
     disp(' Benign Tumor ');
    
 else
      %helpdlg(' Malignant Tumor ');
      disp(' Malignant Tumor ');
     
 end
  %set(handles.detectEdt,'string',species);
  % Put the features in GUI



end


% --- Executes on button press in classifyPBtn.
function classifyPBtn_Callback(hObject, eventdata, handles)
% hObject    handle to classifyPBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'ImgData')
    % I = handles.ImgData;

gray = rgb2gray(I);
% Otsu Binarization for segmentation
level = graythresh(I);
%gray = gray>80;
img = im2bw(I,.6);
img = bwareaopen(img,80); 
img2 = im2bw(I);
% Try morphological operations
%gray = rgb2gray(I);
%tumor = imopen(gray,strel('line',15,0));

axes(handles.axes3)
imshow(img);title('Tumor Image');
%imshow(tumor);title('Segmented Image');

handles.ImgData2 = img2;
guidata(hObject,handles);

guidata(hObject,handles);

signal1 = img2(:,:);

%Feat = getmswpfeat(signal,winsize,wininc,J,'matlab');
%Features = getmswpfeat(signal,winsize,wininc,J,'matlab');

[cA1,cH1,cV1,cD1] = dwt2(signal1,'db4');
[cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
[cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');

DWT_feat = [cA3,cH3,cV3,cD3];
G = pca(DWT_feat);
whos DWT_feat
whos G
g = graycomatrix(G);
stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(G);
Standard_Deviation = std2(G);
Entropy = entropy(G);
RMS = mean2(rms(G));
%Skewness = skewness(img)
Variance = mean2(var(double(G)));
a = sum(double(G(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(G(:)));
Skewness = skewness(double(G(:)));
% Inverse Difference Movement
m = size(G,1);
n = size(G,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
feat = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];


load Trainset.mat
 xdata = meas;
 group = label;
 svmStruct1 = svmtrain(xdata,group,'kernel_function', 'linear');
 species = svmclassify(svmStruct1,feat,'showplot',false);
 
if strcmpi(species,'MALIGNANT')
                     load Trainset2.mat
                     xdata2 = meas;
                     group2 = label;
                     svmStruct12 = svmtrain(xdata2,group2,'kernel_function', 'linear');
                     species2 = svmclassify(svmStruct12,feat,'showplot',false);


                     if strcmpi(species2,'Leukemia')
                        helpdlg(' Leukemia Tumor ');
                        disp(' Leukemia Tumor ');

                        set(handles.classifyEdt,'string',species2);
     
                     else
                         load Trainset3.mat
                         xdata3 = meas;
                         group3 = label;
                         svmStruct13 = svmtrain(xdata3,group3,'kernel_function', 'linear');
                         species3 = svmclassify(svmStruct13,feat,'showplot',false);
            
                         

                                 if strcmpi(species3,'Multicentric Glioblastoma')
                                        helpdlg(' Multicentric Glioblastoma Tumor');
                                        disp(' Multicentric Glioblastoma Tumor');

                                        set(handles.classifyEdt,'string',species3);



                                 else
                                      load Trainset1.mat
                                      xdata1 = meas;
                                      group1 = label;
                                       svmStruct11 = svmtrain(xdata1,group1,'kernel_function', 'linear');
                                      species1 = svmclassify(svmStruct11,feat,'showplot',false);
                                      
                                         if strcmpi(species1,'Gliomas')
                                                 helpdlg(' Gliomas Tumor');
                                                disp(' Gliomas Tumor');
                                                set(handles.classifyEdt,'string',species1);
                                
                                         else
                                              load Trainset1.mat
                                              xdata1 = meas;
                                              group1 = label;
                                              svmStruct11 = svmtrain(xdata1,group1,'kernel_function', 'linear');
                                              species1 = svmclassify(svmStruct11,feat,'showplot',false);

                                               if strcmpi(species1,'Glioblastoma')
                                                     helpdlg(' Glioblastoma Tumor ');
                                                     disp(' Glioblastoma Tumor ');
                                                     set(handles.classifyEdt,'string',species1);


                                             

                                                 else
                                                     load Trainset3.mat
                                                     xdata3 = meas;
                                                     group3 = label;
                                                     svmStruct13 = svmtrain(xdata3,group3,'kernel_function', 'linear');
                                                     species3 = svmclassify(svmStruct13,feat,'showplot',false);

                                                            if strcmpi(species3,'Sarcoma')
                                                            helpdlg(' Sarcoma Tumor ');
                                                            disp(' Sarcoma Tumor ');
                                                            set(handles.classifyEdt,'string',species3);


                                                            else 
                                                                load Trainset2.mat
                                                                         xdata2 = meas;
                                                                         group2 = label;
                                                                         svmStruct12 = svmtrain(xdata2,group2,'kernel_function', 'linear');
                                                                         species2 = svmclassify(svmStruct12,feat,'showplot',false);



                                                                             if strcmpi(species2,'Acoustic Neuroma')
                                                                                helpdlg(' Acoustic Neuroma Tumor');
                                                                                 disp(' Acoustic Neuroma Tumor');
                                                                                 set(handles.classifyEdt,'string',species2);


                                                                            else
                                                                             helpdlg('Error');
                                                                             end
                                                            end
                                               end
                                         end
                                 end
                     end
 
                             
    else
        helpdlg(' Benign Tumor ');
        disp(' Benign Tumor ');
        set(handles.classifyEdt,'string',species);
     
 end


end







% --- Executes on selection change in featuresLst.
function featuresLst_Callback(hObject, eventdata, handles)
% hObject    handle to featuresLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns featuresLst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from featuresLst



% --- Executes during object creation, after setting all properties.
function featuresLst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featuresLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in kernelLst.
function kernelLst_Callback(hObject, eventdata, handles)
% hObject    handle to kernelLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kernelLst contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kernelLst


% --- Executes during object creation, after setting all properties.
function kernelLst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernelLst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function detectEdt_Callback(hObject, eventdata, handles)
% hObject    handle to detectEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detectEdt as text
%        str2double(get(hObject,'String')) returns contents of detectEdt as a double


% --- Executes during object creation, after setting all properties.
function detectEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detectEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function classifyEdt_Callback(hObject, eventdata, handles)
% hObject    handle to classifyEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of classifyEdt as text
%        str2double(get(hObject,'String')) returns contents of classifyEdt as a double


% --- Executes during object creation, after setting all properties.
function classifyEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classifyEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kernelEdt_Callback(hObject, eventdata, handles)
% hObject    handle to kernelEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kernelEdt as text
%        str2double(get(hObject,'String')) returns contents of kernelEdt as a double


% --- Executes during object creation, after setting all properties.
function kernelEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kernelEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function featuresEdt_Callback(hObject, eventdata, handles)
% hObject    handle to featuresEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of featuresEdt as text
%        str2double(get(hObject,'String')) returns contents of featuresEdt as a double


% --- Executes during object creation, after setting all properties.
function featuresEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featuresEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Estimationpop.
function Estimationpop_Callback(hObject, eventdata, handles)
% hObject    handle to Estimationpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Estimationpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Estimationpop
if isfield(handles,'ImgData')
    %if isfield(handles,'imgData')
   % I = handles.ImgData;

gray = rgb2gray(I);
% Otsu Binarization for segmentation
level = graythresh(I);
%gray = gray>80;
img = im2bw(I,.6);
img = bwareaopen(img,80); 
img2 = im2bw(I);
% Try morphological operations
%gray = rgb2gray(I);
%tumor = imopen(gray,strel('line',15,0));

axes(handles.axes2)

%imshow(tumor);title('Segmented Image');

handles.ImgData2 = img2;
guidata(hObject,handles);

signal1 = img2(:,:);

%Feat = getmswpfeat(signal,winsize,wininc,J,'matlab');
%Features = getmswpfeat(signal,winsize,wininc,J,'matlab');

[cA1,cH1,cV1,cD1] = dwt2(signal1,'db4');
[cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
[cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');

DWT_feat = [cA3,cH3,cV3,cD3];
G = pca(DWT_feat);
whos DWT_feat
whos G
g = graycomatrix(G);
stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(G);
Standard_Deviation = std2(G);
Entropy = entropy(G);
RMS = mean2(rms(G));
%Skewness = skewness(img)
Variance = mean2(var(double(G)));
a = sum(double(G(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(G(:)));
Skewness = skewness(double(G(:)));
% Inverse Difference Movement
m = size(G,1);
n = size(G,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);

%%

load Trainset.mat
%data   = [meas(:,1), meas(:,2)];
QAccuracy_Percent= zeros(200,1);
PAccuracy_Percent= zeros(200,1);
LAccuracy_Percent= zeros(200,1);
RAccuracy_Percent= zeros(200,1);
itr = 100;
hWaitBar = waitbar(0,'Loading....');
for i = 1:itr
data = meas;
groups = ismember(label,'BENIGN   ');
groups = ismember(label,'MALIGNANT');
[train,test] = crossvalind('HoldOut',groups);
cp = classperf(groups);
%Quadratic Kernel

svmStruct4 = svmtrain(data(train,:),groups(train),'showplot',false,'kernel_function','quadratic');
classes4 = svmclassify(svmStruct4,data(test,:),'showplot',false);
classperf(cp,classes4,test);
%Accuracy_Classification_Quad = cp.CorrectRate.*100;
QAccuracy_Percent(i) = cp.CorrectRate.*100;
%sprintf('Accuracy of Quadratic Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);

%Polynomial Kernel

svmStruct_Poly = svmtrain(data(train,:),groups(train),'Polyorder',2,'Kernel_Function','polynomial');
classes3 = svmclassify(svmStruct_Poly,data(test,:),'showplot',false);
classperf(cp,classes3,test);
PAccuracy_Percent(i) = cp.CorrectRate.*100;
%sprintf('Accuracy of Polynomial Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);

%Liner Kernel

svmStruct = svmtrain(data(train,:),groups(train),'showplot',false,'kernel_function','linear');
classes = svmclassify(svmStruct,data(test,:),'showplot',false);
classperf(cp,classes,test);
%Accuracy_Classification = cp.CorrectRate.*100;
LAccuracy_Percent(i) = cp.CorrectRate.*100;
%sprintf('Accuracy of Linear Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);

%RBF Kernel

svmStruct_RBF = svmtrain(data(train,:),groups(train),'boxconstraint',Inf,'showplot',false,'kernel_function','rbf');
classes2 = svmclassify(svmStruct_RBF,data(test,:),'showplot',false);
classperf(cp,classes2,test);
%Accuracy_Classification_RBF = cp.CorrectRate.*100;
RAccuracy_Percent(i) = cp.CorrectRate.*100;
%sprintf('Accuracy of RBF Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);

end
delete(hWaitBar);
QMax_Accuracy = max(QAccuracy_Percent);
PMax_Accuracy = max(PAccuracy_Percent);
LMax_Accuracy = max(LAccuracy_Percent);
RMax_Accuracy = max(RAccuracy_Percent);
%sprintf('Accuracy of RBF kernel is: %g%%',Max_Accuracy)
%set(handles.edit1,'string',Max_Accuracy);
guidata(hObject,handles);

    
val=get(handles.Estimationpop,'Value');


Features={'Contrast:',Contrast,'_____________________________','Correlation:',Correlation,'_____________________________','Energy:',Energy,'_____________________________','Homogeneity:',Homogeneity,'_____________________________','Mean:',Mean,'_____________________________','Standart Deviation:',Standard_Deviation,'_____________________________','Entropy:',Entropy,'_____________________________','RMS:',RMS,'_____________________________','Variance:',Variance,'_____________________________','Smoothness:',Smoothness,'_____________________________','Kurtosis:',Kurtosis,'_____________________________','Skewness:',Skewness,'_____________________________','IDM:',IDM};
Accuracy={'Quadratic Kernel:',QMax_Accuracy,'_____________________________','Polynomial Kernel:',PMax_Accuracy,'_____________________________','Liner Kernel:',LMax_Accuracy,'_____________________________','RBF Kernel:',RMax_Accuracy};

if(val==1)
    set(handles.listboxf,'String',Features);
end
if(val==2)
    set(handles.listboxk,'String',Accuracy);
end

end


% --- Executes during object creation, after setting all properties.
function Estimationpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Estimationpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxf.
function listboxf_Callback(hObject, eventdata, handles)
% hObject    handle to listboxf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxf


% --- Executes during object creation, after setting all properties.
function listboxf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxk.
function listboxk_Callback(hObject, eventdata, handles)
% hObject    handle to listboxk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxk contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxk


% --- Executes during object creation, after setting all properties.
function listboxk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savfBtn.
function savfBtn_Callback(hObject, eventdata, handles)
% hObject    handle to savfBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\


fID=fopen('savefeatures.txt','w');

Data=get(handles.listboxf,'String');

for ii=1:numel(Data)
   
    fprintf(fID,'%s\n',Data{ii});

end

f = msgbox('Features Saved ','Sucessfull');

fclose(fID);


% --- Executes on button press in bnwBtn.
function bnwBtn_Callback(hObject, eventdata, handles)
% hObject    handle to bnwBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


img2=getimage(handles.axes3);

level = graythresh(img2);
img = im2bw(img2,level);

axes(handles.axes3)
imshow(img);
title('Black and White');

%img3=getimage(handles.axes3);

%level1 = graythresh(img3);
%img = im2bw(img3,level1);

%title('Tumor Image');
%imshow(img);



% --- Executes on button press in undoBtn.
function undoBtn_Callback(hObject, eventdata, handles)
% hObject    handle to undoBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the image from axes2
img=getimage(handles.axes2);

axes(handles.axes3)
%level = graythresh(IMMM);
%img = im2bw(img3,level);

imshow(img);
title('Tumor Image');


% --- Executes on button press in saveiBtn.
function saveiBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveiBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%get the image from axes3
img=getimage(handles.axes3);
%save the image in the specified directory 
imwrite(img,'V:\savedimage.jpg')
f = msgbox('Image Saved ','Sucessfull');
