function varargout = Perceptron1CapaKS(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Perceptron1CapaKS_OpeningFcn, ...
                       'gui_OutputFcn',  @Perceptron1CapaKS_OutputFcn, ...
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
end
    
function Perceptron1CapaKS_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    clc
    %LOGO DE UCUENCA
    axes(handles.axes4);
    logo=imread('Ucuenca.jpg');
    imshow(logo);
    axis off
    %INGRESAR DATOS A LA TABLA
    w=[0 0 0 ; 0 1 1 ;  1 0 1 ; 1 1 0 ];
    set(handles.Tabla,'Data',w);
    set(handles.w110, 'String',num2str(0));
    set(handles.w120, 'String',num2str(0));
    set(handles.w210, 'String',num2str(0));
    set(handles.w220, 'String',num2str(0));
    set(handles.v10, 'String',num2str(0));
    set(handles.v20, 'String',num2str(0));
    set(handles.u210, 'String',num2str(0));
    set(handles.u220, 'String',num2str(0));
    set(handles.u30, 'String',num2str(0));
    set(handles.X1, 'String',num2str(0));
    set(handles.X2, 'String',num2str(0));
    set(handles.Error, 'String',num2str(0));
    set(handles.Iteraciones, 'String',num2str(1000));
end
% --- Outputs from this function are returned to the command line.
function varargout = Perceptron1CapaKS_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end

%BOTON Aleatorio.
function btAleatorio_Callback(hObject, eventdata, handles)
    set(handles.w110, 'String',num2str(3*rand-1));
    set(handles.w120, 'String',num2str(3*rand-1));
    set(handles.w210, 'String',num2str(3*rand-1));
    set(handles.w220, 'String',num2str(3*rand-1));
    set(handles.v10, 'String',num2str(3*rand-1));
    set(handles.v20, 'String',num2str(3*rand-1));
    set(handles.u210, 'String',num2str(3*rand-1));
    set(handles.u220, 'String',num2str(3*rand-1));
    set(handles.u30, 'String',num2str(3*rand-1));
end

%BOTON Ingresar.
function btIngresar_Callback(hObject, eventdata, handles)
    set(handles.w110, 'String',num2str(0));
    set(handles.w120, 'String',num2str(0));
    set(handles.w210, 'String',num2str(0));
    set(handles.w220, 'String',num2str(0));
    set(handles.v10, 'String',num2str(0));
    set(handles.v20, 'String',num2str(0));
    set(handles.u210, 'String',num2str(0));
    set(handles.u220, 'String',num2str(0));
    set(handles.u30, 'String',num2str(0));
end

%BOTON ENTRENAR.
function btEntrenar_Callback(hObject, eventdata, handles)
    %Obtener Datos de Tabla
    datos=get(handles.Tabla,'Data');
    x1=datos(:,1);
    x2=datos(:,2);
    yd=datos(:,3);

    %Otener datos iniciales de pesos y bias
    w110= str2double(get(handles.w110,'String'));
    w120= str2double(get(handles.w120,'String'));
    w210= str2double(get(handles.w210,'String'));
    w220= str2double(get(handles.w220,'String'));
    v10= str2double(get(handles.v10,'String'));
    v20= str2double(get(handles.v20,'String'));
    u210= str2double(get(handles.u210,'String'));
    u220= str2double(get(handles.u220,'String'));
    u30= str2double(get(handles.u30,'String'));
    alfa= str2double(get(handles.alfa,'String'));
    
    %Otener datos de iteraciones y error
    iteracionmax = str2double(get(handles.Iteraciones,'String'));
    errormax = str2double(get(handles.Error,'String'));

    %ENTRENAMIENTO 
    w11= w110;
    w12=w120;
    w21= w210;
    w22= w220;
    v1= v10;
    v2= v20;
    u21= u210;
    u22= u220;
    u3= u30;
    condicion = 0;
    iteracion = 0;
    error_Total = zeros(1,iteracionmax+1);
    while(condicion == 0)
        for j = 1 : 4
            %Calcular la yObtenida
            %Capa Entrada
            z1 = x1(j);
            a11 = z1;
            z2 = x2(j);
            a12 = z2;

            %Capa Oculta
            z3 = a11*w11+a12*w21 + u21;
            a21 = funcion_activ(z3);
            z4 = a11*w12+a12*w22 + u22;
            a22 = funcion_activ(z4);

            %Capa Salida
            z5 = a21*v1 + a22*v2 + u3;
            yObtenida = funcion_activ(z5);

            %Calculamos error yObtenida*(1-yObtenida)*
            err = (yd(j)- yObtenida);

            %Correccion pesos Capa 2-3
            z= v1*a21+v2*a22+u3;
            d3 = err*derivada_fun_act(z);
            v1 = v1 + alfa*d3*a21;
            v2 = v2 + alfa*d3*a22;
            u3 = u3 + alfa*d3;

            %Correccion pesos Capa 1-2
            d21 = derivada_fun_act(z3)*v1*d3;
            w11 = w11 + alfa*d21*a11;
            w21 = w21 + alfa*d21*a12;
            u21 = u21 + alfa*d21;

            d22 = derivada_fun_act(z4)*v2*d3;
            w12 = w12 + alfa*d22*a11;
            w22 = w22 + alfa*d22*a12;
            u22 = u22 + alfa*d22;

            %Contar error total
            error_Total(iteracion+1) = error_Total(iteracion+1)+abs(err);
        end
        iteracion = iteracion +1
        if(iteracion >= iteracionmax)
            condicion =1;
        end
        if (error_Total(iteracion) <= errormax)
            condicion =1;
        end
    end

    %Mostrar los Resultados
    set(handles.w11,'String',num2str(w11));
    set(handles.w12,'String',num2str(w12));
    set(handles.w21,'String',num2str(w21));
    set(handles.w22,'String',num2str(w22));
    set(handles.v1,'String',num2str(v1));
    set(handles.v2,'String',num2str(v2));
    set(handles.u21,'String',num2str(u21));
    set(handles.u22,'String',num2str(u22));
    set(handles.u3,'String',num2str(u3));

    %Dibujar el error
    axes(handles.axes1);
    x=0:1:iteracionmax;
    plot(x,error_Total,'color','r', 'LineWidth', 2);
end 

function f = funcion_activ(z)
    %SIGNOIDE
    f = 1/(1+exp(-z));
end

function fp = derivada_fun_act(z)
    %SIGNOIDE
    fp = (1-funcion_activ(z))*funcion_activ(z);
end

% BOTON CALCULAR
function btCalcular_Callback(hObject, eventdata, handles)
    %Otener datos optimos
    w11= str2double(get(handles.w11,'String'));
    w12= str2double(get(handles.w12,'String'));
    w21= str2double(get(handles.w21,'String'));
    w22= str2double(get(handles.w22,'String'));
    v1= str2double(get(handles.v1,'String'));
    v2= str2double(get(handles.v2,'String'));
    u21= str2double(get(handles.u21,'String'));
    u22= str2double(get(handles.u22,'String'));
    u3= str2double(get(handles.u3,'String'));

    %Otener datos x1 y x2 ingresados
    x10= str2double(get(handles.X1,'String'));
    x20= str2double(get(handles.X2,'String'));
    
    %Calcular la yObtenida
    %Capa Entrada
    z1 = x10;
    a11 = z1;
    z2 = x20;
    a12 = z2;

    %Capa Oculta
    z3 = a11*w11+a12*w21 + u21;
    a21 = funcion_activ(z3);
    z4 = a11*w12+a12*w22 + u22;
    a22 = funcion_activ(z4);

    %Capa Salida
    z5 = a21*v1 + a22*v2+u3;
    yObtenida = funcion_activ(z5);

    %Mostrar los Resultados
    set(handles.Salida,'String',num2str(z5));
    set(handles.Respuesta,'String',num2str(yObtenida));
    set(handles.Y,'String',num2str(round(yObtenida)));
end

function X1_Callback(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function X2_Callback(hObject, eventdata, handles)
end

function X2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function Salida_Callback(hObject, eventdata, handles)
end

function Salida_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function Respuesta_Callback(hObject, eventdata, handles)
end

function Respuesta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function w110_Callback(hObject, eventdata, handles)
end

function w110_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function w210_Callback(hObject, eventdata, handles)
end

function w210_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function u210_Callback(hObject, eventdata, handles)
end

function u210_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit15_Callback(hObject, eventdata, handles)
end

function edit15_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit16_Callback(hObject, eventdata, handles)
end

function edit16_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit17_Callback(hObject, eventdata, handles)
end

function edit17_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function Iteraciones_Callback(hObject, eventdata, handles)
end

function Iteraciones_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function w120_Callback(hObject, eventdata, handles)
end

function w120_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function w220_Callback(hObject, eventdata, handles)
end

function w220_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end 


function u220_Callback(hObject, eventdata, handles)
end
function u220_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function v10_Callback(hObject, eventdata, handles)
end

function v10_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function v20_Callback(hObject, eventdata, handles)
end

function v20_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function u30_Callback(hObject, eventdata, handles)
end

function u30_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function w11_Callback(hObject, eventdata, handles)
end

function w11_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function w21_Callback(hObject, eventdata, handles)
end

function w21_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function u21_Callback(hObject, eventdata, handles)
end

function u21_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function w12_Callback(hObject, eventdata, handles)
end

function w12_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function w22_Callback(hObject, eventdata, handles)
end

function w22_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function u22_Callback(hObject, eventdata, handles)
end

function u22_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function v1_Callback(hObject, eventdata, handles)
end

function v1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function v2_Callback(hObject, eventdata, handles)
end

function v2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function edit37_Callback(hObject, eventdata, handles)
end

function edit37_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function Error_Callback(hObject, eventdata, handles)
end

function Error_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function u3_Callback(hObject, eventdata, handles)
end

function u3_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function edit40_Callback(hObject, eventdata, handles)
end
function X1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function alfa_Callback(hObject, eventdata, handles)
end
function alfa_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function Y_Callback(hObject, eventdata, handles)
end

function Y_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
