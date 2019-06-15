module Page exposing (Page(..), view, view_errors, view_successes)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

import Session

type Page
    = Other
    | Home
    | Signup

view : Page -> Session.Session -> { title: String, content: Html msg } -> Browser.Document msg
view page session { title, content } =
    { title = title
    , body = view_navbar session :: [content]
    }


view_navbar : Session.Session -> Html msg
view_navbar session =
    nav [class "navbar navbar-expand-lg navbar-light bg-light"] [
        a [class "navbar-brand", href "/"] [text "Navbar"],
        ul [class "navbar-nav mr-auto"] [
            view_session_status session,
            li [class "nav-item"] [a [class "nav-link", href "/signup"] [text "Signup"]]
        ]
    ]

view_session_status : Session.Session -> Html msg
view_session_status session =
    case session of
        Session.Guest _ ->
            li [class "nav-item nav-link"] [text "Not logged in"]
        Session.LoggedIn _ _ ->
            li [class "nav-item nav-link"] [text "Logged in"]   

view_errors : List String -> Html msg
view_errors error_list = 
    if List.isEmpty error_list  then Html.text ""
    else
     div [class "alert alert-danger alert-dismissible"]
     <| List.map (\e -> p [] [text e]) error_list

view_successes : List String -> Html msg
view_successes success_list = 
    if List.isEmpty success_list  then Html.text ""
    else
     div [class "alert alert-success alert-dismissible"]
     <| List.map (\e -> p [] [text e]) success_list


