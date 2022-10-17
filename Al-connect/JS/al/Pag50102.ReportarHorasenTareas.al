page 50102 "Reportar Horas en Tareas"
{
    Caption = 'Reportar Horas en Tareas';
    SourceTable = Employee;
    UsageCategory = Administration;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group(General)
            {
                usercontrol(ControlMarcajes; ControlMarcajes)
                {
                    ApplicationArea = All;

                    trigger CrearApp()
                    var
                    begin
                        CrearInicio();
                    end;

                    trigger RegistrarReporte(Horas: Text; Tarea: Text)
                    var
                    begin
                        Message('Horas: ' + Horas + ' Tarea: ' + Tarea);
                        CrearInicio();
                    end;
                }
            }
        }
    }

    procedure CrearInicio()
    var
        rAsignarTarea: record "Recurso por Tarea";
        vhtml: Text;
        jsonDatos: JsonObject;
    begin
        clear(jsonDatos);
        rAsignarTarea.Reset();
        rAsignarTarea.SetRange("Nº empleado", Rec."No.");

        vhtml := '<select onchange="changeAttr(this)" class="form-select" id="SelectTarea">';

        if rAsignarTarea.FindSet() then begin
            repeat
                vhtml += '<option attr-proyecto="' + rAsignarTarea.Proyecto + '" attr-tarea="' + rAsignarTarea.Tarea + '" value="' + Format(rAsignarTarea.id) + '">' + rAsignarTarea.Proyecto + '-' + rAsignarTarea.Tarea + '</option>';
            until rAsignarTarea.Next() = 0;
        end;

        vhtml += '</select>';

        jsonDatos.Add('html', vhtml);

        CurrPage.ControlMarcajes.definirMain(jsonDatos);
    end;
}