module Page.Signup exposing (Model, Msg, init, view, update, subscriptions, to_session)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit, onInput)
import Http
import Url
import Json.Decode exposing (Decoder, field, string)

import Session
import User
import Page

-- Model

type alias Model =
    { session: Session.Session
    , username: String
    , email: String
    , password: String
    , errors: List String
    }


init : Session.Session -> (Model, Cmd Msg)
init session =
    (   { session = session
        , username = ""
        , email = ""
        , password = ""
        , errors = []
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
    | GotReply (Result Http.Error User.User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        RequestSignup ->
            request_signup model
        UsernameChanged username ->
            ({ model | username = username }, Cmd.none)
        EmailChanged email ->
            ({ model | username = email }, Cmd.none)
        PasswordChanged password ->
            ({ model | username = password }, Cmd.none)
        GotReply result ->
            case result of
                Ok user ->
                    ({ model | session = Session.login user model.session }, Cmd.none)
                Err _ ->
                    ({ model | errors = "Could not create user" :: model.errors}, Cmd.none)


request_signup : Model -> (Model, Cmd Msg)
request_signup model =
    ( { model | errors = [] }
    , Http.post
        { url = "signup"
        , body = Http.emptyBody
        , expect = Http.expectJson GotReply User.decoder
        }
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
        div [class "container"] [
            (Page.view_errors model.errors),
            h1 [][text "Sign up"],
            div [class "input-group"] [
                Html.form[onSubmit RequestSignup] [
                    (user_entry_field "Name" "name"),
                    (email_entry_field "Email" "email"),
                    (password_entry_field "Password" "password"),
                    (submit_button "Create")
                ]
            ]
        ]
    }

submit_button: String -> Html Msg
submit_button caption =
    div [class "row"] [ div [class "col pt-2"] [button [type_ "submit", class "btn btn-primary btn-block"][text caption]]]

entry_field: String -> String -> String -> (String -> Msg) -> Html Msg
entry_field name field_id field_type change_msg =
    div [] [
        div [class "row"] [ div [class "col"] [text name]],
        div [class "row"] [ div [class "col pb-2", onInput change_msg] [input [id field_id, type_ field_type][]]]
    ]

user_entry_field: String -> String -> Html Msg
user_entry_field name id =
    entry_field name id "text" UsernameChanged

email_entry_field: String -> String -> Html Msg
email_entry_field name id =
    entry_field name id "email" EmailChanged

password_entry_field: String -> String -> Html Msg
password_entry_field name id =
    entry_field name id "password" PasswordChanged