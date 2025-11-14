import 'package:flutter/cupertino.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tareas = [
      {"nombre": "Trabajo 1", "prioridad": "Alta"},
      {"nombre": "Proyecto X", "prioridad": "Media"},
      {"nombre": "Revisión final", "prioridad": "Alta"},
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("REGISTRO DE TAREAS"),
        backgroundColor: const Color(0xFF000000),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text("MENÚ", style: TextStyle(color: CupertinoColors.activeBlue)),
          onPressed: () => Navigator.pushNamed(context, '/menu'),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CupertinoSlidingSegmentedControl<String>(
                groupValue: "Normal",
                children: const {
                  "Normal": Text("Normal"),
                  "Alta": Text("Alta"),
                },
                onValueChanged: (_) {},
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, i) {
                    final t = tareas[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t["nombre"]!,
                            style: const TextStyle(color: CupertinoColors.white),
                          ),
                          Text(
                            t["prioridad"]!,
                            style: const TextStyle(
                              color: CupertinoColors.systemPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
