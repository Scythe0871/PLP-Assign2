module Eval (eval, evalOut) where

import Val
import Data.Char (chr)

-- Main evaluation function for operators
eval :: String -> [Val] -> [Val]
-- Arithmetic Operations (With Stack Underflow Check)
eval "+" (Integer x : Integer y : xs) = Integer (y + x) : xs
eval "+" (Real x : Real y : xs) = Real (y + x) : xs
eval "+" (Integer x : Real y : xs) = Real (y + fromIntegral x) : xs
eval "+" (Real x : Integer y : xs) = Real (fromIntegral y + x) : xs
eval "+" _ = error "Stack underflow: '+' requires two numbers"


eval "-" (Integer x : Integer y : xs) = Integer (y - x) : xs
eval "-" (Real x : Real y : xs) = Real (y - x) : xs
eval "-" (Integer x : Real y : xs) = Real (y - fromIntegral x) : xs
eval "-" (Real x : Integer y : xs) = Real (fromIntegral y - x) : xs
eval "-" _ = error "Stack underflow: '-' requires two numbers"

eval "*" (Integer x : Integer y : xs) = Integer (y * x) : xs
eval "*" (Real x : Real y : xs) = Real (y * x) : xs
eval "*" (Integer x : Real y : xs) = Real (y * fromIntegral x) : xs
eval "*" (Real x : Integer y : xs) = Real (fromIntegral y * x) : xs
eval "*" _ = error "Stack underflow: '*' requires two numbers"

eval "/" (Integer x : Integer y : xs)
  | x == 0    = error "Division by zero"
  | otherwise = Integer (y `div` x) : xs
eval "/" (Real x : Real y : xs) = Real (y / x) : xs
eval "/" (Integer x : Real y : xs) = Real (y / fromIntegral x) : xs
eval "/" (Real x : Integer y : xs) = Real (fromIntegral y / x) : xs
eval "/" _ = error "Stack underflow: '/' requires two numbers"

eval "^" (Integer x : Integer y : xs) = Integer (y ^ x) : xs
eval "^" (Real x : Real y : xs) = Real (y ** x) : xs
eval "^" (Integer x : Real y : xs) = Real (y ** fromIntegral x) : xs
eval "^" (Real x : Integer y : xs) = Real (fromIntegral y ** x) : xs
eval "^" _ = error "Stack underflow: '^' requires two numbers"


-- String and Formatting Operations
eval "STR" (Integer x:xs) = Id (show x) : xs
eval "STR" (Real x:xs) = Id (show x) : xs
eval "STR" (Id s:xs) = Id s : xs  -- If already a string, keep it unchanged
eval "STR" _ = error "Stack underflow: 'STR' requires one value"

eval "CONCAT2" (Id x : Id y : xs) = Id (y ++ x) : xs
eval "CONCAT2" _ = error "Stack underflow: CONCAT2 requires two strings and contents should be strings"

eval "CONCAT3" (Id x : Id y : Id z : xs) = Id (z ++ y ++ x) : xs
eval "CONCAT3" _ = error "Stack underflow: CONCAT3 requires three strings and contents should be strings"

-- Duplicate the element at the top of the stack
eval "DUP" (x:xs) = x : x : xs
eval "DUP" [] = error "Stack underflow: 'DUP' requires at least one value"

-- Default case: push the identifier on the stack
eval s stack = Id s : stack

-- Function to handle printing output
evalOut :: String -> ([Val], String) -> IO ([Val], String)
evalOut "." (Integer i : xs, out) = do
    putStrLn (show i)
    return (xs, out)
evalOut "." (Real x : xs, out) = do
    putStrLn (show x)
    return (xs, out)
evalOut "." (Id s : xs, out) = do
    putStrLn s
    return (xs, out)
evalOut "." ([], _) = error "Stack underflow"

evalOut "EMIT" (Integer x:xs, out) = do
    putChar (chr x)  -- Print the corresponding ASCII character
    return (xs, out) -- Remove the printed value from the stack

evalOut "CR" (xs, out) = do
    putStrLn ""
    return (xs, out)

evalOut op (stack, out) = return (eval op stack, out)
