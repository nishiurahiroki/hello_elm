module App exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  {
    todo : String,
    todoList : List String
  }

init : Model
init =
  {
    todo = "",
    todoList = []
  }

type Msg =
  InputTodo String |
  AddTodo

update : Msg -> Model -> Model
update msg model =
  case msg of
    InputTodo inputedTodo ->
      {
        model | todo = inputedTodo
      }
    AddTodo ->
      {
        model |
          todoList = model.todo :: model.todoList,
          todo = ""
      }

view : Model -> Html Msg
view model =
  div []
    [
      p [] [
        input [ type_ "text", value model.todo , onInput InputTodo ] [],
        text " : TODO ",
        button [ onClick AddTodo ] [ text "追加" ]
      ],
      p [] (List.map viewTodo model.todoList)
    ]

viewTodo : String -> Html Msg
viewTodo todo =
  p [] [text todo]