tableextension 60100 "Employee Ext" extends Employee
{
    fields
    {
        field(50100; "Total Horas Trabajadas"; Decimal)
        {
            Caption = 'Total Horas Trabajadas';
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = sum(ReporteHoras."Horas Trabajadas" where("Nº empleado" = field("No.")));
        }
    }
}
