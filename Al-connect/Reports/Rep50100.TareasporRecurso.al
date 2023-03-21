report 60100 "Tareas por Recurso"
{
    ApplicationArea = All;
    Caption = 'Tareas por Recurso';
    UsageCategory = Administration;
    RDLCLayout = './Reports/TareaRecurso.rdlc';
    dataset
    {
        dataitem(RecursoporTarea; "Recurso por Tarea")
        {
            column(Nempleado; "Nº empleado")
            {
            }
            column(Proyecto; Proyecto)
            {
            }
            column(Tarea; Tarea)
            {
            }
        }
    }
}
