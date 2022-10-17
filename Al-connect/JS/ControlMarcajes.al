controladdin ControlMarcajes
{
    RequestedHeight = 300;
    MinimumHeight = 300;
    MaximumHeight = 300;
    RequestedWidth = 300;
    MinimumWidth = 300;
    MaximumWidth = 300;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;


    Scripts = './JS/js/tools.js', 'https://code.jquery.com/jquery-2.1.0.min.js',
    'https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js';
    StyleSheets = 'https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css';
    StartupScript = './JS/js/start.js';
    RefreshScript = './JS/js/start.js';
    RecreateScript = './JS/js/start.js';

    //PROCEDURE AL->JS
    //EVENT JS->AL

    event CrearApp()

    procedure definirMain(Json: JsonObject);

    event RegistrarReporte(Horas: Text; Tarea: Text);
}