<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\TodoRequest;
use App\Http\Resources\TodoResource;
use Illuminate\Http\Request;
use App\Models\Todo;

class TodoController extends Controller
{
    public function index(){
        
        $todos = Todo::latest()->get();

        return response([
            'massage' => 'Is success',
            'todo' => TodoResource::collection($todos),
        ], 200);
    }

    public function store(TodoRequest $todoRequest){
        $todoRequest->validated();

        $saveData = Todo::create([
            'text' => $todoRequest->text,
             //$todoRequest->complete,
            'complete' => 0,
        ]);

        if($saveData){
            return response([
                'message' => 'Success',
                'Todo' => new TodoResource($saveData)
            ], 201);
        }else{
            return response([
                'message' => 'failed',
                
            ], 500);
        };
    }

    public function update(Request $todoRequest, Todo $todo){

        //$todoRequest->validated();

        $upadateData = $todo->update([
           'text' => empty($todoRequest->text) ? $todo->text : $todoRequest->text,
           'complete' => $todo->complete == 1?0 :1, 
        ]);

        if($upadateData){
            return response([
                'message' => 'Success',
                'Todo' => $upadateData
            ], 200);
        }else{
            return response([
                'message' => 'failed',
                
            ], 500);
        };
    }

    public function delete($todo){

        if(Todo::find($todo)){
        $deleteData = Todo::where('id', $todo)->delete();
         if($deleteData){
            return response([
                'message' => 'Success',
                //'Todo' => $deleteData
            ], 200);
        }else{
            return response([
                'message' => 'failed',
                
            ], 500);
        };
       }else{
            return response([
                'message' => 'Content Not Found',
                
            ], 400);
       }
    }
}