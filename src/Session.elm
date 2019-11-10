module Session exposing (Session(..), get_nav_key, get_session, get_session_username, login, update_user)

import Api.Session as ApiSession
import Api.User as ApiUser
import Browser.Navigation as Nav


type alias SessionInfo =
    { nav_key : Nav.Key
    , session : ApiSession.Session
    , user : ApiUser.User
    }


type Session
    = LoggedIn SessionInfo
    | Guest Nav.Key


update_user : Session -> ApiUser.User -> Session
update_user session new_user =
    case session of
        LoggedIn session_info ->
            let
                new_session_info =
                    { session_info | user = new_user }
            in
            LoggedIn new_session_info

        Guest nav_key ->
            Guest nav_key


login : ApiSession.Session -> Session -> Session
login new_session old_session =
    LoggedIn
        { nav_key = get_nav_key old_session
        , session = new_session
        , user =
            { name = ""
            , email = ""
            }
        }


get_session_username : Session -> String
get_session_username session =
    case session of
        LoggedIn session_info ->
            session_info.user.name

        Guest _ ->
            "Guest"


get_session : Session -> ApiSession.Session
get_session session =
    case session of
        LoggedIn session_info ->
            session_info.session

        Guest key ->
            { id = "" }


get_nav_key : Session -> Nav.Key
get_nav_key session =
    case session of
        LoggedIn session_info ->
            session_info.nav_key

        Guest key ->
            key
