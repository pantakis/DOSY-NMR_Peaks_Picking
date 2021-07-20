function varargout = DOSY_Peaks_Picking(varargin)
% DOSY_PEAKS_PICKING MATLAB code for DOSY_Peaks_Picking.fig
%      DOSY_PEAKS_PICKING, by itself, creates a new DOSY_PEAKS_PICKING or raises the existing
%      singleton*.
%
%      H = DOSY_PEAKS_PICKING returns the handle to a new DOSY_PEAKS_PICKING or the handle to
%      the existing singleton*.
%
%      DOSY_PEAKS_PICKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOSY_PEAKS_PICKING.M with the given input arguments.
%
%      DOSY_PEAKS_PICKING('Property','Value',...) creates a new DOSY_PEAKS_PICKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DOSY_Peaks_Picking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DOSY_Peaks_Picking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DOSY_Peaks_Picking

% Last Modified by GUIDE v2.5 17-Aug-2020 18:09:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DOSY_Peaks_Picking_OpeningFcn, ...
                   'gui_OutputFcn',  @DOSY_Peaks_Picking_OutputFcn, ...
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


% --- Executes just before DOSY_Peaks_Picking is made visible.
function DOSY_Peaks_Picking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DOSY_Peaks_Picking (see VARARGIN)

% Choose default command line output for DOSY_Peaks_Picking
handles.output = hObject;
handles.PassExcel = 0;
% Update handles structure
guidata(hObject, handles);

% Text in all notes panels
str1 = "1. DOSY Peak Picking platfrom is READY! Please follow the numbered steps.";
str2 = "2. In case of an excel input based peak picking please ignore steps 2 and 3.";

handles.Important_notes_panel.String = str1 + newline + str2;




% UIWAIT makes DOSY_Peaks_Picking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DOSY_Peaks_Picking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in textfiles_input.
function textfiles_input_Callback(hObject, eventdata, handles)
% hObject    handle to textfiles_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NMRspectra = uigetdir;
try
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading.reading .txt files...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);   
    
    dinfo = dir(fullfile(NMRspectra,'*.txt'));
    for i = 1:length(dinfo)
        C = importdata(fullfile(NMRspectra,dinfo(i).name));
        TXTdata(i) = C;
        D = strrep(dinfo(i).name,'.txt','');
        D = strrep(D,'stats','');
        Spec(i,1) = {D};
    end
    
    TXTdata = rmfield(TXTdata, 'textdata');
    handles.TXTdata = TXTdata;
    handles.Spectra_Titles = Spec;

    figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
    close(figHandles);
    handles.Important_notes_panel.String = "'.txt' files are successfully loaded/read. You could proceed with loading an excel file or step 2.";
catch
    figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
    close(figHandles);
    handles.Important_notes_panel.String = "ERROR: There was a problem with loading/reading '.txt' files."; 
end
handles.folder_spectra = NMRspectra;
guidata(hObject, handles);



% --- Executes on button press in excel_input.
function excel_input_Callback(hObject, eventdata, handles)
% hObject    handle to excel_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    
    [excel pathexcel] = uigetfile('*.xlsx');
    
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the excel file...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);   
    
    handles.Excelfile_path = [pathexcel excel];
    [num,txt,~] = xlsread(handles.Excelfile_path);
    Msize = size(num);
    Msize = Msize(1);
    X = Msize + 1;
    txt = txt(2:X,1);
    handles.Excelfile_numbers = num;
    handles.Excelfile_metabolites_names = txt;
    handles.PassExcel = 1;
    figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
    close(figHandles);
    handles.Important_notes_panel.String = "Excel file for multiple regions peak picking is successfully loaded. You could proceed to STEP 4";
catch
    figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
    close(figHandles);
    handles.Important_notes_panel.String = "ERROR: There was a problem with loading the Excel file for multiple regions peak picking.";
end

guidata(hObject, handles);


function Boundaries_Callback(hObject, eventdata, handles)
% hObject    handle to Boundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Boundaries as text
%        str2double(get(hObject,'String')) returns contents of Boundaries as a double
global LIMITS
Bounds = get(handles.Boundaries, 'String');
Bounds1 = strrep(Bounds,'-',' ');
LIMITS = str2num(Bounds1);
handles.metab_name = ['region-' Bounds];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Boundaries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double
global THRESHOLD
Thr = get(handles.threshold, 'String');
THRESHOLD = str2num(Thr);



% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Peak_peaking.
function Peak_peaking_Callback(hObject, eventdata, handles)
% hObject    handle to Peak_peaking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LIMITS THRESHOLD 
C = handles.TXTdata;
if handles.PassExcel == 1
    try  
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for finalising/exporting peak-peaking results...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);   
        
        for p = 1:length(C)
            for h = 1:length(handles.Excelfile_metabolites_names)
                [i,~] = find(C(p).data(:,1) > handles.Excelfile_numbers(h,1) & C(p).data(:,1) < handles.Excelfile_numbers(h,2));
                TEMP_DATA = C(p).data(i,:);        
                [o,~] = find(TEMP_DATA(:,end) < handles.Excelfile_numbers(h,3));
                PEAK_LIST = TEMP_DATA(o,1);
                EXP_AMPLITUDE = TEMP_DATA(o,2);
                FIT_AMPLITUDE = TEMP_DATA(o,3);
                Diff_COEF = TEMP_DATA(o,5);                
                Peak_NUM = [1:1:length(o)]';
                TT = table(Peak_NUM,PEAK_LIST,EXP_AMPLITUDE,FIT_AMPLITUDE,Diff_COEF);
                outputfile = [handles.Spectra_Titles{p} '_' handles.Excelfile_metabolites_names{h,1} '_myData.csv'];
                writetable(TT,fullfile(handles.folder_spectra,outputfile));          
            end
        end
        LL1 = [1:2:(2*length(C))]';
        LL2 = [2:2:(2*length(C))]';
        for  h = 1:length(handles.Excelfile_metabolites_names)
            for p = 1:length(C)
                [i,~] = find(C(p).data(:,1) > handles.Excelfile_numbers(h,1) & C(p).data(:,1) < handles.Excelfile_numbers(h,2));
                TEMP_DATA = C(p).data(i,:);        
                [o,~] = find(TEMP_DATA(:,end) < handles.Excelfile_numbers(h,3));
                PEAK_LIST = TEMP_DATA(o,1);
                EXP_AMPLITUDE = TEMP_DATA(o,2);
                FIT_AMPLITUDE = TEMP_DATA(o,3);
                Diff_COEF = TEMP_DATA(o,5);                
                Peak_NUM = [1:1:length(o)]';
                TEMP_ARRAY(1:length(PEAK_LIST),LL1(p)) = PEAK_LIST;
                TEMP_ARRAY(1:length(Diff_COEF),LL2(p)) = Diff_COEF;
            end
            for g = 1:length(C)
                spec_temp1 = ['spec_' handles.Spectra_Titles{g} 'PPM'];
                spec_temp2 = ['spec_' handles.Spectra_Titles{g} 'DiffCoef'];
                FF.(spec_temp1)(:,1) = TEMP_ARRAY(:,LL1(g));
                FF.(spec_temp2)(:,1) = TEMP_ARRAY(:,LL2(g));
            end            
            for j = 1:size(TEMP_ARRAY,1)
                RowVars(j,1) = {['Peak-' num2str(j)]};
            end
            T = struct2table(FF);
            T.Properties.RowNames = RowVars;            
            T.Properties.DimensionNames{1} = 'Peaks / Spectra -->';
            outputfile1 = [handles.Excelfile_metabolites_names{h,1} '_Cummulative_myData.csv'];
            writetable(T,fullfile(handles.folder_spectra,outputfile1),'WriteVariableNames',true,'WriteRowNames',true);   
            clearvars FF T TEMP_ARRAY RowVars
        end
        
        figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
        close(figHandles);
        handles.Important_notes_panel.String = ['Peak picking is successfully completed. Results are exported to: ' handles.folder_spectra];
        
    catch
        
        figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
        close(figHandles);
        handles.Important_notes_panel.String = 'Something went wrong! Peak picking cannot be completed. Please check the input excel file or the .txt input files';
        
    end
else
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for finalising/exporting peak-peaking results...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);   
        LL1 = [1:2:(2*length(C))]';
        LL2 = [2:2:(2*length(C))]';
        for p = 1:length(C)
            [i,~] = find(C(p).data(:,1) > LIMITS(1,1) & C(p).data(:,1) < LIMITS(1,2));
            TEMP_DATA = C(p).data(i,:);        
            [o,~] = find(TEMP_DATA(:,end) < THRESHOLD);
            PEAK_LIST = TEMP_DATA(o,1);
            EXP_AMPLITUDE = TEMP_DATA(o,2);
            FIT_AMPLITUDE = TEMP_DATA(o,3);
            Diff_COEF = TEMP_DATA(o,5); %/10;                
            Peak_NUM = [1:1:length(o)]';            
            TT = table(Peak_NUM,PEAK_LIST,EXP_AMPLITUDE,FIT_AMPLITUDE,Diff_COEF);
            outputfile = [handles.Spectra_Titles{p} '_' handles.metab_name '_myData.csv'];
            writetable(TT,fullfile(handles.folder_spectra,outputfile));
            TEMP_ARRAY(1:length(PEAK_LIST),LL1(p)) = PEAK_LIST;
            TEMP_ARRAY(1:length(Diff_COEF),LL2(p)) = Diff_COEF;
        end
        for g = 1:length(C)
            spec_temp1 = ['spec_' handles.Spectra_Titles{g} 'PPM'];
            spec_temp2 = ['spec_' handles.Spectra_Titles{g} 'DiffCoef'];
            FF.(spec_temp1)(:,1) = TEMP_ARRAY(:,LL1(g));
            FF.(spec_temp2)(:,1) = TEMP_ARRAY(:,LL2(g));
        end
        for j = 1:size(TEMP_ARRAY,1)
            RowVars(j,1) = {['Peak-' num2str(j)]};
        end
        T = struct2table(FF);
        T.Properties.RowNames = RowVars;
        T.Properties.DimensionNames{1} = 'Peaks / Spectra -->';
        outputfile1 = [handles.metab_name '_Cummulative_myData.csv'];
        writetable(T,fullfile(handles.folder_spectra,outputfile1),'WriteVariableNames',true,'WriteRowNames',true);
        
        figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
        close(figHandles);
        handles.Important_notes_panel.String = ['Peak picking is successfully completed. Results are exported to: ' handles.folder_spectra];
        
    catch
        
        figHandles = findobj('type', 'figure', '-not', 'name', 'DOSY_Peaks_Picking');
        close(figHandles);
        handles.Important_notes_panel.String = 'Something went wrong! Peak picking cannot be completed. Please check the .txt input files and/or values of Steps 2-3.';

    end
end


% --- Executes on button press in Refresh.
function Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global LIMITS THRESHOLD

handles.Boundaries.String = 'Set ppm boundaries (e.g. 2-3)';
handles.threshold.String = 'Set threshold (recommended: <2)';            
handles.Important_notes_panel.String = 'Values from Steps 2-3 have been reset!!!';                       
LIMITS = [];
THRESHOLD = [];
guidata(hObject, handles);
