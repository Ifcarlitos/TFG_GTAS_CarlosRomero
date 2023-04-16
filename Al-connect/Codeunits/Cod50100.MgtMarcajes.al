codeunit 60100 MgtMarcajes
{
    Permissions = tabledata "Recurso por Tarea" = rmid;

    trigger OnRun()
    var
    begin

    end;

    procedure CreateResourceByEmployee(var rEmployee: Record Employee)
    var
        rResource: Record Resource;
        rResourceUnit: Record "Resource Unit of Measure";
    begin
        if rEmployee.FindSet() then begin
            repeat
                rResource.Init();
                rResource.validate("No.", rEmployee."No.");
                rResource.Name := rEmployee.Name;
                rResource.validate(Type, rResource.Type::Person);
                rResource."Search Name" := rEmployee."Search Name";
                rResource.validate("Employee Nº", rEmployee."No.");
                rResource."Base Unit of Measure" := 'HORA';
                rResource."Unit of Measure Filter" := 'HORA';

                if rResource.Insert() then begin
                    rEmployee."Resource No." := rEmployee."No.";
                    rEmployee.Modify();

                    rResourceUnit.Init();
                    rResourceUnit."Resource No." := rResource."No.";
                    rResourceUnit."Qty. per Unit of Measure" := 1;
                    rResourceUnit."Related to Base Unit of Meas." := true;
                    rResourceUnit.Code := 'HORA';
                    rResourceUnit.Insert();
                end;
            until rEmployee.Next() = 0;
        end;
    end;

    //Modulo de Tereas por Empleado:
    [ServiceEnabled]
    procedure GetTareasByEmployee(Input: Text): Text
    var
        rResourcebyTarea: Record "Recurso por Tarea";
        jsonGeneral: JsonObject;
        jsonTareas: JsonArray;
        jsonTarea: JsonObject;
        output: Text;
        Nempleoyee: Text;
        proyecto: Text;

        jsonInput: JsonObject;
        jsonTokenEmpleado: JsonToken;
        jsonTokenProyecto: JsonToken;

        rjob: Record Job;
        rjobTask: Record "Job Task";
    begin
        jsonInput.ReadFrom(Input);
        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        if jsonInput.Get('proyecto', jsonTokenProyecto) then
            proyecto := jsonTokenProyecto.AsValue().AsText()
        else
            proyecto := '';

        Clear(jsonGeneral);
        Clear(jsonTareas);
        Clear(jsonTarea);

        rResourcebyTarea.Reset();
        rResourcebyTarea.SetRange("Nº empleado", Nempleoyee);
        rResourcebyTarea.SetRange(proyecto, proyecto);

        jsonGeneral.Add('empleado', Nempleoyee);
        jsonTarea.Add('proyecto', '');
        jsonTarea.Add('tareas', '');
        jsonTarea.Add('descripcionTarea', '');
        jsonTarea.Add('descripcionProyecto', '');
        if rResourcebyTarea.FindSet() then begin
            repeat
                jsonTarea.Replace('proyecto', rResourcebyTarea.proyecto);
                jsonTarea.Replace('tareas', rResourcebyTarea.Tarea);
                if rjob.Get(rResourcebyTarea.proyecto) then
                    jsonTarea.Replace('descripcionProyecto', rjob.Description);
                if rjobTask.Get(rResourcebyTarea.proyecto, rResourcebyTarea.Tarea) then
                    jsonTarea.Replace('descripcionTarea', rjobTask.Description);
                jsonTareas.Add(jsonTarea);
            until rResourcebyTarea.Next() = 0;
        end;
        jsonGeneral.Add('tareas', jsonTareas);
        jsonGeneral.WriteTo(output);
        exit(output);
    end;

    procedure getTareasEmpleado(): Text
    var
        rResourcebyTarea: Record "Recurso por Tarea";
        jsonTareaEmpleado: JsonObject;
        jsonArrayTareaEmpleado: JsonArray;
        rjob: Record Job;
        rjobTask: Record "Job Task";
        jsonOutput: JsonObject;
        output: Text;
    begin
        rResourcebyTarea.Reset();
        rjob.Reset();
        rjobTask.Reset();
        Clear(jsonTareaEmpleado);
        Clear(jsonArrayTareaEmpleado);

        jsonTareaEmpleado.Add('empleado', '');
        jsonTareaEmpleado.Add('proyecto', '');
        jsonTareaEmpleado.Add('tarea', '');
        jsonTareaEmpleado.Add('descripcionTarea', '');
        jsonTareaEmpleado.Add('descripcionProyecto', '');

        if rResourcebyTarea.FindSet() then begin
            repeat
                jsonTareaEmpleado.Replace('empleado', rResourcebyTarea."Nº empleado");
                jsonTareaEmpleado.Replace('proyecto', rResourcebyTarea.proyecto);
                jsonTareaEmpleado.Replace('tarea', rResourcebyTarea.Tarea);
                if rjob.Get(rResourcebyTarea.proyecto) then
                    jsonTareaEmpleado.Replace('descripcionProyecto', rjob.Description);
                if rjobTask.Get(rResourcebyTarea.proyecto, rResourcebyTarea.Tarea) then
                    jsonTareaEmpleado.Replace('descripcionTarea', rjobTask.Description);
                jsonArrayTareaEmpleado.Add(jsonTareaEmpleado.Clone());
            until rResourcebyTarea.Next() = 0;
        end;
        Clear(jsonOutput);
        jsonOutput.Add('tareasEmpleado', jsonArrayTareaEmpleado);
        jsonOutput.WriteTo(output);
        exit(output);
    end;

    [ServiceEnabled]
    procedure GetJob(): Text
    var
        rjob: Record Job;
        rjobTask: Record "Job Task";

        jsonArrayJob: JsonArray;
        jsonJob: JsonObject;

        jsonArrayTask: JsonArray;
        jsonTask: JsonObject;

        jsonOutput: JsonObject;
        output: Text;
    begin
        rjob.Reset();
        rjobTask.Reset();
        Clear(jsonArrayJob);
        Clear(jsonJob);
        Clear(jsonArrayTask);
        Clear(jsonTask);
        Clear(jsonOutput);

        jsonJob.Add('proyecto', '');
        jsonJob.Add('descripcion', '');
        jsonJob.Add('cliente', '');
        jsonJob.Add('idCliente', '');

        if rjob.FindSet() then begin
            repeat
                jsonJob.Replace('proyecto', rjob."No.");
                jsonJob.Replace('descripcion', rjob.Description);
                jsonJob.Replace('cliente', rjob."Bill-to Name");
                jsonJob.Replace('idCliente', rjob."Bill-to Customer No.");
                jsonArrayJob.Add(jsonJob.Clone());
            until rjob.Next() = 0;
        end;

        jsonTask.Add('proyecto', '');
        jsonTask.Add('tarea', '');
        jsonTask.Add('descripcion', '');
        jsonTask.Add('descripcionProyecto', '');

        if rjobTask.FindSet() then begin
            repeat
                jsonTask.Replace('proyecto', rjobTask."Job No.");
                jsonTask.Replace('tarea', rjobTask."Job Task No.");
                jsonTask.Replace('descripcion', rjobTask.Description);
                rjob.Reset();
                if rjob.Get(rjobTask."Job No.") then
                    jsonTask.Replace('descripcionProyecto', rjob.Description);
                jsonArrayTask.Add(jsonTask.Clone());
            until rjobTask.Next() = 0;
        end;

        jsonOutput.Add('proyectos', jsonArrayJob);
        jsonOutput.Add('tareas', jsonArrayTask);

        jsonOutput.WriteTo(output);

        exit(output);
    end;

    //Modulo de marcajes:

    [ServiceEnabled]
    procedure NuevaEntradaSalida(input: Text): Text
    var
        rEntradaSalida: Record "Entradas y Salidas empleado";
        jsonInput: JsonObject;
        jsonTokenEmpleado: JsonToken;
        jsonTokenFecha: JsonToken;
        jsonTokenHora: JsonToken;
        jsonTokenTipo: JsonToken;

        Nempleoyee: Text;
        Fecha: Date;
        fechaTxt: Text;
        Hora: Time;
        horaTxt: Text;
        Tipo: Text;
    begin
        jsonInput.ReadFrom(input);
        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        if jsonInput.Get('fecha', jsonTokenFecha) then begin
            fechaTxt := jsonTokenFecha.AsValue().AsText();
            Evaluate(Fecha, fechaTxt);
        end else
            Fecha := 0D;

        if jsonInput.Get('hora', jsonTokenHora) then begin
            horatxt := jsonTokenHora.AsValue().AsText();
            Evaluate(Hora, horatxt);
        end else
            Hora := 0T;

        if jsonInput.Get('tipo', jsonTokenTipo) then
            Tipo := jsonTokenTipo.AsValue().AsText()
        else
            Tipo := '';

        rEntradaSalida.Init();
        rEntradaSalida."Nº empleado" := Nempleoyee;
        rEntradaSalida.Fecha := Fecha;
        rEntradaSalida.Hora := Hora;
        case tipo of
            'E':
                rEntradaSalida.Marca := rEntradaSalida.Marca::E;
            'S':
                rEntradaSalida.Marca := rEntradaSalida.Marca::S;
            else
                exit('ERROR');
        end;
        if rEntradaSalida.Insert() then
            exit('OK')
        else
            exit('ERROR');
    end;

    [ServiceEnabled]
    procedure GetLastMarcaje(input: Text): Text
    var
        rEntradaSalida: Record "Entradas y Salidas empleado";
        jsonInput: JsonObject;
        jsonTokenEmpleado: JsonToken;
        Nempleoyee: Text;

        jsonOutput: JsonObject;
        output: Text;
    begin
        jsonInput.ReadFrom(input);
        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        rEntradaSalida.Reset();
        rEntradaSalida.SetRange("Nº empleado", Nempleoyee);
        jsonOutput.Add('empleado', Nempleoyee);
        jsonOutput.Add('fecha', '');
        jsonOutput.Add('hora', '');
        jsonOutput.Add('tipo', '');
        if rEntradaSalida.FindLast() then begin
            jsonOutput.Replace('fecha', rEntradaSalida.Fecha);
            jsonOutput.Replace('hora', rEntradaSalida.Hora);
            case rEntradaSalida.Marca of
                rEntradaSalida.Marca::E:
                    jsonOutput.Replace('tipo', 'E');
                rEntradaSalida.Marca::S:
                    jsonOutput.Replace('tipo', 'S');
            end;
        end else begin
            jsonOutput.Replace('fecha', 0D);
            jsonOutput.Replace('hora', 0T);
            jsonOutput.Replace('tipo', 'nada');
        end;

        jsonOutput.WriteTo(output);
        exit(output);
    end;

    [ServiceEnabled]
    procedure CreateJobTaskRelation(input: Text): Text
    var
        jsonInput: JsonObject;
        jsonTokenProyecto: JsonToken;
        jsonTokenTarea: JsonToken;
        jsonTokenEmpleado: JsonToken;

        proyecto: Text;
        tarea: Text;
        Nempleoyee: Text;

        rResourcebyTarea: Record "Recurso por Tarea";

        resul: Text;
    begin
        resul := 'ERROR';
        jsonInput.ReadFrom(input);
        if jsonInput.Get('proyecto', jsonTokenProyecto) then
            proyecto := jsonTokenProyecto.AsValue().AsText()
        else
            proyecto := '';

        if jsonInput.Get('tarea', jsonTokenTarea) then
            tarea := jsonTokenTarea.AsValue().AsText()
        else
            tarea := '';

        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        rResourcebyTarea.Init();
        rResourcebyTarea.Validate("Nº empleado", Nempleoyee);
        rResourcebyTarea.Validate(Proyecto, proyecto);
        rResourcebyTarea.Validate(Tarea, tarea);

        if rResourcebyTarea.Insert() then
            resul := 'OK';

        exit(resul);
    end;

    [ServiceEnabled]
    procedure getEmpleados(): Text
    var
        Employee: Record Employee;
        jsonEmployee: JsonObject;
        jsonArrayEmployee: JsonArray;
        jsonOutput: JsonObject;
        output: Text;
    begin
        Employee.Reset();
        jsonEmployee.Add('id', '');
        jsonEmployee.Add('nombre', '');
        jsonEmployee.Add('apellidos', '');

        if Employee.FindSet() then begin
            repeat
                jsonEmployee.Replace('id', Employee."No.");
                jsonEmployee.Replace('nombre', Employee.Name);
                jsonEmployee.Replace('apellidos', Employee."Last Name");
                jsonArrayEmployee.Add(jsonEmployee.Clone());
            until Employee.Next() = 0;
        end;

        jsonOutput.Add('empleados', jsonArrayEmployee);
        jsonOutput.WriteTo(output);
        exit(output);
    end;

    [ServiceEnabled]
    PROCEDURE CreateJobJournalLine(input: Text): Text
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
        proyecto: Text;
        tarea: Text;
        fecha: Date;
        fechatxt: Text;
        horas: Decimal;
        comentarios: Text;
    BEGIN

        jsonInput.ReadFrom(input);
        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        if jsonInput.Get('proyecto', jsonTokenProyecto) then
            proyecto := jsonTokenProyecto.AsValue().AsText()
        else
            proyecto := '';

        if jsonInput.Get('tarea', jsonTokenTarea) then
            tarea := jsonTokenTarea.AsValue().AsText()
        else
            tarea := '';

        if jsonInput.Get('fecha', jsonTokenFecha) then begin
            fechatxt := jsonTokenFecha.AsValue().AsText();
            Evaluate(fecha, fechatxt);
        end else
            fecha := 0D;

        if jsonInput.Get('horas', jsonTokenHoras) then
            horas := jsonTokenHoras.AsValue().AsDecimal()
        else
            horas := 0;

        if jsonInput.Get('comentarios', jsonTokenComentarios) then
            comentarios := jsonTokenComentarios.AsValue().AsText()
        else
            comentarios := '';

        //comporbar si existe el proyecto
        tJob.RESET();
        tJob.SETRANGE("No.", proyecto);
        if not tJob.FINDFIRST() then begin
            //creamos el proyecto
            tJob.Init();
            tJob.Validate("No.", proyecto);
            tJob.Validate(Description, proyecto);
            tJob.INSERT();
        end;

        //comporbar si existe la tarea
        tJobTask.RESET();
        tJobTask.SETRANGE("Job No.", proyecto);
        tJobTask.SETRANGE("Job Task No.", tarea);
        if not tJobTask.FINDFIRST() then begin
            //creamos la tarea
            tJobTask.Init();
            tJobTask.Validate("Job No.", proyecto);
            tJobTask.Validate("Job Task Type", tJobTask."Job Task Type"::Posting);
            tJobTask.Validate("Job Task No.", tarea);
            tJobTask.Validate(Description, tarea);
            tJobTask.INSERT();
        end;

        //comporbar si existe el empleado
        rResource.RESET();
        rResource.SETRANGE("No.", Nempleoyee);
        if not rResource.FINDFIRST() then begin
            //creamos el empleado
            rEmployee.RESET();
            rEmployee.SETRANGE("No.", Nempleoyee);
            if rEmployee.FINDFIRST() then begin
                CreateResourceByEmployee(rEmployee);
            end;
        end;

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
        tJobJournalLine.VALIDATE("Job No.", proyecto);
        tJobJournalLine.VALIDATE("Job Task No.", tarea);
        tJobJournalLine.VALIDATE("Posting Date", fecha);
        tJobJournalLine.Type := tJobJournalLine.Type::Resource;
        tJobJournalLine.VALIDATE("No.", Nempleoyee);
        tJobJournalLine.VALIDATE(Quantity, horas);
        tJobJournalLine.Description := COPYSTR(comentarios, 1, 50);
        tJobsSetup.GET;
        vDocumentNo := NoSeriesMgt.GetNextNo(tJobsSetup."Job Nos.", TODAY, TRUE);
        tJobJournalLine.VALIDATE("Document No.", vDocumentNo);

        tJobJournalLine.INSERT(TRUE);
        IF tJob.GET(tJobJournalLine."Job No.") THEN BEGIN
            exit('OK');
        END;
    END;
}
