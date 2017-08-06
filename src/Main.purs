module Main (main) where

import Control.Monad.Aff as Aff
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Console as Console
import FFI.Elm as Elm
import FFI.Handlers as Handlers
import Node.FS (FS)
import Prelude (Unit, bind, unit, (<$))

main :: forall eff. Eff (console :: CONSOLE, fs :: FS | eff) Unit
main = do
  app <- Elm.startElm
  unit <$ Aff.runAff
    Console.errorShow
    (Handlers.createHandlers app)
    Handlers.createModels
