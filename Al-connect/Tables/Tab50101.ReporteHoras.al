table 60101 ReporteHoras
{
    Caption = 'ReporteHoras';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(2; Type; Enum "Tipo de Reporte")
        {
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            dataclassification = ToBeClassified;
        }
        field(3; "Nº empleado"; Text[250])
        {
            Caption = 'Nº empleado';
            DataClassification = ToBeClassified;
        }
        field(4; Fecha; Date)
        {
            Caption = 'Fecha';
            DataClassification = ToBeClassified;
        }
        field(5; "Hora Entrada"; Time)
        {
            Caption = 'Hora Entrada';
            DataClassification = ToBeClassified;
        }
        field(6; "Hora Salida"; Time)
        {
            Caption = 'Hora Salida';
            DataClassification = ToBeClassified;
        }
        field(7; "Horas Trabajadas"; Decimal)
        {
            Caption = 'Horas Trabajadas';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}
