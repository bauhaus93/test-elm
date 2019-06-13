module Page exposing (Page(..), view, view_errors)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

type Page
    = Other
    | Home
    | Signup

view : Page -> { title: String, content: Html msg } -> Browser.Document msg
view page { title, content} =
    { title = title
    , body = view_navbar :: [content]
    }


view_navbar : Html msg
view_navbar =
    nav [class "navbar navbar-expand-lg navbar-light bg-light"] [
        a [class "navbar-brand", href "/"] [text "Navbar"],
        ul [class "navbar-nav mr-auto"] [
            li [class "nav-item"] [a [class "nav-link", href "/signup"] [text "Signup"]]
        ]
    ]

view_errors : List String -> Html msg
view_errors errors = 
    if List.isEmpty errors  then Html.text ""
    else
     div [class "alert alert-danger alert-dismissible"]
     <| List.map (\e -> p [] [text e]) errors


