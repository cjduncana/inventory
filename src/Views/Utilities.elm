module Views.Utilities exposing (emptyDiv, noWrap)

import Html exposing (Html)
import Material.Options as Options


noWrap : Float -> List (Options.Property c m)
noWrap height =
    [ Options.css "height" <| toString height ++ "em"
    , Options.css "overflow-x" "hidden"
    , Options.css "white-space" "nowrap"
    , Options.css "text-overflow" "ellipsis"
    ]


emptyDiv : Html msg
emptyDiv =
    Html.div [] []
