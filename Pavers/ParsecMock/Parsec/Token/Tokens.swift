//
//  Tokens.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/29.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

//tokens :: (Stream s m t, Eq t)
//=> ([t] -> String)      -- Pretty print a list of tokens
//-> (SourcePos -> [t] -> SourcePos)
//-> [t]                  -- List of tokens to parse
//-> ParsecT s u m [t]
//{-# INLINE tokens #-}
//tokens _ _ []
//  = ParsecT $ \s _ _ eok _ ->
//    eok [] s $ unknownError s
//tokens showTokens nextposs tts@(tok:toks)
//= ParsecT $ \(State input pos u) cok cerr _eok eerr ->
//let
//errEof = (setErrorMessage (Expect (showTokens tts))
//  (newErrorMessage (SysUnExpect "") pos))
//
//errExpect x = (setErrorMessage (Expect (showTokens tts))
//  (newErrorMessage (SysUnExpect (showTokens [x])) pos))
//
//walk []     rs = ok rs
//walk (t:ts) rs = do
//sr <- uncons rs
//case sr of
//Nothing                 -> cerr $ errEof
//Just (x,xs) | t == x    -> walk ts xs
//| otherwise -> cerr $ errExpect x
//
//ok rs = let pos' = nextposs pos tts
//s' = State rs pos' u
//in cok tts s' (newErrorUnknown pos')
//in do
//sr <- uncons input
//case sr of
//Nothing         -> eerr $ errEof
//Just (x,xs)
//| tok == x  -> walk toks xs
//| otherwise -> eerr $ errExpect x


