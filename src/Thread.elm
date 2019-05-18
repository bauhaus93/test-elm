module Thread exposing (..)

import Html exposing (Html, h1, form, div, text, input, button)
import Html.Attributes exposing (id, type_, class, style)

import Posting exposing (..)

type alias Thread =
    { id: Int
    , name: String
    , postings: List Posting
    }


