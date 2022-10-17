tableextension 50101 "Resource Ext" extends Resource
{
    fields
    {
        field(50100; "Employee Nº"; Text[250])
        {
            Caption = 'Employee Nº';
            TableRelation = Employee."No.";
            DataClassification = ToBeClassified;
        }
    }
}
