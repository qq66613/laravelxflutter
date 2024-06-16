import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoappmy/controller/todo_controller.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController _todoController = Get.put(TodoController());
    final TextEditingController _controller = TextEditingController();
    final RxString errorMessage = ''.obs;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('My App Todo'),
          elevation: 1,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _todoController.getAllTodo();
              },
            ),
          ],
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                maxLines: 10,
                //keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Input Your activities'),
              ),
            ),
            Obx(
              () {
                return _todoController.loading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_controller.text.trim().isEmpty) {
                            errorMessage.value = 'Kegiatan tidak boleh kosong';
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(errorMessage.value),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          DateTime now = DateTime.now();
                          String formattedDateTime =
                              DateFormat('yyyy-MM-dd').format(now);
                          try {
                            await _todoController.insertTodo(
                              textdata: _controller.text.trim(),
                              created: formattedDateTime,
                            );
                            _todoController.getAllTodo();
                            _controller.clear();
                            errorMessage.value = '';
                          } catch (e) {
                            errorMessage.value = e.toString();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(errorMessage.value),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.save),
                        //icon: Icon(Icons.save),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50)),
                      );
              },
            ),

            //const SizedBox(
            // height: 50,
            //),
            //Obx(() {
            //return Text('Clicked :  ${_todoController.counter} times');
            //}),
            //const SizedBox(
            //height: 50,
            //),
            //TextButton(
            // onPressed: () {
            // _todoController.increment();
            //},
            //child: Text('Clik Me'))
            //Expanded(),
            Expanded(
              child: Obx(
                () {
                  return _todoController.loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _todoController.todos.value.length,
                          itemBuilder: (context, index) {
                            var todos = DateTime.now();
                            return Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueGrey.shade100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _todoController.todos.value[index].text
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _todoController
                                                .todos.value[index].complete ==
                                            1,
                                        onChanged: (value) async {
                                          await _todoController.updateTodo(
                                            _todoController
                                                .todos.value[index].id,
                                            _todoController
                                                .todos.value[index].text,
                                          );
                                          _todoController.getAllTodo();
                                        },
                                      ),
                                      Text(
                                        _todoController.todos.value[index]
                                                    .complete ==
                                                1
                                            ? 'Complete'
                                            : 'Uncomplete',
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          bool? confirmDelete =
                                              await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: Text(
                                                    'Are you sure you want to delete this todo?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirmDelete == true) {
                                            await _todoController.deleteTodo(
                                              _todoController
                                                  .todos.value[index].id,
                                            );
                                            _todoController.getAllTodo();
                                          }
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Created: ${DateFormat('yyyy-MM-dd').format(todos)}',
                                    //${_todoController.todos.value[index].createdAt}
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
