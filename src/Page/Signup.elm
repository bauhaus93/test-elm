module Page.Signup exposing (Model, Msg, init, subscriptions, to_session, update, view)

import Api.Login
import Api.Session
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Http
import HttpRequest
import Json.Decode exposing (Decoder, field, string)
import Page
import Page.Fields exposing (email_entry_field, password_entry_field, submit_button, user_entry_field)
import Route
import Session
import Url



-- Model


type alias Model =
    { session : Session.Session
    , username : String
    , email : String
    , password : String
    , error_list : List String
    , success_list : List String
    }


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , username = ""
      , email = ""
      , password = ""
      , error_list = []
      , success_list = []
      }
    , Cmd.none
    )


to_session : Model -> Session.Session
to_session model =
    model.session



-- Update


type Msg
    = RequestSignup
    | UsernameChanged String
    | EmailChanged String
    | PasswordChanged String
    | GotSignUpReply (Result Http.Error Api.Session.Session)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestSignup ->
            request_signup model

        UsernameChanged username ->
            ( { model | username = username }, Cmd.none )

        EmailChanged email ->
            ( { model | email = email }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        GotSignUpReply result ->
            case HttpRequest.handle_reply result model update_model_session of
                Ok updated_model ->
                    ( updated_model
                    , Route.replace_url (Session.get_nav_key model.session) Route.Home
                    )

                Err e ->
                    ( { model | error_list = String.concat [ "Could not create user: ", e ] :: model.error_list }, Cmd.none )


update_model_session : Model -> Api.Session.Session -> Model
update_model_session model api_session =
    let
        new_session =
            Session.login api_session model.session

        success_list =
            "Sucessfully logged in" :: model.success_list
    in
    { model | session = new_session, success_list = success_list }


login_from_model : Model -> Api.Login.Login
login_from_model model =
    { user =
        { name = model.username
        , email = model.email
        }
    , password = model.password
    }


request_signup : Model -> ( Model, Cmd Msg )
request_signup model =
    ( { model | error_list = [], success_list = [] }
    , HttpRequest.create_post "api/signup" model login_from_model GotSignUpReply Api.Login.encode Api.Session.decoder
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Signup"
    , content =
        div [ class "container" ]
            [ Page.view_errors model.error_list
            , Page.view_successes model.success_list
            , h1 [] [ text "Sign up" ]
            , div [ class "input-group" ]
                [ Html.form [ onSubmit RequestSignup ]
                    [ user_entry_field "Name" "name" UsernameChanged
                    , email_entry_field "Email" "email" EmailChanged
                    , password_entry_field "Password" "password" PasswordChanged
                    , submit_button "Create"
                    ]
                ]
            ]
    }
