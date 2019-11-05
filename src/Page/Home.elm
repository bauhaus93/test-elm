module Page.Home exposing (Model, Msg, init, subscriptions, to_session, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Session
import Url



-- Model


type alias Model =
    { session : Session.Session
    }


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      }
    , Cmd.none
    )


to_session : Model -> Session.Session
to_session model =
    model.session



-- Update


type Msg
    = Hello


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hello ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        div [ class "home" ]
            [ h1 [] [ text "SERS!" ]
            ]
    }
