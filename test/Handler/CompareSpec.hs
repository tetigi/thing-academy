module Handler.CompareSpec (spec) where

import TestImport

seedDB :: YesodExample App [Key Comparison]
seedDB = runDB $ sequence
    [insert $ Comparison "abc123" "foo" 1500, insert $ Comparison "xyz987" "bar" 1500]

spec :: Spec
spec = withApp $ do
    it "loads the index successfully" $ do
        _ <- seedDB
        get CompareR
        statusIs 200
    {--
    it "throws an error with incorrect hash"
    it "still works when invalid which is provided"
    it "updates the ELO correctly"
    --}
