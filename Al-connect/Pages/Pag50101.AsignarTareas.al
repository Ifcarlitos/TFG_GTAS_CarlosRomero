page 60101 "Asignar Tareas"
{
    ApplicationArea = All;
    Caption = 'Asignar Tareas';
    PageType = List;
    SourceTable = "Recurso por Tarea";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Nº empleado"; Rec."Nº empleado")
                {
                    ToolTipML = ENU = 'Employee number', ESP = 'Número de empleado';
                    ApplicationArea = All;
                }
                field(Proyecto; Rec.Proyecto)
                {
                    ToolTipML = ENU = 'Specifies the value of the Proyecto field.', ESP = 'Especifica el valor del campo Proyecto.';
                    ApplicationArea = All;
                }
                field(Tarea; Rec.Tarea)
                {
                    ToolTipML = ENU = 'Specifies the value of the Tarea field.', ESP = 'Especifica el valor del campo Tarea.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
