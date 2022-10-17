MainDiv = document.createElement("div");
MainDiv.id = "MainDiv";

function definirMain(JsonDatos){
    vhtml= `
    <div class="container">
        <div class="row">
            <div class="col-sm">
                Selecciona una Tarea
            </div>
        </div>
        <div class="row">
            <div class="col-sm">
                `+JsonDatos.html+`
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
}


function changeAttr(obj){
    //alert(obj.value);
}

function RegistrarHoras(){
    var horas = document.getElementById("horasRerporte").value;
    var tarea = $("#SelectTarea").val();

    arguments = [horas, tarea];

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RegistrarReporte', arguments);
}

