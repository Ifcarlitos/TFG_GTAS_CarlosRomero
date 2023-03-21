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
                    rEmployee: Record Employee;
                begin
                    rEmployee.Get(Rec."No.");
                    cuMgtMarcajes.CreateResourceByEmployee(rEmployee);
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
