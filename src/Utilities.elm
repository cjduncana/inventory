module Utilities exposing (..)

import RemoteData exposing (RemoteData)


isNotSuccess : RemoteData e a -> Bool
isNotSuccess =
    not << RemoteData.isSuccess
