import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Thread exposing (..)

-- MODEL

type Model
    = ShowThreadList (List Thread)

init : Model
init =
    ShowThreadList initial_threadlist

initial_threadlist : List Thread
initial_threadlist = 
        Thread 0 "Cool thread." [] ::
        Thread 1 "Another thread." [] ::
        Thread 2 "Boring thread" [] :: []

-- UPDATE

type Msg
    = NoOp

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW

view : Model -> Html msg
view model =
    case model of
        ShowThreadList thread_list ->
            view_thread_list thread_list

view_thread_list : List Thread -> Html msg
view_thread_list thread_list =
    div [class "container"] [
        h1 [] [text "Latest threads:"],
        div [] (List.map (\e -> view_thread_entry e) thread_list)
    ]

view_thread_entry : Thread -> Html msg
view_thread_entry thread =
    div [class "row"] [
        div [class "col"] [text thread.name]
    ]

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }