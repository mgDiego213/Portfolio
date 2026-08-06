// CRUD de Tareas en Kotlin (consola) - guarda en tasks.tsv (tab-separated)
// Ejecuta: kotlinc Main.kt -include-runtime -d crud.jar && java -jar crud.jar

import java.io.File
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import kotlin.system.exitProcess

// ----- Modelo -----
data class Task(
    val id: Int,
    var titulo: String,
    var descripcion: String,
    var hecho: Boolean = false,
    var creado: String = nowStr(),
    var actualizado: String = nowStr()
)

// ----- Utilidades -----
fun nowStr(): String = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))

fun readNonEmpty(prompt: String, allowEmpty: Boolean = false): String {
    while (true) {
        print(prompt)
        val s = readLine()?.trim() ?: ""
        if (allowEmpty || s.isNotEmpty()) return s
        println("→ No puede estar vacío.")
    }
}

fun readInt(prompt: String, allowEmpty: Boolean = false): Int? {
    while (true) {
        print(prompt)
        val s = readLine()?.trim() ?: ""
        if (allowEmpty && s.isEmpty()) return null
        val n = s.toIntOrNull()
        if (n != null) return n
        println("→ Ingresa un número válido.")
    }
}

fun readYesNo(prompt: String, default: Boolean? = null): Boolean {
    while (true) {
        val extra = when (default) {
            true -> " [S/n]"
            false -> " [s/N]"
            else -> " [s/n]"
        }
        print(prompt + extra + ": ")
        val s = readLine()?.trim()?.lowercase() ?: ""
        if (s == "s" || s == "si" || s == "sí") return true
        if (s == "n" || s == "no") return false
        if (default != null && s.isEmpty()) return default
        println("→ Responde s/si o n/no.")
    }
}

fun sanitizeField(s: String): String =
    s.replace("\t", " ").replace("\n", " ").trim()

// ----- Repositorio (archivo TSV) -----
class TaskRepo(private val filePath: String = "tasks.tsv") {
    private val file = File(filePath)
    private val header = listOf("id","titulo","descripcion","hecho","creado","actualizado").joinToString("\t")
    private val tasks: MutableList<Task> = mutableListOf()
    private var nextId: Int = 1

    init {
        if (!file.exists()) {
            file.writeText(header + System.lineSeparator())
        }
        load()
    }

    private fun parseLine(line: String): Task? {
        if (line.isBlank() || line.startsWith("id\t")) return null
        val cols = line.split("\t")
        if (cols.size < 6) return null
        val id = cols[0].toIntOrNull() ?: return null
        val titulo = cols[1]
        val descripcion = cols[2]
        val hecho = cols[3].toBooleanStrictOrNull() ?: (cols[3] == "1")
        val creado = cols[4]
        val actualizado = cols[5]
        return Task(id, titulo, descripcion, hecho, creado, actualizado)
    }

    private fun toLine(t: Task): String =
        listOf(t.id, sanitizeField(t.titulo), sanitizeField(t.descripcion),
               t.hecho.toString(), t.creado, t.actualizado).joinToString("\t")

    private fun load() {
        tasks.clear()
        if (!file.exists()) return
        file.useLines { seq ->
            seq.drop(0).forEach { line ->
                val task = parseLine(line)
                if (task != null) tasks.add(task)
            }
        }
        nextId = (tasks.maxOfOrNull { it.id } ?: 0) + 1
    }

    private fun saveAll() {
        val lines = buildString {
            appendLine(header)
            tasks.forEach { appendLine(toLine(it)) }
        }
        file.writeText(lines)
    }

    // ---- CRUD ----
    fun create(titulo: String, descripcion: String): Task {
        val t = Task(id = nextId++, titulo = titulo, descripcion = descripcion, hecho = false)
        tasks.add(t)
        saveAll()
        return t
    }

    fun listAll(): List<Task> = tasks.sortedBy { it.id }

    fun findById(id: Int): Task? = tasks.firstOrNull { it.id == id }

    fun update(id: Int, nuevoTitulo: String?, nuevaDesc: String?, nuevoHecho: Boolean?): Task? {
        val t = findById(id) ?: return null
        if (nuevoTitulo != null) t.titulo = nuevoTitulo
        if (nuevaDesc != null) t.descripcion = nuevaDesc
        if (nuevoHecho != null) t.hecho = nuevoHecho
        t.actualizado = nowStr()
        saveAll()
        return t
    }

