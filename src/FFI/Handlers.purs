module FFI.Handlers (createModels, createHandlers) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Console as Console
import Control.Monad.Eff.Exception (Error)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Either (Either)
import Data.Either as Either
import Data.Traversable (traverse_)
import FFI.Types (App, Models)
import Node.FS (FS)
import Node.FS.Async as FS
import Node.Path (FilePath)
import Node.Path as Path
import Prelude (Unit, flip, (#), ($))

foreign import createModelsImpl :: forall eff. Eff eff (Promise Models)

createModels :: forall eff. Aff eff Models
createModels =
  Promise.toAffE createModelsImpl

foreign import createHandlerImpl :: forall eff. Models
                                             -> App
                                             -> FilePath
                                             -> Eff eff Unit

createHandlers :: forall eff. App
                           -> Models
                           -> Eff (console :: CONSOLE, fs :: FS | eff) Unit
createHandlers app models =
  Path.normalize "./handlers"
    # flip FS.readdir (createHandlers' app models)

createHandlers' :: forall eff. App
                            -> Models
                            -> Either Error (Array FilePath)
                            -> Eff (console :: CONSOLE | eff) Unit
createHandlers' app models =
  Either.either Console.errorShow (traverse_ $ createHandlerImpl models app)
