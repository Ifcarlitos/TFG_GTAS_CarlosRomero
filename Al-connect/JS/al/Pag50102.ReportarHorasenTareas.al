page 60102 "Reportar Horas en Tareas"
{
    Caption = 'Reportar Horas en Tareas';
    SourceTable = Employee;
    UsageCategory = Administration;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group(General)
            {
                usercontrol(ControlMarcajes; ControlMarcajes)
                {
                    ApplicationArea = All;

                    trigger CrearApp()
                    var
                        jsonDatos: JsonObject;
                        jsonArrayRecursoPorTarea: JsonArray;

                        jsonArrayRecursoPorProyecto: JsonArray;
                    begin
                        jsonArrayRecursoPorProyecto := ListaRecursosPorProyecto();
                        //jsonArrayRecursoPorTarea := ListaRecursosPorTarea();
                        CurrPage.ControlMarcajes.definirMain(jsonArrayRecursoPorProyecto);
                    end;

                    trigger CargarTareas(Proyecto: Text)
                    var
                        jsonDatos: JsonObject;
                        jsonArrayRecursoPorTarea: JsonArray;
                    begin
                        jsonArrayRecursoPorTarea := ListaRecursosPorTarea(Proyecto);
                        CurrPage.ControlMarcajes.definirTareas(jsonArrayRecursoPorTarea);
                    end;

                    trigger RegistrarReporte(Horas: Text; Tarea: Text; Proyecto: text)
                    VAR
                        tJobTask: Record 1001;
                        tJob: Record 167;
                        vBolsaHoras: Decimal;
                        vLinea: Integer;
                        vCustomer: Text;
                        rutaPdf: Text;
                        vDocumentNo: Text;
                        tJobsSetup: Record 315;
                        NoSeriesMgt: Codeunit 396;
                        rDiarioProyecto: Record "Job Journal Line";
                        tJobJournalLine: Record "Job Journal Line";
                        rEmployee: Record Employee;
                        rResource: Record Resource;

                        //pResource: Text; pProjectNo: Text; 
                        //pTaskNo: Text; pDate: Date; pHours: Decimal; pComments: Text; 
                        jsonInput: JsonObject;
                        jsonTokenEmpleado: JsonToken;
                        jsonTokenProyecto: JsonToken;
                        jsonTokenTarea: JsonToken;
                        jsonTokenFecha: JsonToken;
                        jsonTokenHoras: JsonToken;
                        jsonTokenComentarios: JsonToken;

                        Nempleoyee: Text;
                        vproyecto: Text;
                        vtarea: Text;
                        vfecha: Date;
                        fechatxt: Text;
                        vhoras: Decimal;
                        comentarios: Text;
                    BEGIN


                        Nempleoyee := Rec."No.";


                        vproyecto := Proyecto;


                        vtarea := Tarea;


                        vfecha := today();


                        Evaluate(vhoras, Horas);


                        comentarios := '';

                        tJobJournalLine.reset();
                        IF tJobJournalLine.FINDLAST THEN
                            vLinea := tJobJournalLine."Line No." + 10000
                        ELSE
                            vLinea := 10000;

                        rDiarioProyecto.reset();
                        rDiarioProyecto.SetCurrentKey("Line No.");
                        if rDiarioProyecto.findlast() then begin
                            vLinea := rDiarioProyecto."Line No." + 10000;
                        end else begin
                            vLinea := 10000;
                        end;

                        vBolsaHoras := 0;

                        IF vBolsaHoras > 0 THEN
                            tJobJournalLine."Line Type" := tJobJournalLine."Line Type"::Budget
                        ELSE
                            tJobJournalLine."Line Type" := tJobJournalLine."Line Type"::Billable;

                        tJobJournalLine.VALIDATE("Journal Template Name", 'PROYECTO');
                        tJobJournalLine.VALIDATE("Journal Batch Name", 'GENERICO');
                        tJobJournalLine.VALIDATE("Line No.", vLinea);
                        tJobJournalLine.VALIDATE("Job No.", vproyecto);
                        tJobJournalLine.VALIDATE("Job Task No.", vtarea);
                        tJobJournalLine.VALIDATE("Posting Date", vfecha);
                        tJobJournalLine.Type := tJobJournalLine.Type::Resource;
                        tJobJournalLine.VALIDATE("No.", Nempleoyee);
                        tJobJournalLine.VALIDATE(Quantity, vhoras);
                        tJobJournalLine.Description := COPYSTR(comentarios, 1, 50);
                        tJobsSetup.GET;
                        vDocumentNo := NoSeriesMgt.GetNextNo(tJobsSetup."Job Nos.", TODAY, TRUE);
                        tJobJournalLine.VALIDATE("Document No.", vDocumentNo);

                        tJobJournalLine.INSERT(TRUE);
                        IF tJob.GET(tJobJournalLine."Job No.") THEN BEGIN
                            CurrPage.Update();
                        END;
                    END;
                }
            }
        }
    }

    procedure ListaRecursosPorTarea(proyecto: Text): JsonArray
    var
        rAsignarTarea: record "Recurso por Tarea";
        vhtml: Text;
        jsonDatos: JsonObject;
        jsonArrayRecursoPorTarea: JsonArray;
        rJobTask: Record "Job Task";
    begin
        clear(jsonDatos);
        rAsignarTarea.Reset();
        rAsignarTarea.SetRange("Nº empleado", Rec."No.");
        rAsignarTarea.SetRange("Proyecto", proyecto);

        Clear(jsonArrayRecursoPorTarea);

        jsonDatos.Add('Proyecto', '');
        jsonDatos.Add('Tarea', '');
        jsonDatos.Add('id', '');
        jsonDatos.Add('Description', '');

        if rAsignarTarea.FindSet() then begin
            repeat
                jsonDatos.Replace('Proyecto', rAsignarTarea."Proyecto");
                jsonDatos.Replace('Tarea', rAsignarTarea."Tarea");
                jsonDatos.Replace('id', rAsignarTarea."id");
                if rJobTask.Get(rAsignarTarea."Proyecto", rAsignarTarea."Tarea") then jsonDatos.Replace('Description', rJobTask.Description);
                jsonArrayRecursoPorTarea.Add(jsonDatos.Clone());
            until rAsignarTarea.Next() = 0;
        end;
        exit(jsonArrayRecursoPorTarea);
    end;

    procedure ListaRecursosPorProyecto(): JsonArray
    var
        rAsignarTarea: record "Recurso por Tarea";
        vhtml: Text;
        jsonDatos: JsonObject;
        jsonArrayRecursoPorProyecto: JsonArray;

        vProyectoAnterior: Text;
        rJob: Record Job;
    begin
        clear(jsonDatos);
        rAsignarTarea.Reset();
        rAsignarTarea.SetRange("Nº empleado", Rec."No.");
        rAsignarTarea.SetCurrentKey("Proyecto");

        Clear(jsonArrayRecursoPorProyecto);

        jsonDatos.Add('Proyecto', '');
        jsonDatos.Add('Description', '');

        vProyectoAnterior := '';
        if rAsignarTarea.FindSet() then begin
            repeat
                if vProyectoAnterior <> rAsignarTarea."Proyecto" then begin
                    vProyectoAnterior := rAsignarTarea."Proyecto";
                    jsonDatos.Replace('Proyecto', rAsignarTarea."Proyecto");
                    if rJob.Get(rAsignarTarea."Proyecto") then jsonDatos.Replace('Description', rJob.Description);
                    jsonArrayRecursoPorProyecto.Add(jsonDatos.Clone());
                end;
            until rAsignarTarea.Next() = 0;
        end;
        exit(jsonArrayRecursoPorProyecto);
    end;
}