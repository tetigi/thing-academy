module Handler.Compare where
import Import

import Data.Random
import Data.Random.Source.DevRandom
import Data.Random.Extras

data This = This
    deriving Show

getCompareR :: Handler Html
getCompareR = do
    entities <- runDB $ selectList [] [Asc ComparisonElo]

    Entity _ thisThingEntity <- liftIO $ runRVar (choice entities) DevRandom
    Entity _ thatThingEntity <- liftIO $ runRVar (choice entities) DevRandom

    let thisThing = comparisonValue thisThingEntity
        thatThing = comparisonValue thatThingEntity

    thisValue <- lookupGetParam "this"
    thatValue <- lookupGetParam "that"
    whichValue <- lookupGetParam "which"

    defaultLayout $ do
        setTitle $ case (thisValue, thatValue, whichValue) of
            (Just this, Just that, Just which)  -> "OH GOD"
            _                                   -> "Welcome to X-compare"
        thisButton <- newIdent
        $(widgetFile "compare")
