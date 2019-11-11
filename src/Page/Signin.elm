module Page.Signin exposing (Model, Msg, init, subscriptions, to_session, update, view)

import Api.Login
import Api.Session
import Api.User
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Http
import HttpRequest
import Json.Decode exposing (Decoder, field, string)
import Page
import Page.Fields exposing (password_entry_field, submit_button, user_entry_field)
import Route
import Session
import Url



-- Model


type alias Model =
    { session : Session.Session
    , username : String
    , password : String
    , error_list : List String
    , success_list: List String
    }


init : Session.Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , username = ""
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
    = RequestSignin
    | RequestUser
    | UsernameChanged String
    | PasswordChanged String
    | GotSignInReply (Result Http.Error Api.Session.Session)
    | GotUserInfoReply (Result Http.Error Api.User.User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestSignin ->
            request_signin model

        RequestUser ->
            request_user_info model

        UsernameChanged username ->
            ( { model | username = username }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        GotSignInReply result ->
            case HttpRequest.handle_reply result of
                Ok api_session ->
                    let
                        new_session =
                            Session.login api_session model.session
                    in
                    { model | session = new_session, success_list = "Successfully signed in" :: model.success_list }
                        |> request_user_info

                Err e ->
                    ( { model | error_list = String.concat [ "Could not sign in: ", e ] :: model.error_list }, Cmd.none )

        GotUserInfoReply result ->
            case HttpRequest.handle_reply result of
                Ok user ->
                    let
                        updated_session =
                            Session.update_user model.session user
                    in
                    ( { model | session = updated_session }
                    , Cmd.none
                    )

                Err e ->
                    ( { model | error_list = String.concat [ "Could not get user info: ", e ] :: model.error_list }, Cmd.none )


login_from_model : Model -> Api.Login.Login
login_from_model model =
    { user =
        { name = model.username
        , email = ""
        }
    , password = model.password
    }


session_from_model : Model -> Api.Session.Session
session_from_model model =
    Session.get_session model.session


request_signin : Model -> ( Model, Cmd Msg )
request_signin model =
    ( { model | error_list = [], success_list = [] }
    , HttpRequest.create_post "api/signin" model login_from_model GotSignInReply Api.Login.encode Api.Session.decoder
    )


request_user_info : Model -> ( Model, Cmd Msg )
request_user_info model =
    ( model
    , HttpRequest.create_post "api/sessionuser" model session_from_model GotUserInfoReply Api.Session.encode Api.User.decoder
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Signin"
    , content =
        div [ class "container" ]
            [ Page.view_errors model.error_list
            , Page.view_successes model.success_list
            , h1 [] [ text "Sign in" ]
            , div [ class "input-group" ]
                [ Html.form [ onSubmit RequestSignin ]
                    [ user_entry_field "Name" "name" UsernameChanged
                    , password_entry_field "Password" "password" PasswordChanged
                    , submit_button "Login"
                    ]
                ]
            ]
    }
