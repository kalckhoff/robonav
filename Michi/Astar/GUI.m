function varargout = GUI(varargin)
% GUI M-file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 06-Oct-2007 22:51:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Create Workspace
% hold on
axis([0 15 0 8]);
handles.polygon_index=0;
handles.polygon_x(1,:) = -ones(1,31);
handles.polygon_y(1,:) = -ones(1,31);
handles.spline_index=0;
handles.spline_x(1,:) = -ones(1,31);
handles.spline_y(1,:) = -ones(1,31);
handles.robot_x(1,:) = -ones(1,31);
handles.robot_y(1,:) = -ones(1,31);
handles.robot_x(1,:) = -ones(1,31);
handles.robot_y(1,:) = -ones(1,31);
handles.Qpolygon_x(1,:,1) = -ones(1,62);
handles.Qpolygon_y(1,:,1) = -ones(1,62);
handles.makemovie = 0;
handles.make3Dgraph = 0;
handles.boundary = 0;
handles.angle = 0;


handles.current_method = 4;
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'on');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'on');
set(handles.popupmenu3, 'Enable', 'on');
set(handles.popupmenu2, 'Value', 1);
handles.current_obstacle = 1;
set(handles.popupmenu2, 'Enable', 'off');
   
   

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


switch handles.current_obstacle;
case 1

    % Draw polygon
    handles.polygon_index = handles.polygon_index + 1;

    i = 1;
    but = 1;
    while but == 1
        %waitforbuttonpress;
        %point = get(handles.Workspace,'CurrentPoint');
        [px, py, but] = ginput(1);
        if but == 1 && i < 31
            x(i)=px; %point(1,1);
            y(i)=py; %point(1,2);
            if i > 1
                line([x(i-1), x(i)], [y(i-1), y(i)], 'Color', 'blue');
            end
            i = i+1;
        end
    end
    if i > 1
        line([x(i-2), x(1)], [y(i-2), y(1)]);
    end

    %Obstacles always anticlockwise
    R_direction = cross([x(2)-x(1), y(2)-y(1), 0],[x(3)-x(2), y(3)-y(2),0]);
    if R_direction(3) < 0;
        x=fliplr(x);
        y=fliplr(y);
    end
        
    handles.polygon_x(handles.polygon_index,1:length(x)) = x;
    handles.polygon_y(handles.polygon_index,1:length(y)) = y;
    handles.polygon_num(handles.polygon_index) = i-1;
    patch(x,y,'blu');

case 2
    
    % Draw spline
    handles.spline_index = handles.spline_index + 1;

    i = 1;
    but = 1;
    while but == 1
        [px, py, but] = ginput(1);
        if but == 1 && i < 31
            x(i)=px;
            y(i)=py;
            i = i+1;
        end
    end
    x(length(x)+1)=x(1);
    y(length(y)+1)=y(1);
    
    handles.spline_x(handles.spline_index,1:length(x)) = x;
    handles.spline_y(handles.spline_index,1:length(y)) = y;
    handles.spline_num(handles.spline_index) = i-1;
    t=linspace(0,1,length(x));
    tt=linspace(0,1,200);
    xx=spline(t,x,tt);
    yy=spline(t,y,tt);
    patch(xx,yy,'blu');

end

% Save the handles structure.
guidata(hObject,handles)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject, 'Value');
% Set current data to the selected data set.
switch str{val};
case 'Straight Line'
   handles.current_method = 1;
   set(handles.pushbutton3, 'Enable', 'on');
   set(handles.pushbutton4, 'Enable', 'off');
   set(handles.pushbutton5, 'Enable', 'off');
   set(handles.pushbutton6, 'Enable', 'off');
   set(handles.popupmenu3, 'Enable', 'off');
   set(handles.popupmenu2, 'Enable', 'on');
case 'Tangent Bug'
   handles.current_method = 2;
   set(handles.pushbutton3, 'Enable', 'on');
   set(handles.pushbutton4, 'Enable', 'off');
   set(handles.pushbutton5, 'Enable', 'off');
   set(handles.pushbutton6, 'Enable', 'off');
   set(handles.popupmenu3, 'Enable', 'off');
   set(handles.popupmenu2, 'Enable', 'on');
