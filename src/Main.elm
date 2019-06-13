import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

import Route
import Session

-- MODEL

type Model
    = Home Session.Session
    | Signup Session.Session

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url nav_key =
  change_route (Just Route.Home) (Home (Session.Guest  nav_key))

-- UPDATE

type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangedUrl url ->
            change_route (Route.from_url url) model
        ClickedLink request ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl (Session.nav_key (to_session model)) (Url.toString url))
                Browser.External url ->
                    (model, Nav.load url)

change_route: Maybe Route.Route -> Model -> (Model, Cmd Msg)
change_route maybe_route model =
    case maybe_route of
        Nothing ->
            (Home (to_session model), Cmd.none)
        Just Route.Home ->
            (Home (to_session model), Cmd.none)
        Just Route.Signup ->
            (Signup (to_session model), Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
    let
        body =
            case model of
                Home _ ->
                    view_navbar
                Signup _ ->
                    view_navbar
        title =
            case model of 
                Home _ ->
                    "Home"
                Signup _ ->
                    "Signup"
    in
    {   title = title
    ,   body = [body]
    }


view_navbar: Html Msg
view_navbar =
    nav [class "navbar navbar-expand-lg navbar-light bg-light"] [
        a [class "navbar-brand", href "/"] [text "Navbar"],
        ul [class "navbar-nav mr-auto"] [
            li [class "nav-item"] [a [class "nav-link", href "/signup"] [text "Signup"]],
            li [class "nav-item"] [a [class "nav-link", href "#"] [text "Signin"]]
        ]
    ]

to_session: Model -> Session.Session
to_session model =
    case model of
        Home session ->
            session
        Signup session ->
            session

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
