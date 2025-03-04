module Interpret (interpret) where

import Val
import Eval (eval, evalOut)
import Flow

-- Inner function for foldl
-- Takes the current stack and an input and computes the next stack
evalF :: IO ([Val], String) -> Val -> IO ([Val], String)
evalF s (Id op) = do
    (stack, out) <- s
    evalOut op (stack, out)
evalF s x@(Integer _) = do  -- Ensure numbers are stored, not printed
    (stack, out) <- s
    return (x : stack, out)
evalF s x@(Real _) = do  -- Store floats in the stack
    (stack, out) <- s
    return (x : stack, out)

-- Function to interpret a string into a stack and an output string
interpret :: String -> IO ([Val], String)
interpret text = foldl evalF (return ([], "")) (map strToVal (words text))