case 'Potential Function'
   handles.current_method = 3;
   set(handles.pushbutton3, 'Enable', 'off');
   set(handles.pushbutton4, 'Enable', 'on');
   set(handles.pushbutton5, 'Enable', 'on');
   set(handles.pushbutton6, 'Enable', 'on');
   set(handles.popupmenu3, 'Enable', 'on');
   set(handles.popupmenu2, 'Value', 1);
   handles.current_obstacle = 1;
   set(handles.popupmenu2, 'Enable', 'off');
case 'A*'
   handles.current_method = 4;
   set(handles.pushbutton3, 'Enable', 'off');
   set(handles.pushbutton4, 'Enable', 'on');
   set(handles.pushbutton5, 'Enable', 'off');
   set(handles.pushbutton6, 'Enable', 'on');
   set(handles.popupmenu3, 'Enable', 'on');
   set(handles.popupmenu2, 'Value', 1);
   handles.current_obstacle = 1;
   set(handles.popupmenu2, 'Enable', 'off');
end

% Save the handles structure.
guidata(hObject,handles)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.current_method;
case 1
   
    line(handles.se_x, handles.se_y,'Color','r','LineWidth',2);

case 2
   
   hold on;
   path = tangent(handles.W, [handles.se_x(1), handles.se_y(1)], [handles.se_x(2), handles.se_y(2)]);
   
   if handles.makemovie == 1;
        mov = avifile('avifile.avi', 'compression', 'Cinepak', 'fps', 30); 
        for i=1:length(path(:,1))
            plot(path(1:i,1), path(1:i,2), 'Color','r', 'LineWidth', 2);
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        mov = close(mov);
   end
   
   plot(path(:,1), path(:,2),'Color','r','LineWidth',2);

