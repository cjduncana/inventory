module Views.Body exposing (view)

import Html exposing (Html, div, text)
import Material.Options as Options
import Model exposing (Model, Msg)


view : List (Html Msg)
view =
    [ stylesheet ]


stylesheet : Html a
stylesheet =
    Options.stylesheet """
    .mdl-layout__drawer-button {
      display: flex;
      justify-content: center;
      align-items: center;
      margin: 8px 12px;
    }
  """
