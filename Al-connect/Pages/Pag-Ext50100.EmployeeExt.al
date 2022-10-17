pageextension 50100 "Employee Ext" extends "Employee Card"
{

    layout
    {
        addafter("Name")
        {
            field("Horas Trabajadas hoy"; Rec."Total Horas Trabajadas")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Total Hours Worked', ESP = 'Total de Horas Trabajadas';
            }
        }

        addfirst(factboxes)
        {
            part(Reportarhoras; "Reportar Horas en Tareas")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Report Hours in Tasks', ESP = 'Reportar Horas en Tareas';
            }
        }

        // addlast(General)
        // {
        //     usercontrol(ControlMarcajes; ControlMarcajes)
        //     {
        //         ApplicationArea = All;

        //         trigger CrearApp()
        //         var
        //             rAsignarTarea: record "Recurso por Tarea";
        //             vhtml: Text;
        //             jsonDatos: JsonObject;
        //         begin
        //             clear(jsonDatos);
        //             rAsignarTarea.Reset();
        //             rAsignarTarea.SetRange("Nº empleado", Rec."No.");

        //             vhtml := '<select class="form-select" id="SelectTarea">';

        //             if rAsignarTarea.FindSet() then begin
        //                 repeat
        //                     vhtml += '<option attr-proyecto="' + rAsignarTarea.Proyecto + '" attr-tarea="' + rAsignarTarea.Tarea + '" value="' + rAsignarTarea.Proyecto + rAsignarTarea.Tarea + '">' + rAsignarTarea.Proyecto + '-' + rAsignarTarea.Tarea + '</option>';
        //                 until rAsignarTarea.Next() = 0;
        //             end;

        //             vhtml += '</select>';

        //             jsonDatos.Add('html', vhtml);

        //             CurrPage.ControlMarcajes.definirMain(jsonDatos);
        //         end;
        //     }
        //}
    }

    actions
    {
        addafter("Co&mments")
        {
            action(CreateResource)
            {
                ApplicationArea = All;
                Caption = 'Crear Recurso';
                Image = Create;

                trigger OnAction()
                var
                    cuMgtMarcajes: Codeunit MgtMarcajes;
                begin
                    cuMgtMarcajes.CreateResourceByEmployee(Rec);
                end;
            }
        }
    }

}
