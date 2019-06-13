module Session exposing (Session(..), login, nav_key)
import Browser.Navigation as Nav

import Api.Session

type Session
    = LoggedIn Nav.Key Api.Session.Session
    | Guest Nav.Key

login : Api.Session.Session -> Session -> Session
login user_ session =
    LoggedIn (nav_key session) user_


nav_key: Session -> Nav.Key
nav_key session =
    case session of
        LoggedIn key _ ->
            key
        Guest key ->
            key