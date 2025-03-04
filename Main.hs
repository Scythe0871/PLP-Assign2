module Main where

import System.Environment (getArgs)
import Interpret (interpret)
import Val (Val(..))  -- Import Val type for correct pattern matching

-- Convert Val list to readable format
formatStack :: [Val] -> String
formatStack [x] = "[" ++ showVal x ++ "]"  -- Single item: format as list
formatStack xs  = unwords (map showVal xs)  -- Multiple items: space-separated

showVal :: Val -> String
showVal (Integer n) = show n  -- Extract integer values
showVal (Real f)    = show f  -- Extract float values
showVal (Id s)      = "\"" ++ s ++ "\""  -- Properly format Id as a string

main :: IO ()
main = do
    args <- getArgs
    if null args
        then putStrLn "Please provide a .4TH file to execute."
        else do
            let fileName = head args
            contents <- readFile fileName
            (stack, _) <- interpret contents  -- Extract from IO

            if null stack
                then putStrLn "Stack is empty."
                else putStrLn (showVal (head stack) ++ " is remaining in the Stack.")

            if length stack > 1
                then putStrLn ("Warning: Stack not empty at end: " ++ formatStack (tail stack))
                else return ()
