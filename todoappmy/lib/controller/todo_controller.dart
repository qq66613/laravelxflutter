import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:todoappmy/constant.dart';
import 'package:todoappmy/model/todo_model.dart';

class TodoController extends GetxController {
  RxBool loading = false.obs;
  Rx<List<Todo>> todos = Rx<List<Todo>>([]);
  //var counter = 0.obs;

  //increment() {
  //counter++;
  //}
  @override
  void onInit() {
    super.onInit();
    getAllTodo();
  }

  Future getAllTodo() async {
    try {
      todos.value.clear();
      loading.value = true;
      var response = await http.get(
        url,
        headers: {
          'Accept': 'Application/json',
        },
      );
      if (response.statusCode == 200) {
        loading.value = false;
        //print(json.decode(response.body));
        final content = json.decode(response.body)['todo'];
        for (var item in content) {
          todos.value.add(Todo.fromJson(item));
        }
      } else {
        loading.value = true;
        print(json.decode(response.body));
      }
    } catch (e) {
      loading.value = false;
      print(e.toString());
    }
  }

  Future updateTodo(id, text) async {
    try {
      var request = await http.post(
        Uri.parse('http://10.16.52.73:80/api/todos/$id'),
        headers: {
          'Accept': 'Application/json',
        },
        body: {
          text: text,
        },
      );
      if (request.statusCode == 200) {
        print('Updated');
      } else {
        print(json.decode(request.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future insertTodo({required String textdata}) async {
    var data = {
      'text': textdata,
    };
    try {
      loading.value = true;
      var request = await http.post(
        //Uri.parse('http://192.168.1.5:80/api/todos/'),
        url,
        headers: {
          'Accept': 'Application/json',
        },
        body: data,
      );
      if (request.statusCode == 201) {
        print('Add Success');
        loading.value = false;
      } else {
        loading.value = false;
        print(json.decode(request.body));
      }
    } catch (e) {
      loading.value = false;
      print(e.toString());
    }
  }

  Future deleteTodo(id) async {
    try {
      var request = await http.get(
        Uri.parse('http://10.16.52.73:80/api/todos/$id'),
        headers: {
          'Accept': 'Application/json',
        },
      );
      if (request.statusCode == 200) {
        print('Deleted');
      } else {
        print('Not Deleted');
        print(json.decode(request.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
