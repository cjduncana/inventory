module Views.Utilities exposing (emptyDiv, imageSrc, noWrap, square)

import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Material.Options as Options
import Models.Good as Good exposing (ImageURI)


imageSrc : ImageURI -> Attribute msg
imageSrc =
    Attr.src << Good.getImageURI


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


square : Int -> List (Options.Property c m)
square side =
    [ Options.css "max-height" <| toString side ++ "px"
    , Options.css "max-width" <| toString side ++ "px"
    ]
