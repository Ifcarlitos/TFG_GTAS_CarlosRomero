table 60102 "Recurso por Tarea"
{
    Caption = 'Recurso por Tarea';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Nº empleado"; Text[250])
        {
            Caption = 'Nº empleado';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(2; Proyecto; Text[250])
        {
            Caption = 'Proyecto';
            DataClassification = ToBeClassified;
            TableRelation = Job."No.";
        }
        field(3; Tarea; Text[250])
        {
            Caption = 'Tarea';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field(Proyecto));
        }
        field(4; id; Integer)
        {
            AutoIncrement = true;
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; id, "Nº empleado", Proyecto, Tarea)
        {
            Clustered = true;
        }
    }
}
