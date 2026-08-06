class Tarea {
    constructor(nombre) {
        this.nombre = nombre;
        this.completa = false;
    }
    
    toggleCompleta() {
        this.completa = !this.completa;
    }
}

class GestorDeTareas {
    constructor() {
        this.tareas = JSON.parse(localStorage.getItem('tareas')) || [];
    }
    
    agregarTarea(nombre) {
        const nuevaTarea = new Tarea(nombre);
        this.tareas.push(nuevaTarea);
        this.guardarEnLocalStorage();
    }
    
    eliminarTarea(index) {
        this.tareas.splice(index, 1);
        this.guardarEnLocalStorage();
    }
    
    editarTarea(index, nuevoNombre) {
        this.tareas[index].nombre = nuevoNombre;
        this.guardarEnLocalStorage();
    }
    
    guardarEnLocalStorage() {
        localStorage.setItem('tareas', JSON.stringify(this.tareas));
    }
}

const gestor = new GestorDeTareas();
const taskInput = document.getElementById("taskInput");
const addTaskBtn = document.getElementById("addTaskBtn");
const taskList = document.getElementById("taskList");

function renderTareas() {
    taskList.innerHTML = "";
    gestor.tareas.forEach((tarea, index) => {
        const li = document.createElement("li");
        li.textContent = tarea.nombre;
        
        const editBtn = document.createElement("button");
        editBtn.textContent = "Editar";
        editBtn.onclick = () => {
            const nuevoNombre = prompt("Editar tarea:", tarea.nombre);
            if (nuevoNombre) gestor.editarTarea(index, nuevoNombre);
            renderTareas();
        };
        
        const deleteBtn = document.createElement("button");
        deleteBtn.textContent = "Eliminar";
        deleteBtn.onclick = () => {
            gestor.eliminarTarea(index);
            renderTareas();
        };
        
        li.appendChild(editBtn);
        li.appendChild(deleteBtn);
        taskList.appendChild(li);
    });
}

addTaskBtn.addEventListener("click", () => {
    const taskName = taskInput.value.trim();
    if (taskName) {
        gestor.agregarTarea(taskName);
        taskInput.value = "";
        renderTareas();
    }
});

renderTareas();
