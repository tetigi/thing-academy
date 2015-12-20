# thing-academy

## Set-up

1. Check out this repo
2. Install stack (http://docs.haskellstack.org/en/stable/README.html)
3. `cd` into the repo
4. Run `stack setup`
5. Install yesod - `stack install yesod-bin cabal-install --install-ghc`
6. Run `stack build`
7. Run `stack exec -- yesod devel` - this will start up the development server

## Quick load website (with cats)
8. Release the cats: `unzip -d static/ resources/cats.zip`
9. Start the devel server if it's not already running (to seed the DB) `stack exec -- yesod devel`
10. Load the images into the database: `python scripts/seed_db.py thing-academy.sqlite3 static/cats`

## TODO

1. Image sources - perhaps start with just google searches, moving on to stupid image searching algorithm.
