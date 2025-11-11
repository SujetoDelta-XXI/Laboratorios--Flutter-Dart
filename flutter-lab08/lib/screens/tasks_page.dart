import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tareas = [
      {"nombre": "Trabajo 1", "prioridad": "Alta"},
      {"nombre": "Proyecto X", "prioridad": "Media"},
      {"nombre": "Revisión final", "prioridad": "Alta"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRO DE TAREAS"),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/menu'),
            child: const Text("MENÚ", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.cyanAccent),
              items: const [
                DropdownMenuItem(value: "Normal", child: Text("Normal")),
                DropdownMenuItem(value: "Alta", child: Text("Alta")),
              ],
              value: "Normal",
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, i) {
                  final t = tareas[i];
                  return ListTile(
                    title: Text(t["nombre"]!,
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(
                      t["prioridad"]!,
                      style: const TextStyle(color: Colors.pinkAccent),
                    ),
                    tileColor: Colors.black.withOpacity(0.3),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
