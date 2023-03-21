page 60100 "Marcajes Empleados"
{
    ApplicationArea = All;
    Caption = 'Marcajes Empleados';
    PageType = List;
    SourceTable = "Entradas y Salidas empleado";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.id)
                {
                    ToolTipML = ENU = 'Id', ESP = 'Id';
                    CaptionML = ENU = 'Id', ESP = 'Id';
                    ApplicationArea = All;
                }
                field("Nº empleado"; Rec."Nº empleado")
                {
                    ToolTipML = ENU = 'Nº empleado', ESP = 'Nº empleado';
                    CaptionML = ENU = 'Nº empleado', ESP = 'Nº empleado';
                    ApplicationArea = All;
                }
                field(Fecha; Rec.Fecha)
                {
                    ToolTipML = ENU = 'Fecha', ESP = 'Fecha';
                    CaptionML = ENU = 'Fecha', ESP = 'Fecha';
                    ApplicationArea = All;
                }
                field(Hora; Rec.Hora)
                {
                    ToolTipML = ENU = 'Hora', ESP = 'Hora';
                    CaptionML = ENU = 'Hora', ESP = 'Hora';
                    ApplicationArea = All;
                }
                field(Marca; Rec.Marca)
                {
                    ToolTipML = ENU = 'Marca', ESP = 'Marca';
                    CaptionML = ENU = 'Marca', ESP = 'Marca';
                    ApplicationArea = All;
                }
            }
        }
    }
}