    fun delete(id: Int): Boolean {
        val removed = tasks.removeIf { it.id == id }
        if (removed) saveAll()
        return removed
    }

    fun search(texto: String): List<Task> {
        val q = texto.lowercase()
        return tasks.filter {
            it.titulo.lowercase().contains(q) || it.descripcion.lowercase().contains(q)
        }.sortedBy { it.id }
    }

    fun toggleDone(id: Int): Task? {
        val t = findById(id) ?: return null
        t.hecho = !t.hecho
        t.actualizado = nowStr()
        saveAll()
        return t
    }
}

// ----- UI de consola -----
fun printMenu() {
    println("\n===== CRUD de Tareas =====")
    println("1) Listar tareas")
    println("2) Crear tarea")
    println("3) Ver tarea por ID")
    println("4) Actualizar tarea")
    println("5) Eliminar tarea")
    println("6) Marcar/Desmarcar como hecha")
    println("7) Buscar por texto")
    println("0) Salir")
}

fun printTask(t: Task) {
    println("--------------------------------------------------")
    println("ID: ${t.id}")
    println("Título: ${t.titulo}")
    println("Descripción: ${t.descripcion}")
    println("Hecha: ${if (t.hecho) "Sí" else "No"}")
    println("Creado: ${t.creado}")
    println("Actualizado: ${t.actualizado}")
}

fun main() {
    val repo = TaskRepo("tasks.tsv")
    println("App CRUD Kotlin (archivo: tasks.tsv)")

    while (true) {
        printMenu()
        when (readInt("Elige una opción: ") ?: -1) {
            1 -> {
                val all = repo.listAll()
                if (all.isEmpty()) {
                    println("No hay tareas aún.")
                } else {
                    println("Total: ${all.size}")
                    all.forEach { t ->
                        println("#${t.id} ${if (t.hecho) "✅" else "📝"} ${t.titulo} — ${t.descripcion.take(60)}")
                    }
                }
            }
            2 -> {
                val titulo = readNonEmpty("Título: ")
                val desc = readNonEmpty("Descripción: ")
                val t = repo.create(titulo, desc)
                println("✔ Creada tarea #${t.id}")
            }
            3 -> {
                val id = readInt("ID: ") ?: return
                val t = repo.findById(id)
                if (t == null) println("No existe la tarea $id") else printTask(t)
            }
            4 -> {
                val id = readInt("ID a actualizar: ") ?: return
                val t = repo.findById(id)
                if (t == null) {
                    println("No existe la tarea $id")
                } else {
                    println("Deja vacío lo que no quieras cambiar.")
                    val nuevoTitulo = readNonEmpty("Nuevo título (${t.titulo}): ", allowEmpty = true)
                    val nuevaDesc   = readNonEmpty("Nueva descripción (${t.descripcion}): ", allowEmpty = true)
                    val cambiarHecho = readYesNo("¿Cambiar estado hecho?", default = false)
                    val nuevoHecho = if (cambiarHecho) readYesNo("¿Marcar como hecha?", default = t.hecho) else null
                    val updated = repo.update(
                        id,
                        if (nuevoTitulo.isEmpty()) null else nuevoTitulo,
                        if (nuevaDesc.isEmpty()) null else nuevaDesc,
                        nuevoHecho
                    )
                    if (updated != null) {
                        println("✔ Actualizada:")
                        printTask(updated)
                    }
                }
            }
            5 -> {
                val id = readInt("ID a eliminar: ") ?: return
                if (repo.delete(id)) println("🗑 Eliminada la tarea $id") else println("No existe la tarea $id")
            }
            6 -> {
                val id = readInt("ID: ") ?: return
                val t = repo.toggleDone(id)
                if (t == null) println("No existe la tarea $id")
                else println("✔ Estado cambiado. Ahora hecho=${t.hecho}")
            }
            7 -> {
                val q = readNonEmpty("Buscar: ")
                val r = repo.search(q)
                if (r.isEmpty()) println("Sin resultados.")
                else r.forEach { println("#${it.id} ${if (it.hecho) "✅" else "📝"} ${it.titulo}") }
            }
            0 -> {
                println("¡Hasta luego!")
                exitProcess(0)
            }
            else -> println("Opción no válida.")
        }
    }
}
