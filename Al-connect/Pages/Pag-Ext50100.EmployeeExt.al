pageextension 60100 "Employee Ext" extends "Employee Card"
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
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(CreateResource)
            {
                ApplicationArea = All;
                Caption = 'Crear Recurso';
                Image = Create;
                Promoted = true;

                trigger OnAction()
                var
                    cuMgtMarcajes: Codeunit MgtMarcajes;
                    rEmployee: Record Employee;
                begin
                    rEmployee.Get(Rec."No.");
                    cuMgtMarcajes.CreateResourceByEmployee(rEmployee);
                end;
            }
            action(AsignarTarea)
            {
                ApplicationArea = All;
                Caption = 'Asignar Tarea';
                Image = Task;
                Promoted = true;

                trigger OnAction()
                var
                    pAsignarTarea: Page "Asignar Tareas";
                    rRecursoPorTarea: Record "Recurso por Tarea";
                begin
                    rRecursoPorTarea.Reset();
                    rRecursoPorTarea.SetRange("Nº empleado", Rec."No.");
                    pAsignarTarea.SetTableView(rRecursoPorTarea);
                    pAsignarTarea.run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

    end;

}
