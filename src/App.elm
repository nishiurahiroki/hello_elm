module App exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List.Extra

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
  AddTodo |
  DeleteTodo Int

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
    DeleteTodo deleteIndex ->
      {
        model |
          todoList = List.Extra.removeAt deleteIndex model.todoList
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
      p [] (List.indexedMap viewTodo model.todoList)
    ]

viewTodo : Int -> String -> Html Msg
viewTodo index todo =
  p [] [
    text todo,
    button [ onClick (DeleteTodo index) ] [text "削除"]
  ]