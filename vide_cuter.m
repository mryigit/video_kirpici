function varargout = vide_cuter(varargin)
% VIDE_CUTER M-file for vide_cuter.fig
%      VIDE_CUTER, by itself, creates a new VIDE_CUTER or raises the existingg
%      singleton*.
%
%      H = VIDE_CUTER returns the handle to a new VIDE_CUTER or the handle to
%      the existing singleton*.
%
%      VIDE_CUTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDE_CUTER.M with the given input arguments.
%
%      VIDE_CUTER('Property','Value',...) creates a new VIDE_CUTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vide_cuter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vide_cuter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vide_cuter

% Last Modified by GUIDE v2.5 19-Dec-2012 07:27:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vide_cuter_OpeningFcn, ...
                   'gui_OutputFcn',  @vide_cuter_OutputFcn, ...
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


% --- Executes just before vide_cuter is made visible.
function vide_cuter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vide_cuter (see VARARGIN)

% Choose default command line output for vide_cuter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vide_cuter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vide_cuter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in sec.
function sec_Callback(hObject, eventdata, handles)
    set(handles.yazi,'String','videoda kesilecek s�n�rlar� belirlemek i�in mause ile s�n�rlar� se�iniz t�pk� paint deki resim k�rpma gibi');
    [filename, pathname] = uigetfile('*', 'Select a MATLAB code file');
    handles.fil = filename;
    handles.isim = [pathname, filename];
    handles.path = pathname;
    
    if isequal(filename,0)
        disp('User selected Cancel');
    
    else
        video = mmreader(fullfile(pathname, filename));
        handles.gecici = read(video,[1,inf]);
        axes(handles.axes1);
        imshow(handles.gecici(:,:,:,1));
        
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);         % and dimensions
        x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
        y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
        hold on
        axis manual
        plot(x,y)

        xcor = min(x);
        ycor = min(y);
        xmesafe = max(x)-xcor;
        ymesafe = max(y)-ycor;
        handles.boyut = [xcor, ycor, xmesafe, ymesafe];
        
    end
guidata(hObject, handles);


% --- Executes on button press in calis.
function calis_Callback(hObject, eventdata, handles)
    yeniad = [handles.isim(1:(length(handles.isim)-4)),'_yeni.avi'];
    aviobj = avifile(yeniad,'fps',25); 
    [R C T Adet] = size(handles.gecici);
    for i=1:Adet
        aviobj = addframe(aviobj, im2frame( imcrop( handles.gecici(:,:,:,i), handles.boyut ) ));
    end
    aviobj=close(aviobj);
    yazdir{1} = 'yeni video olu�turuldu';
    yazdir{2} = [handles.path,' adresine ',handles.fil(1:(length(handles.fil)-4)),'_yeni',' ad�yla kaydedildi.'];
    set(handles.yazi,'String',yazdir);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function yazi_CreateFcn(hObject, eventdata, handles)
