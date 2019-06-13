module Session exposing (Session(..), user, nav_key)
import Browser.Navigation as Nav

import User

type Session
    = LoggedIn Nav.Key User.User
    | Guest Nav.Key


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