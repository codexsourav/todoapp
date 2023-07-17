import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController inputText = TextEditingController();
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text(
        "Add Task",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        addToTask(inputText.text);
        Navigator.of(context).pop();
        inputText.text = '';
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Add New ToDo"),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      content: TextField(
        controller: inputText,
        maxLines: 5,
        maxLength: 100,
        cursorColor: Colors.black,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Write Task..",
          filled: true,
          fillColor: Color.fromARGB(255, 248, 248, 248),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  LocalStorage storage = LocalStorage('tasks.json');

  List tasks = [];

  setTasks() {
    storage.ready.then((value) {
      var data = storage.getItem('todo');

      if (data == null || data.length == 0) {
        storage.setItem('todo', []);
        setState(() {
          tasks = [];
        });
      } else {
        setState(() {
          tasks = data;
        });
      }
    });
  }

  addToTask(task) {
    List<Map> newtask = [
      ...tasks,
      {
        "text": task,
        "id": UniqueKey().toString(),
        "chack": false,
      }
    ];
    storage.setItem('todo', newtask);
    setState(() {
      tasks = newtask;
    });
  }

  chackeTask(index, action) {
    setState(() {
      tasks[index]['chack'] = action;
      storage.setItem('todo', tasks);
    });
  }

  deleteTodo(index) {
    setState(() {
      tasks.removeAt(index);
      storage.setItem('todo', tasks);
    });
  }

  @override
  void initState() {
    super.initState();
    setTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Taskify",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: tasks.isNotEmpty
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (d) {
                    setState(() {
                      deleteTodo(index);
                    });
                  },
                  background: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Color.fromARGB(192, 244, 67, 54),
                      ),
                    ),
                  ),
                  child: TaskBox(
                    task: tasks[index]['text'],
                    ischacked: tasks[index]['chack'],
                    setChack: () {
                      chackeTask(index, !tasks[index]['chack']);
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text(
              'No Tasks Clear',
              style: TextStyle(color: Colors.black),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAlertDialog(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
    );
  }
}

// task box

class TaskBox extends StatefulWidget {
  final task;
  final setChack;
  final ischacked;
  const TaskBox(
      {super.key, required this.task, this.setChack, this.ischacked = false});

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.setChack,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(87, 158, 158, 158),
              spreadRadius: 1,
              blurRadius: 4.0,
              offset: Offset(1, 2),
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              blurRadius: 6,
              offset: Offset(-3, -4),
            )
          ],
        ),
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Text(
                  widget.task,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: widget.ischacked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      color: widget.ischacked
                          ? const Color.fromARGB(255, 99, 99, 99)
                          : Colors.black),
                ),
              ),
              RoundCheckBox(
                size: 28,
                checkedColor: const Color.fromARGB(174, 0, 64, 241),
                uncheckedColor: const Color.fromARGB(255, 236, 236, 236),
                borderColor: const Color.fromARGB(255, 255, 255, 255),
                isRound: true,
                isChecked: widget.ischacked,
                onTap: (selected) {
                  widget.setChack();
                },
              ),
            ]),
      ),
    );
  }
}
