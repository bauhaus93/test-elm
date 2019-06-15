import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Route
import Session
import Page

import Page.Home as Home
import Page.Empty as Empty
import Page.NotFound as NotFound
import Page.Signup as Signup

-- Created based on https://github.com/rtfeldman/elm-spa-example


-- MODEL

type Model
    = Redirect Session.Session
    | NotFound Session.Session
    | Home Home.Model
    | Signup Signup.Model

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url nav_key =
  change_route (Just Route.Home) (Redirect (Session.Guest nav_key))

to_session : Model -> Session.Session
to_session model =
    case model of
        Redirect session ->
            session
        NotFound session ->
            session
        Home home ->
            Home.to_session home
        Signup signup ->
            Signup.to_session signup 


-- UPDATE

type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg Home.Msg
    | GotSignupMsg Signup.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model) of
        (ChangedUrl url, _) ->
            change_route (Route.from_url url)  model
        (ClickedLink request, _) ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl (Session.nav_key (to_session model)) (Url.toString url))
                Browser.External url ->
                    (model, Nav.load url)
        (GotHomeMsg sub_msg, Home home) ->
            Home.update sub_msg home
            |> update_with Home GotHomeMsg model
        (GotSignupMsg sub_msg, Signup signup) ->
            Signup.update sub_msg signup
            |> update_with Signup GotSignupMsg model
        (_, _) ->
            (model, Cmd.none)

change_route : Maybe Route.Route -> Model -> (Model, Cmd Msg)
change_route maybe_route model =
    let
        session =
            to_session model
    in
    case maybe_route of
        Nothing ->
            (NotFound session, Cmd.none)
        Just Route.Home ->
            Home.init session
            |> update_with Home GotHomeMsg model
        Just Route.Signup ->
            Signup.init session
            |> update_with Signup GotSignupMsg model

update_with : (sub_model -> Model) -> (sub_msg -> Msg) -> Model -> (sub_model, Cmd sub_msg) -> (Model, Cmd Msg)
update_with to_model to_msg model (sub_model, sub_cmd) =
    (to_model sub_model
    , Cmd.map to_msg sub_cmd
    )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none
        Redirect _ ->
            Sub.none
        Home home ->
            Sub.map GotHomeMsg (Home.subscriptions home)
        Signup signup ->
            Sub.map GotSignupMsg (Signup.subscriptions signup)

-- VIEW

view : Model -> Browser.Document Msg
view model =
    let 
        view_page page to_msg config =
            let { title, body } =
                    Page.view page (to_session model) config
            in
                { title = title
                , body = List.map (Html.map to_msg) body
                }
    in
    case model of
        Redirect _ ->
            Page.view Page.Other (to_session model) Empty.view
        NotFound _ ->
            Page.view Page.Other (to_session model) NotFound.view
        Home home ->
            view_page Page.Home GotHomeMsg (Home.view home)
        Signup signup ->
            view_page Page.Signup GotSignupMsg (Signup.view signup)



-- MAIN

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
