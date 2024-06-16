<template>
  
    <h1>Data dari API</h1>
    <div class="table-container">
    <table >
      <thead>
        <tr>
          <th>No.</th>
          <!--<th>ID</th>-->
          <th>Kegiatan</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
      <!-----<div v-for="todo in todos" :key="todo.id">
        <strong>Kegiatan:</strong> {{ todo.text  }} ,
        <strong>Status:</strong> {{ todo.complete ? 'Completed' : 'Uncomplete'}}
      </div>-->
      <tr v-for="(todo, index) in todos" :key="todo.id" :class="getTodoClass(todo)">
          <td>{{ index + 1 }}</td>
          <!--<td>{{ todo.id }}</td>-->
          <td>{{ todo.text }}</td>
          <td>{{ todo.complete ? 'Completed' : 'Uncomplete' }}</td>
          <td><button @click="deleteTodo(todo.id)">Delete</button></td>
        </tr>
      </tbody>
    </table>
  </div>
    <button @click="refreshData" style="margin: 50px;">Reload</button>
      <h2>Summary</h2>
    <!----<p>Completed: {{ completedCount }}</p>
    <p>Uncompleted: {{ uncompletedCount }}</p>-->
    <div class="table-container">
    <table>
      <thead>
        <tr>
          <th>Status</th>
          <th>Count</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Completed</td>
          <td>{{ completedCount }}</td>
        </tr>
        <tr>
          <td>Uncompleted</td>
          <td>{{ uncompletedCount }}</td>
        </tr>
      </tbody>
    </table>
    </div>
</template>

<script>
//import { ref, onMounted,} from 'vue';
import axios from 'axios';

export default {
  //name: 'DataDisplay',
  data() {
    return{
      todos: []
    }
  },
  mounted(){
    this.refreshData();
    //const base_url = "http://localhost:80"; 
    //axios.get('http://192.168.1.6/api/todos/')
    //.then(response =>this.todos = response.data)
    //.then(response =>{
        //this.todos = response.data.todo
      //})
  },
  computed: {
    completedCount() {
      return this.todos.filter(todo => todo.complete).length;
    },
    uncompletedCount() {
      return this.todos.filter(todo => !todo.complete).length;
    }
  },
  methods: {
    async refreshData() {
      try {
        const response = await axios.get('http://192.168.1.6/api/todos/');
        this.todos = response.data.todo;
      } catch (error) {
        console.error("There was an error fetching the todos!", error);
      }
    },
    async deleteTodo(id) {
      try {
        await axios.get(`http://192.168.1.6/api/todos/${id}`);
        this.todos = this.todos.filter(todo => todo.id !== id);
        this.refreshData();
      } catch (error) {
        console.error("There was an error deleting the todo!", error);
      }
    },
    getTodoClass(todo) {
      return {
        'completed-todo': todo.complete,
        'uncompleted-todo': !todo.complete,
      };
    },
    //deleteTodo : async (id) => {
      //await axios.get(`http://192.168.1.6/api/todos/${id}`)
       // .then(() => {
        //  this.todos = this.todos.filter(todo => todo.id !== id);
         // this.refreshData();
       // })
       // .catch(error => {
          //console.error("There was an error deleting the todo!", error);
        //});
    
  }



}
</script>

<style>
.container {
  padding: 20px;
  
}

.table-container {
  max-width: 100%;
  overflow-x: auto;
  border-radius: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  
}

th, td {
  padding: 8px 12px;
  border: 1px solid #ddd;
  text-align: left;
}

th {
  background-color: #f4f4f4;
}

.reload-button {
  margin: 50px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}

.completed-todo {
  background-color: #8cd39d;
}

.uncompleted-todo {
  background-color: #d3df6e;
}

@media (max-width: 600px) {
  th, td {
    font-size: 14px;
  }

  .reload-button {
    font-size: 14px;
  }
}
</style>