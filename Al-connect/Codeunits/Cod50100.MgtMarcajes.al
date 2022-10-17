codeunit 50100 MgtMarcajes
{
    trigger OnRun()
    var
    begin

    end;

    procedure CreateResourceByEmployee(var rEmployee: Record Employee)
    var
        rResource: Record Resource;
    begin
        if rEmployee.FindSet() then begin
            repeat
                rResource.Init();
                rResource."No." := rEmployee."No.";
                rResource.Name := rEmployee.Name;
                rResource.validate(Type, rResource.Type::Person);
                rResource."Search Name" := rEmployee."Search Name";
                rResource."Employee Nº" := rEmployee."No.";
                if rResource.Insert() then begin
                    rEmployee."Resource No." := rEmployee."No.";
                    rEmployee.Modify();
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
        if rResourcebyTarea.FindSet() then begin
            repeat
                jsonTarea.Replace('proyecto', rResourcebyTarea.proyecto);
                jsonTarea.Replace('tareas', rResourcebyTarea.Tarea);
                jsonTareas.Add(jsonTarea);
            until rResourcebyTarea.Next() = 0;
        end;
        jsonGeneral.Add('tareas', jsonTareas);
        jsonGeneral.WriteTo(output);
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
        Hora: Time;
        Tipo: Text;
    begin
        jsonInput.ReadFrom(input);
        if jsonInput.Get('empleado', jsonTokenEmpleado) then
            Nempleoyee := jsonTokenEmpleado.AsValue().AsText()
        else
            Nempleoyee := '';

        if jsonInput.Get('fecha', jsonTokenFecha) then
            Fecha := jsonTokenFecha.AsValue().AsDate()
        else
            Fecha := 0D;

        if jsonInput.Get('hora', jsonTokenHora) then
            Hora := jsonTokenHora.AsValue().AsTime()
        else
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
}
