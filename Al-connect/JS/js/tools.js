MainDiv = document.createElement("div");
MainDiv.id = "MainDiv";

function definirMain(JsonDatosProyectos){
    vhtml= `
    <div class="container">
        <div class="row">
            <div class="col-sm">
                Selecciona un Proyecto:
            </div>
        </div>
        <div class="row">
            <div class="col-sm">
            <select onchange="changeJob(this)" class="form-select" id="SelectProyecto">
                <option value="selectProyecto">Selecciona un Proyecto</option>
            </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm">
                Selecciona una Tarea:
            </div>
        </div>
        <div class="row">
            <div class="col-sm">
            <select onchange="changeAttr(this)" class="form-select" id="SelectTarea" disabled>
                <option value="selectTarea">Selecciona una Tarea</option>
            </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm">
                <form class="form-inline">
                    <label for="number" class="sr-only">Horas:</label>
                    <input type="number" class="form-control" id="horasRerporte" placeholder="0">
                    </br>
                    <button type="submit" onclick="RegistrarHoras()" class="btn btn-primary mb-2">Confirmar Horas</button>
                </form>
            </div>
        </div>
    </div>`;
    MainSelect = vhtml;
    ParentDiv = document.getElementById("controlAddIn");
    ParentDiv.innerHTML = MainSelect;

    //agregar datos al select de proyectos
    var select = document.getElementById("SelectProyecto");
    for (var i = 0; i < JsonDatosProyectos.length; i++) {
        var opt = JsonDatosProyectos[i];
        var el = document.createElement("option");
        // `<option attr-proyecto="`+opt['Proyecto']+`" attr-tarea="`+opt['Tarea']+`" value="`+opt['id']+`">`+opt['Proyecto']+`-`+opt['Tarea']+`</option>`;
        el.value = opt['Proyecto'];
        el.textContent = opt['Proyecto']+`-`+opt['Description'];
        el.setAttribute("attr-proyecto", opt['Proyecto']);
        select.appendChild(el);
    }
}

function changeJob(obj){
    //borrar opciones del select de tareas menos la primera
    var select = document.getElementById("SelectTarea");
    var length = select.options.length;
    for (i = length-1; i >= 1; i--) {
        select.options[i] = null;
    }
    
    //alert(obj.value);
    var arguments = [obj.value];
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CargarTareas', arguments);
}

function definirTareas(jsonTareas){
    //agregar datos al select de tareas
    var select = document.getElementById("SelectTarea");
    for(var i = 0; i < jsonTareas.length; i++) {
        var opt = jsonTareas[i];
        var el = document.createElement("option");
        el.value = opt['Tarea'];
        el.textContent = opt['Tarea']+`-`+opt['Description'];
        el.setAttribute("attr-tarea", opt['Tarea']);
        el.setAttribute("attr-proyecto", opt['Proyecto']);
        select.appendChild(el);
    }
    //habilitar el select de tareas
    document.getElementById("SelectTarea").disabled = false;
}

function LimpiarCampos(){
    document.getElementById("horasRerporte").value = "";
    document.getElementById("SelectTarea").value = "selectTarea";
    document.getElementById("SelectProyecto").value = "selectProyecto";
    //borrar opciones del select de tareas menos la primera
    var select = document.getElementById("SelectTarea");
    var length = select.options.length;
    for (i = length-1; i >= 1; i--) {
        select.options[i] = null;
    }
    document.getElementById("SelectTarea").disabled = true;
}

function RegistrarHoras(){
    var horas = document.getElementById("horasRerporte").value;
    var tarea = $("#SelectTarea").val();
    var proyecto = $("#SelectProyecto").val();

    arguments = [horas, tarea, proyecto];

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RegistrarReporte', arguments);
}


