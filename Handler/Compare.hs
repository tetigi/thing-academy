module Handler.Compare where
import Import

import Data.Random
import Data.Random.Source.DevRandom
import Data.Random.Extras

import Logic.Elo

data This = This
    deriving Show

getCompareR :: Handler Html
getCompareR = do
    -- Get all entities from the db
    entities <- runDB $ selectList [] [Asc ComparisonElo]

    -- Pick two entities at random
    Entity _ thisThingEntity <- liftIO $ runRVar (choice entities) DevRandom
    Entity _ thatThingEntity <- liftIO $ runRVar (choice entities) DevRandom

    -- Expose the variables for insertion into the HTML
    let thisThing = comparisonValue thisThingEntity
        thisHash  = comparisonHash thisThingEntity
        thatThing = comparisonValue thatThingEntity
        thatHash  = comparisonHash thatThingEntity

    liftIO $ putStrLn thisHash

    -- Check for provided query parameters for a previous comparison
    thisValue <- lookupGetParam "this"
    thatValue <- lookupGetParam "that"
    whichValue <- lookupGetParam "which"

    -- Check if the query parameters actually contain anything
    _ <- case (thisValue, thatValue, whichValue) of
        (Just this, Just that, Just which)  -> do
            Entity thisId thisThingEntity' <- runDB $ getBy404 $ UniqueHash this
            Entity thatId thatThingEntity' <- runDB $ getBy404 $ UniqueHash that
            case which of
                "this"  ->
                    let (thisElo, thatElo) = getNewEloPair (comparisonElo thisThingEntity') (comparisonElo thatThingEntity') PlayerOneWin in
                    runDB $ sequence [update thisId [ComparisonElo =. thisElo], update thatId [ComparisonElo =. thatElo]]
                "that"  ->
                    let (thisElo, thatElo) = getNewEloPair (comparisonElo thisThingEntity') (comparisonElo thatThingEntity') PlayerTwoWin in
                    runDB $ sequence [update thisId [ComparisonElo =. thisElo], update thatId [ComparisonElo =. thatElo]]
                _       -> return [()]
        _               -> return [()]

    -- Start laying out the webpage
    defaultLayout $ do
        -- Fill in the rest with compare.hamlet
        $(widgetFile "compare")
