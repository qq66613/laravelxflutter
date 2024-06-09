import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoappmy/controller/todo_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController _todoController = Get.put(TodoController());
    final TextEditingController _controller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('My App Todo'),
          elevation: 1,
          centerTitle: true,
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
                          await _todoController.insertTodo(
                            textdata: _controller.text.trim(),
                          );
                          _todoController.getAllTodo();
                          _controller.clear();
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () {
                        return _todoController.loading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _todoController.todos.value.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(15),
                                    height: 100,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blueGrey.shade100,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _todoController.todos.value[index].text
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Checkbox(
                                            value: _todoController
                                                        .todos
                                                        .value[index]
                                                        .complete ==
                                                    1
                                                ? true
                                                : false,
                                            onChanged: (value) async {
                                              await _todoController.updateTodo(
                                                  _todoController
                                                      .todos.value[index].id,
                                                  _todoController
                                                      .todos.value[index].text);
                                              _todoController.getAllTodo();
                                            },
                                          ),
                                          Text(
                                            _todoController.todos.value[index]
                                                        .complete ==
                                                    1
                                                ? 'Complete'
                                                : 'UnComplate',
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                await _todoController
                                                    .deleteTodo(_todoController
                                                        .todos.value[index].id);
                                                _todoController.getAllTodo();
                                              },
                                              child: Text('delete'))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
