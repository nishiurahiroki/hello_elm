module App exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List.Extra

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Todo =
  {
    content : String,
    isUpdateMode : Bool
  }

type alias Model =
  {
    inputedTodo : String,
    todoList : List Todo
  }

init : Model
init =
  {
    inputedTodo = "",
    todoList = []
  }

type Msg =
  InputTodo String |
  InputUpdateTodo Int String |
  AddTodo |
  DeleteTodo Int |
  TransFormInputText Int |
  UpdateTodo Int String


update : Msg -> Model -> Model
update msg model =
  case msg of
    InputTodo inputedTodo ->
      {
        model | inputedTodo = inputedTodo
      }
    InputUpdateTodo updateIndex inputedUpdateTodo ->
      {
        model |
          todoList =
            model.todoList
              |> List.Extra.updateAt updateIndex (\todo -> { todo | content = inputedUpdateTodo })
      }
    AddTodo ->
      {
        model |
          todoList = {
            content = model.inputedTodo,
            isUpdateMode = False
          } :: model.todoList,
          inputedTodo = ""
      }
    DeleteTodo deleteIndex ->
      {
        model |
          todoList = model.todoList |> List.Extra.removeAt deleteIndex
      }
    TransFormInputText transFormIndex ->
      {
        model |
          todoList =
            model.todoList
              |> List.map (\todo -> { todo | isUpdateMode = False })
              |> List.Extra.updateAt transFormIndex (\todo -> {todo | isUpdateMode = True})
      }
    UpdateTodo updateIndex content ->
      {
        model |
          todoList =
            model.todoList
              |> List.Extra.updateAt updateIndex (\todo -> { todo | content = content, isUpdateMode = False })
      }


view : Model -> Html Msg
view model =
  div []
    [
      p [] [
        input [ type_ "text", value model.inputedTodo , onInput InputTodo ] [],
        text " : TODO ",
        button [ onClick AddTodo ] [ text "追加" ]
      ],
      p [] (List.indexedMap viewTodo model.todoList)
    ]


viewTodo : Int -> Todo -> Html Msg
viewTodo index todo =
  if todo.isUpdateMode then
    p [] [
      input  [ type_ "text", value todo.content, onInput (InputUpdateTodo index) ] [ ],
      button [ onClick (UpdateTodo index todo.content) ] [ text "更新" ] -- TODO ↑のテキストが変更された時点でtodo.contentがupdateされてるからここでも更新してる意味あんまない?
    ]
  else
    p [] [
      span   [ onDoubleClick (TransFormInputText index) ] [ text todo.content ],
      button [ onClick (DeleteTodo index) ] [text "削除"]
    ]
