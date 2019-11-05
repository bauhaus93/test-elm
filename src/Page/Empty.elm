module Page.Empty exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : { title : String, content : Html msg }
view =
    { title = ""
    , content = text ""
    }
