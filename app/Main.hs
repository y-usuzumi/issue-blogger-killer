module Main where

import           Control.Concurrent
import           Control.Monad
import           Data.IORef
import           IBK.Context
import           IBK.Req
import           System.IO.Unsafe
import           System.Random
import           Test.RandomStrings
import           Text.Printf

isoAlpha = onlyAlpha randomChar8
asciiAlphanum = onlyAlphaNum randomASCII

{-# NOINLINE context #-}
context :: IORef Context
context = unsafePerformIO $ newIORef Context{ username = ""
                                            , password = ""
                                            , targetUser = ""
                                            , targetRepo = ""
                                            }

main :: IO ()
main = do
  ctx <- readIORef context
  replicateM_ 480 $ do
    putStrLn "Creating issue"
    (title:body:_) <- randomStringsLen (randomString (onlyPrintable randomChar)) (5,25) 2
    let createIssue = CreateIssue{ title = title
                                 , body = body
                                 }
    void $ req createIssue ctx
    (p :: Int) <- randomRIO (5000000, 40000000)
    printf "Sleeping for %f secs" (fromIntegral p/1000000 :: Double)
