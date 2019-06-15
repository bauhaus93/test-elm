module Page.Signin exposing (Model, Msg, init, view, update, subscriptions, to_session)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Http
import Url
import Json.Decode exposing (Decoder, field, string)

import Session
import Page
import Route

import Api.Session
import Api.Login

import Page.Fields exposing (user_entry_field, password_entry_field, submit_button)

-- Model

type alias Model =
    { session: Session.Session
    , username: String
    , password: String
    , error_list: List String
    }


init : Session.Session -> (Model, Cmd Msg)
init session =
    (   { session = session
        , username = ""
        , password = ""
        , error_list = []
        }
    , Cmd.none
    )

to_session : Model -> Session.Session
to_session model =
    model.session

-- Update

type Msg
    = RequestSignin
    | UsernameChanged String
    | PasswordChanged String
    | GotReply (Result Http.Error Api.Session.Session)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        RequestSignin ->
            request_signin model
        UsernameChanged username ->
            ({ model | username = username }, Cmd.none)
        PasswordChanged password ->
            ({ model | password = password }, Cmd.none)
        GotReply result ->
            case result of
                Ok api_session ->
                    let
                        new_session = (Session.login api_session) model.session
                    in
                    ({ model | session = new_session }, Route.replace_url (Session.nav_key new_session) Route.Home)
                Err _ ->
                    ({ model | error_list = "Could not sign in" :: model.error_list}, Cmd.none)


request_signin : Model -> (Model, Cmd Msg)
request_signin model =
    ( { model | error_list = [] }
    , Http.post
        { url = Route.to_string Route.Signin
        , body = create_request model
        , expect = Http.expectJson GotReply Api.Session.decoder
        }
    )

create_request: Model -> Http.Body
create_request model =
    let
        login =
            { user = { name = model.username, email = "" }
            , password = model.password
            }
    in
    Http.jsonBody (Api.Login.encode login)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Signin"
    , content =
        div [class "container"] [
            (Page.view_errors model.error_list),
            h1 [][text "Sign in"],
            div [class "input-group"] [
                Html.form[onSubmit RequestSignin] [
                    (user_entry_field "Name" "name" UsernameChanged),
                    (password_entry_field "Password" "password" PasswordChanged),
                    (submit_button "Login")
                ]
            ]
        ]
    }
