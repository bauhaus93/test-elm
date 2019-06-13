module Page.Home exposing (Model, Msg, init, view, update, subscriptions, to_session)

import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Session

-- Model

type alias Model =
    {   session: Session.Session
    }


init : Session.Session -> (Model, Cmd Msg)
init session =
    (   {   session = session
        }
    , Cmd.none
    )

to_session : Model -> Session.Session
to_session model =
    model.session

-- Update

type Msg
    = Hello

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Hello ->
            (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        div [class "home"] [
            h1 [] [text "SERS!"]
        ]
    }