module Page.NotFound exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- VIEW

view : { title : String, content : Html msg }
view =
    { title = "Page not found"
    , content =
        div [class "page-not-found"] [
            h1 [] [text "Page not found"]
        ]
    }