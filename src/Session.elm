module Session exposing (Session(..), login, user, nav_key)
import Browser.Navigation as Nav

import User

type Session
    = LoggedIn Nav.Key User.User
    | Guest Nav.Key

login : User.User -> Session -> Session
login user_ session =
    LoggedIn (nav_key session) user_


user: Session -> Maybe User.User
user session =
    case session of
        LoggedIn _ user_ ->
            Just user_
        Guest _ ->
            Nothing

nav_key: Session -> Nav.Key
nav_key session =
    case session of
        LoggedIn key _ ->
            key
        Guest key ->
            key