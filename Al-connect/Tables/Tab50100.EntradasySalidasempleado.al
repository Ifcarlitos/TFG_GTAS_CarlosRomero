table 60100 "Entradas y Salidas empleado"
{
    Caption = 'Entradas y Salidas empleado';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            CaptionML = ESP = 'Num Movimiento', ENU = 'Num Movement';
            AutoIncrement = true;
        }
        field(2; "Nº empleado"; Text[250])
        {
            CaptionML = ENU = 'Employee No.', ESP = 'Nº empleado';
            DataClassification = ToBeClassified;
        }
        field(3; Fecha; Date)
        {
            CaptionML = ENU = 'Date', ESP = 'Fecha';
            DataClassification = ToBeClassified;
        }
        field(4; Hora; Time)
        {
            CaptionML = ENU = 'Time', ESP = 'Hora';
            DataClassification = ToBeClassified;
        }
        field(5; Marca; enum "Tipo de Marcaje")
        {
            CaptionML = ENU = 'Mark', ESP = 'Marca';
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
