# Plist-Printer

Plist を綺麗に印刷したい。

## Usage

こんな感じ。

```lisp
CL-USER> (in-package :pp)
#<PACKAGE "PLIST-PRINTER">

PP>
(defparameter *data*
  '((:a 1 :b 2 :c "aaaaaaaa")
    (:a 3 :b 4 :c "aaaaaaaa")
    (:a 5 :b 6 :c "aaaaaaaa")))

(defparameter *columns*
  (list (make-column :key :a :label "Column 1")
        (make-column :key :b :label "Column 2")
        (make-column :key :c :label "Column 3")))

(pprints *data* *columns*)
| Column 1 | Column 2 | Column 3 
| 1        | 2        | aaaaaaaa 
| 3        | 4        | aaaaaaaa 
| 5        | 6        | aaaaaaaa 
NIL
```

## Installation

こんな感じ。

```lisp
CL-USER> (ql:quickload :plist-printer)
To load "plist-printer":
  Load 1 ASDF system:
    plist-printer
; Loading "plist-printer"
[package plist-printer]
(:PLIST-PRINTER)
```