case 3
    
   hold on; 
   handles_axis = gcf;
   path = potential(handles.W, [handles.se_x(1), handles.se_y(1)], [handles.se_x(2), handles.se_y(2)], handles.make3Dgraph);
   figure(handles_axis);
   hold on;
   plot(path(:,1), path(:,2),'Color','r','LineWidth',2);   
   
   if handles.makemovie == 1;
        mov = avifile('avifile21.avi', 'compression', 'Cinepak', 'fps', 30); 
        
        %clear axis
        cla;
        hold on;
            
        
        %draw obstacles
        for i=1:handles.polygon_index-4
            patch(handles.polygon_x(i,1:handles.polygon_num(i)),handles.polygon_y(i,1:handles.polygon_num(i)),'blu');
        end
        %draw robot
        patch(handles.robot_x(1:handles.robot_num),handles.robot_y(1:handles.robot_num),'red');
        rectangle('Position',[[handles.se_x(1),handles.se_y(1)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
        for i=1:90
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        
        
        %draw Q-space
        for k = 1:handles.polygon_index
            length_Q = handles.polygon_num(k)+handles.robot_num;
            if k < handles.polygon_index-3
                patch(handles.Qpolygon_x(k,1:length_Q,1),handles.Qpolygon_y(k,1:length_Q,1),'green');
            else
                patch(handles.Qpolygon_x(k,1:length_Q,1),handles.Qpolygon_y(k,1:length_Q,1),'green','EdgeColor', 'green');
            end
        end
        %draw obstacles
        for i=1:handles.polygon_index-4
            patch(handles.polygon_x(i,1:handles.polygon_num(i)),handles.polygon_y(i,1:handles.polygon_num(i)),'blu');
        end
        %draw robot
        patch(handles.robot_x(1:handles.robot_num),handles.robot_y(1:handles.robot_num),'red');
        rectangle('Position',[[handles.se_x(1),handles.se_y(1)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
        rectangle('Position',[[handles.se_x(2),handles.se_y(2)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
        
        for i=1:60
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        
        robot=0;
        for i=1:length(path(:,1))
            plot(path(1:i,1), path(1:i,2), 'Color','r', 'LineWidth', 2);
            if robot == 10;
                patch(handles.robot_x(1:handles.robot_num)+(path(i,1)-path(1,1)),handles.robot_y(1:handles.robot_num)+(path(i,2)-path(1,2)),'red', 'FaceColor', 'none', 'EdgeColor', 'red');
                robot=0;
            end
            if i == length(path(:,1))
                patch(handles.robot_x(1:handles.robot_num)+(path(i,1)-path(1,1)),handles.robot_y(1:handles.robot_num)+(path(i,2)-path(1,2)),'red', 'FaceColor', 'none', 'EdgeColor', 'red');
            end
            robot=robot+1;            
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        
        for i=1:45
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        
        mov = close(mov);
   end 

case 4
    
    resize_factor=8;
    
    if handles.makemovie == 1;
        mov = avifile('avifile14.avi', 'compression', 'Cinepak', 'fps', 15); 
    end

    % create 3D Q space

    % draw boundary in W space
    if handles.boundary == 0
        handles.polygon_x(handles.polygon_index+1,1:4)=[0, 0, -1, -1];
        handles.polygon_y(handles.polygon_index+1,1:4)=[0, 8, 8, 0];
        handles.polygon_num(handles.polygon_index+1)=4;
        handles.polygon_x(handles.polygon_index+2,1:4)=[0, 0, 15, 15];
        handles.polygon_y(handles.polygon_index+2,1:4)=[0, -1, -1, 0];
        handles.polygon_num(handles.polygon_index+2)=4;
        handles.polygon_x(handles.polygon_index+3,1:4)=[15, 16, 16, 15];
        handles.polygon_y(handles.polygon_index+3,1:4)=[0, 0, 8, 8];
        handles.polygon_num(handles.polygon_index+3)=4;
        handles.polygon_x(handles.polygon_index+4,1:4)=[0, 15, 15, 0];
        handles.polygon_y(handles.polygon_index+4,1:4)=[8, 8, 9, 9];
        handles.polygon_num(handles.polygon_index+4)=4;
        handles.polygon_index=handles.polygon_index+4;
        handles.boundary = 1;
    end

    % prepare robot in W space
    R_ref_x=handles.se_x(1);
    R_ref_y=handles.se_y(1);

    robot_x=handles.robot_x(1:handles.robot_num);
    robot_y=handles.robot_y(1:handles.robot_num);
    R_ref_i=handles.robot_ref_i;

    if R_ref_i > 1 && R_ref_i < handles.robot_num
        R_vertex_x=robot_x(R_ref_i-1:R_ref_i+1);
        R_vertex_y=robot_y(R_ref_i-1:R_ref_i+1);
    elseif R_ref_i == 1
        R_vertex_x=[robot_x(handles.robot_num), robot_x(1:2)];
        R_vertex_y=[robot_y(handles.robot_num), robot_y(1:2)];
    elseif R_ref_i == handles.robot_num
        R_vertex_x=[robot_x(handles.robot_num-1:handles.robot_num), robot_x(1)];
        R_vertex_y=[robot_y(handles.robot_num-1:handles.robot_num), robot_y(1)];
    end

    %draw obstacels in W-space for different angle -> qspace
    for li=1:36
        theta=pi/180*(li-1)*10; %this times up = 360  15 -> 24
        R=[cos(theta), -sin(theta); sin(theta), cos(theta)];

        R_data=R*[robot_x-robot_x(R_ref_i); robot_y-robot_y(R_ref_i)];
        R_x_r=R_data(1,:)+robot_x(R_ref_i);
        R_y_r=R_data(2,:)+robot_y(R_ref_i);

        V_data=R*[R_vertex_x-robot_x(R_ref_i); R_vertex_y-robot_y(R_ref_i)];
        R_v_x_r=V_data(1,:)+robot_x(R_ref_i);
        R_v_y_r=V_data(2,:)+robot_y(R_ref_i);

        %robot normal vectors
        robot_vec=zeros(handles.robot_num,1);
        for i=1:handles.robot_num
            if i < handles.robot_num
               robot_vec(i)=atan2(R_y_r(1,i+1)-R_y_r(1,i), R_x_r(1,i+1)-R_x_r(1,i));
            else
               robot_vec(i)=atan2(R_y_r(1,1)-R_y_r(1,i), R_x_r(1,1)-R_x_r(1,i)); 
            end    
        end
        robot_norm = c_norm(robot_vec, 1);

        %clear axis
        cla;
        hold on;
        
        for k = 1:handles.polygon_index

            %k th obstacle normal vectors
            obstacle_vec = zeros(handles.polygon_num(k),1);
            for i=1:handles.polygon_num(k)
                if i < handles.polygon_num(k)
                    obstacle_vec(i)=atan2(handles.polygon_y(k,i+1)-handles.polygon_y(k,i),handles.polygon_x(k,i+1)-handles.polygon_x(k,i));
                else
                    obstacle_vec(i)=atan2(handles.polygon_y(k,1)-handles.polygon_y(k,i),handles.polygon_x(k,1)-handles.polygon_x(k,i)); 
                end    
            end
            obstacle_norm = c_norm(obstacle_vec, -1);

            % find correct common vertex
            for vi = 1:handles.polygon_num(k)
                if vi > 1 && vi < handles.polygon_num(k)
                    O_v_x=handles.polygon_x(k, vi-1:vi+1);
                    O_v_y=handles.polygon_y(k, vi-1:vi+1);
                elseif vi == 1
                    O_v_x=[handles.polygon_x(k, handles.polygon_num(k)), handles.polygon_x(k, 1:2)];
                    O_v_y=[handles.polygon_y(k, handles.polygon_num(k)), handles.polygon_y(k, 1:2)];
                elseif vi == handles.polygon_num(k)
                    O_v_x=[handles.polygon_x(k, handles.polygon_num(k)-1:handles.polygon_num(k)), handles.polygon_x(k, 1)];
                    O_v_y=[handles.polygon_y(k, handles.polygon_num(k)-1:handles.polygon_num(k)), handles.polygon_y(k, 1)];
                end
                inside = vertex_check(R_v_x_r, R_v_y_r, O_v_x, O_v_y);
                if inside == 0;
                    O_ref_i = vi;
                    break;
                end
            end


            %build Q-obstacle
            length_Q = handles.polygon_num(k)+handles.robot_num;
            [handles.Qpolygon_x(k,1:length_Q,li), handles.Qpolygon_y(k,1:length_Q,li), handles.Qpolygon_num(k)] = q_obstacle(R_x_r, R_y_r, handles.robot_num, robot_norm, handles.polygon_x(k,1:handles.polygon_num(k)), handles.polygon_y(k,1:handles.polygon_num(k)), handles.polygon_num(k), obstacle_norm, R_ref_i, O_ref_i);

            if k < handles.polygon_index-3
                patch(handles.Qpolygon_x(k,1:length_Q,li),handles.Qpolygon_y(k,1:length_Q,li),'green');
            else
                patch(handles.Qpolygon_x(k,1:length_Q,li),handles.Qpolygon_y(k,1:length_Q,li),'green','EdgeColor', 'none');
            end

            clear obstacle_vec obstacle_norm length_Q O_ref_i;

        end
        
        W_frame = getframe;
        [W_img, Map] = frame2im(W_frame);
        Q(:,:,li) = resize(W_img(:,:,1), resize_factor);
        %figure(2);
        %image(W_img);
        
        for i=1:handles.polygon_index-4
            patch(handles.polygon_x(i,1:handles.polygon_num(i)),handles.polygon_y(i,1:handles.polygon_num(i)),'blu');
        end       
        patch(R_x_r(1:handles.robot_num),R_y_r(1:handles.robot_num),'red');
        rectangle('Position',[[handles.se_x(1),handles.se_y(1)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
        rectangle('Position',[[handles.se_x(2),handles.se_y(2)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
               
        if handles.makemovie == 1;
            for mi=1:3
                W_frame = getframe;
                mov = addframe(mov, W_frame);
            end
        end
        
    end

    %clear axis
    cla;
    hold on;            
        
    %draw obstacles
    for i=1:handles.polygon_index-4
        patch(handles.polygon_x(i,1:handles.polygon_num(i)),handles.polygon_y(i,1:handles.polygon_num(i)),'blu');
    end
    %draw robot
    patch(handles.robot_x(1:handles.robot_num),handles.robot_y(1:handles.robot_num),'red');
    rectangle('Position',[[handles.se_x(1),handles.se_y(1)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
    rectangle('Position',[[handles.se_x(2),handles.se_y(2)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')
    
    if handles.makemovie == 1;
        for mi=1:5
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
    end
      
    handles.Q=Q;

    x_max=15; 
    y_max=8;
    i_max=401;
    j_max=753;
    step=1/50;

    j_s=round(handles.se_x(1)/step/resize_factor)+1;
    i_s=round((y_max-handles.se_y(1))/step/resize_factor)+1;

    j_g=round(handles.se_x(2)/step/resize_factor)+1;
    i_g=round((y_max-handles.se_y(2))/step/resize_factor)+1;

    theta_g=round(handles.angle/10)+1;                                 % ANGLE SAMPLING !!!!!!!
    [path, error] = astar(Q, [i_s, j_s, 1], [i_g, j_g, theta_g]);

    path_x=flipud((path(:,2)-1)*step*resize_factor);
    path_y=flipud(y_max-(path(:,1)-1)*step*resize_factor);
    path_theta=flipud((path(:,3)-1)*10);                           % ANGLE SAMPLING !!!!!!!
    path_x=[handles.se_x(1), path_x', handles.se_x(2)];
    path_y=[handles.se_y(1), path_y', handles.se_y(2)];
    path_theta=pi/180*[0, path_theta', handles.angle];


    hold on
    p_robot=1;
    for i=1:length(path_x)
        
        if error == 0
            plot(path_x(1:i), path_y(1:i), 'Color','r', 'LineWidth', 2);
        end
        
        theta=path_theta(i);
        R=[cos(theta), -sin(theta); sin(theta), cos(theta)];
        R_data=R*[robot_x-robot_x(R_ref_i); robot_y-robot_y(R_ref_i)];

        if p_robot==4
            patch(R_data(1,:)+path_x(i), R_data(2,:)+path_y(i),'red', 'FaceColor', 'none', 'EdgeColor', 'red');
            if handles.makemovie == 1;
                for mi=1:8
                    W_frame = getframe;
                    mov = addframe(mov, W_frame);
                end
            end
            p_robot=1;
        end
        p_robot=p_robot+1;

    end


    if handles.makemovie == 1;
        patch(R_data(1,:)+handles.se_x(2), R_data(2,:)+handles.se_y(2),'red');
        for mi=1:60
            W_frame = getframe;
            mov = addframe(mov, W_frame);
        end
        mov = close(mov);
    end

    if handles.make3Dgraph == 1
        figure(2);
        length_Q = handles.polygon_num(1)+handles.robot_num;
        for li=1:180
            patch(handles.Qpolygon_x(1,1:length_Q,li), handles.Qpolygon_y(1,1:length_Q,li), li*ones(1,length_Q),('green'));
        end
    end

end

% Save the handles structure.
guidata(hObject,handles)
   


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

W_frame = getframe;
[W_img, Map] = frame2im(W_frame);
handles.W=W_img(:,:,1);

%waitforbuttonpress;
%point = get(handles.Workspace,'CurrentPoint');
point = ginput(1);
handles.se_x(1)=point(1,1);
handles.se_y(1)=point(1,2);
rectangle('Position',[point-[.01, .01], .02, .02],'Curvature',[1,1],'FaceColor','r')

%waitforbuttonpress;
%point = get(handles.Workspace,'CurrentPoint');
point = ginput(1);
handles.se_x(2)=point(1,1);
handles.se_y(2)=point(1,2);
rectangle('Position',[point-[.01, .01], .02, .02],'Curvature',[1,1],'FaceColor','r')

% Save the handles structure.
guidata(hObject,handles)



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Polygon'
   handles.current_obstacle = 1;
case 'Spline'
   handles.current_obstacle = 2;
end

% Save the handles structure.
guidata(hObject,handles)


% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --------------------------------------------------------------------
function Drawing_Callback(hObject, eventdata, handles)
% hObject    handle to Drawing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Draw robot

i = 1;
but = 1;
while but == 1
    [px, py, but] = ginput(1);
    if but == 1 && i < 31
        x(i)=px;
        y(i)=py;
        if i > 1
            line([x(i-1), x(i)], [y(i-1), y(i)], 'Color', 'red');
        end
        i = i+1;
    end
end
if i > 1
    line([x(i-2), x(1)], [y(i-2), y(1)]);
end

%Roboter always clockwise
R_direction = cross([x(2)-x(1), y(2)-y(1), 0],[x(3)-x(2), y(3)-y(2),0]);
if R_direction(3) > 0;
    x=fliplr(x);
    y=fliplr(y);
end

handles.robot_x(1,1:length(x)) = x;
handles.robot_y(1,1:length(y)) = y;
handles.robot_num = i-1;
patch(x,y,'red');

ref=find(x == max(x));
y_min=y(ref(1));
R_ref_i=ref(1);
for i=2:length(ref)
    if y(ref(i)) < y_min
        y_min=y(ref(i));
        R_ref_i=ref(i);
    end
end  

handles.robot_ref_i=R_ref_i;
handles.se_x(1) = max(x);
handles.se_y(1) = y_min;
rectangle('Position',[[max(x),y_min]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')


% Save the handles structure.
guidata(hObject,handles)



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%create Q-space

%robot normal vectors
robot_vec=zeros(handles.robot_num,1);
for i=1:handles.robot_num
    if i < handles.robot_num
       robot_vec(i)=atan2(handles.robot_y(1,i+1)-handles.robot_y(1,i),handles.robot_x(1,i+1)-handles.robot_x(1,i));
    else
       robot_vec(i)=atan2(handles.robot_y(1,1)-handles.robot_y(1,i),handles.robot_x(1,1)-handles.robot_x(1,i)); 
    end    
end

robot_norm = c_norm(robot_vec, 1);

% draw boundary
if handles.boundary == 0
    handles.polygon_x(handles.polygon_index+1,1:4)=[0, 0, -1, -1];
    handles.polygon_y(handles.polygon_index+1,1:4)=[0, 8, 8, 0];
    handles.polygon_num(handles.polygon_index+1)=4;
    handles.polygon_x(handles.polygon_index+2,1:4)=[0, 15, 15, 0];
    handles.polygon_y(handles.polygon_index+2,1:4)=[0, 0, -1, -1];
    handles.polygon_num(handles.polygon_index+2)=4;
    handles.polygon_x(handles.polygon_index+3,1:4)=[15, 15, 16, 16];
    handles.polygon_y(handles.polygon_index+3,1:4)=[0, 8, 8, 0];
    handles.polygon_num(handles.polygon_index+3)=4;
    handles.polygon_x(handles.polygon_index+4,1:4)=[0, 15, 15, 0];
    handles.polygon_y(handles.polygon_index+4,1:4)=[8, 8, 9, 9];
    handles.polygon_num(handles.polygon_index+4)=4;
    handles.polygon_index=handles.polygon_index+4;
    handles.boundary = 1;
end
   

%clear axis
cla;

for k = 1:handles.polygon_index
    %k th obstacle normal vectors
    obstacle_vec = zeros(handles.polygon_num(k),1);
    for i=1:handles.polygon_num(k)
        if i < handles.polygon_num(k)
            obstacle_vec(i)=atan2(handles.polygon_y(k,i+1)-handles.polygon_y(k,i),handles.polygon_x(k,i+1)-handles.polygon_x(k,i));
        else
            obstacle_vec(i)=atan2(handles.polygon_y(k,1)-handles.polygon_y(k,i),handles.polygon_x(k,1)-handles.polygon_x(k,i)); 
        end    
    end
    
    obstacle_norm = c_norm(obstacle_vec, -1);
    
    length_Q = handles.polygon_num(k)+handles.robot_num;
    [handles.Qpolygon_x(k,1:length_Q,1), handles.Qpolygon_y(k,1:length_Q,1), handles.Qpolygon_num(k)] = q_obstacle(handles.robot_x, handles.robot_y, handles.robot_num, robot_norm, handles.polygon_x(k,1:handles.polygon_num(k)), handles.polygon_y(k,1:handles.polygon_num(k)), handles.polygon_num(k), obstacle_norm, 0, 0);
    
    if k < handles.polygon_index-3
        patch(handles.Qpolygon_x(k,1:length_Q,1),handles.Qpolygon_y(k,1:length_Q,1),'green');
    else
        patch(handles.Qpolygon_x(k,1:length_Q,1),handles.Qpolygon_y(k,1:length_Q,1),'green','EdgeColor', 'none');
    end
    
    clear obstacle_vec obstacle_norm length_Q;
    
end

for i=1:handles.polygon_index-4
    patch(handles.polygon_x(i,1:handles.polygon_num(i)),handles.polygon_y(i,1:handles.polygon_num(i)),'blu');
end

W_frame = getframe;
[W_img, Map] = frame2im(W_frame);
handles.W=W_img(:,:,1);


patch(handles.robot_x(1:handles.robot_num),handles.robot_y(1:handles.robot_num),'red');
rectangle('Position',[[handles.se_x(1),handles.se_y(1)]-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')


% Save the handles structure.
guidata(hObject,handles)



% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

point = ginput(1);
handles.se_x(2)=point(1,1);
handles.se_y(2)=point(1,2);
rectangle('Position',[point-[.04, .04], .08, .08],'Curvature',[1,1],'FaceColor','k')

% Save the handles structure.
guidata(hObject,handles)




% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value'); %returns toggle state of checkbox1

if val == 1;
    handles.makemovie=1; 
else
    handles.makemovie=0;
end

% Save the handles structure.
guidata(hObject,handles)



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value'); %returns toggle state of checkbox1

if val == 1;
    handles.make3Dgraph=1; 
else
    handles.make3Dgraph=0;
end

% Save the handles structure.
guidata(hObject,handles)




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   
% Save the handles structure.
guidata(hObject,handles)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.angle = str2double(get(hObject,'String'));

% Save the handles structure.
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


