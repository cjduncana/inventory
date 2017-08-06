module FFI.Elm (startElm) where

import Control.Monad.Eff (Eff)
import FFI.Types (App)

foreign import startElm :: forall eff. Eff eff App
