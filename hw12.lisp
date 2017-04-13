; **************** BEGIN INITIALIZATION FOR ACL2s B MODE ****************** ;
; (Nothing to see here!  Your actual file is after this initialization code);

#|
Pete Manolios
Fri Jan 27 09:39:00 EST 2012
----------------------------

Made changes for spring 2012.


Pete Manolios
Thu Jan 27 18:53:33 EST 2011
----------------------------

The Beginner level is the next level after Bare Bones level.

|#

; Put CCG book first in order, since it seems this results in faster loading of this mode.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading the CCG book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "ccg/ccg" :uncertified-okp nil :dir :acl2s-modes :ttags ((:ccg)) :load-compiled-file nil);v4.0 change

;Common base theory for all modes.
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s base theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "base-theory" :dir :acl2s-modes)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s customizations book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "custom" :dir :acl2s-modes :uncertified-okp nil :ttags :all)

;Settings common to all ACL2s modes
(acl2s-common-settings)

#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading trace-star and evalable-ld-printing books.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "trace-star" :uncertified-okp nil :dir :acl2s-modes :ttags ((:acl2s-interaction)) :load-compiled-file nil)
(include-book "hacking/evalable-ld-printing" :uncertified-okp nil :dir :system :ttags ((:evalable-ld-printing)) :load-compiled-file nil)

;theory for beginner mode
#+acl2s-startup (er-progn (assign fmt-error-msg "Problem loading ACL2s beginner theory book.~%Please choose \"Recertify ACL2s system books\" under the ACL2s menu and retry after successful recertification.") (value :invisible))
(include-book "beginner-theory" :dir :acl2s-modes :ttags :all)


#+acl2s-startup (er-progn (assign fmt-error-msg "Problem setting up ACL2s Beginner mode.") (value :invisible))
;Settings specific to ACL2s Beginner mode.
(acl2s-beginner-settings)

; why why why why 
(acl2::xdoc acl2s::defunc) ; almost 3 seconds

(cw "~@0Beginner mode loaded.~%~@1"
    #+acl2s-startup "${NoMoReSnIp}$~%" #-acl2s-startup ""
    #+acl2s-startup "${SnIpMeHeRe}$~%" #-acl2s-startup "")


(acl2::in-package "ACL2S B")

; ***************** END INITIALIZATION FOR ACL2s B MODE ******************* ;
;$ACL2s-SMode$;Beginner
#|

 * Submit the homework file (this file) on Blackboard.  Do not rename 
   this file.  There will be a 10 point penalty for this.

 * You must list the names of ALL group members below, using the given
   format. This way we can confirm group membership with the BB groups.
   If you fail to follow these instructions, it costs us time and
   it will cost you points, so please read carefully.


Names of ALL group members: Preeta Hopwood, Mahitha Valluru, Tam Vu

Note: There will be a 10 pt penalty if your names do not follow 
this format.
|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Section A: Admissibility, Measure Functions and Induction Schemes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|
First, let's review the conditions necessary for a function to be admitted in
ACL2s (I'm paraphrasing below):
1) The function f is a new function symbol
2) The input variables are distinct variable symbols
3) The body of the function is well formed term, possibly using a recursive
call to f and mentioning no variables freely (ie only the input variables)
4) The function is terminating
5) IC=>OC is a theorem
6) The body contract holds under the assumption that the IC holds (ie there
isn't a body contract violation if the input contract is true)


OK.  Now onto the questions.

For each function fn below (f1...f5), determine if the function fn is admissible:

If fn is admissible: 
   1) provide a measure function mn that can be used to prove it terminates
   2) Write the proof obligations for fn using mn that can show it terminates.
   3) Convince yourself that the function terminates (no need for a formal proof)
   4) Write the induction scheme that fn gives rise to.

If fn is NOT admissible, 
   1) Give your justification as to why (conditions 1-6 above).
      a) If the problem is syntactic (admissibility conditions 1-3) then tell us what
         part of the function has a problem.
      b) If the issue is with conditions 4-6, then give an input that will illustrate
         the violation.
   2) Give the (invalid) induction scheme that fn gives rise to.
|#

#|
A1.
(defunc f1 (x y z)
  :input-contract (and (natp x) (natp y) (listp z))
  :output-contract (natp (f1 x y z))
  (cond ((equal x 0) (+ y (len z)))
        ((endp z)    (+ x y))
        ((<= y 1)    (+ x (f1 (- x 1) 0 (rest z))))
        (t           (f1 x (- y 2) z))))

f1 admissible

1) Measure function

(defunc m1 (x y z)
  :input-contract (and (natp x) (natp y) (listp z))
  :output-contract (natp (m1 x y z))
  (+ x y))
  
2) Proof obligations that m1 shows f1 terminates
Recursive1 : (natp x) /\ (natp y) /\ (listp z) /\ ~(x = 0) /\ ~(endp z)
/\ (y <= 1) => (m1 x y z) > (m1 (x - 1) 0 (rest z))
Recursive2 : (natp x) /\ (natp y) /\ (listp z) /\ ~(x = 0) /\ ~(endp z)
/\ ~(y <= 1) => (m1 x y z) > (m1 x (y - 2) z)

4) I.S from f1
     1/ ~(and (natp x) (natp y) (listp z)) => phi
     2/ (and (natp x) (natp y) (listp z) (endp z)) => phi
     3/ (and (natp x) (natp y) (listp z) ~(endp z) (<= y 1) phi|((x (x - 1)) (z (rest z))) => phi
     4/ (and (natp x) (natp y) (listp z) ~(endp z) ~(<= y 1) phi|((y (y - 2)))) => phi

|#

(defdata lor (listof rational))

#|
A2.
;; Remember, induction schemes rely on  converting a function to an equivalent
;; cond statement.

(defunc f2 (x y)
  :input-contract (and (lorp x)(lorp y))
  :output-contract (lorp (f2 x y))
  (if (endp x)
    y
    (if (not (endp y))
      (if (<= (first x)(first y))
        (cons (first x) (f2 (rest x) y))
        (cons (first y) (f2 x (rest y))))
      x)))
      
 Rewrite f2 to cond statements     
(defunc f2 (x y)
  :input-contract (and (lorp x)(lorp y))
  :output-contract (lorp (f2 x y))
  (cond ((endp x) y)
        ((endp y) x)
        ((<= (first x)(first y)) (cons (first x) (f2 (rest x) y)))
        (t (cons (first y) (f2 x (rest y))))))
      

f2 admissible

1) Measure function

(defunc m2 (x y)
  :input-contract (and (lorp x)(lorp y))
  :output-contract (natp (m2 x y))
  (+ (len x) (len y)))
  
2) Proof obligations that m2 shows f2 terminates
Recursive1 : (lorp x) /\ (lorp y) /\ ~(endp x) /\ ~(endp y)
/\ ((first x) <= (first y)) => (m2 x y) > (m2 (rest x) y)
Recursive2 : (lorp x) /\ (lorp y) /\ ~(endp x) /\ ~(endp y)
/\ ~((first x) <= (first y)) => (m2 x y) > (m2 x (rest y))

4) I.S from f2
     1/ ~(and (lorp x)(lorp y)) => phi
     2/ (and (lorp x)(lorp y) (endp x)) => phi
     3/ (and (lorp x)(lorp y) ~(endp x) (endp y)) => phi
     4/ (and (lorp x)(lorp y) ~(endp x) ~(endp y) (<= (first x)(first y)) phi|(x (rest x)) => phi
     5/ (and (lorp x)(lorp y) ~(endp x) ~(endp y) ~(<= (first x)(first y)) phi|(y (rest y))) => phi
     
     
|#

;; No need to consider the admissibility of evenp.  Just f3
#| (defunc evenp (i)
  :input-contract (integerp i)
  :output-contract (booleanp (evenp i))
  (integerp (/ i 2)))
|#
#|
A3.
(defunc f3 (x)
  :input-contract (integerp x)
  :output-contract (natp (f3 x))
  (cond ((> x 5)   (+ 1 (f3 (- x 1))))
        ((< x -5)  (- 2 (f3 (+ x 1))))
        ((evenp x) x)                   
        (t         (+ 3 (f3 (* 3 x)))))) 

f3 is not admissible
        
1) f3 does not terminate (fail (4))
Example: (f3 -5) -> (f3 -15) -> (f3 -14) -> (f3 -13) ... -> (f3 -5)


2) (invalid) I.S 
   1/ ~(integerp x) => phi
   2/ (integerp x) /\ (x > 5) /\ phi|(x (x - 1)) => phi
   3/ (integerp x) /\ ~(x > 5) /\ (x < -5) /\ phi|(x (x + 1)) => phi
   4/ (integerp x) /\ ~(x > 5) /\ ~(x < -5) /\ (evenp x) => phi
   5/ (integerp x) /\ ~(x > 5) /\ ~(x < -5) /\ ~(evenp x) /\ phi|(x (3 * x)) => phi
   
|#

(defdata lon (listof nat))


#|
A4.
(defunc f4 (x y)
  :input-contract (and (natp x)(lonp y))
  :output-contract (natp (f4 x y))
  (cond ((endp y)  0)
        ((equal x (first y))  (+ 1 (f4 (+ x 1) (rest y))))
        (t                    (f4 (+ x 1) (rest y)))))
        
f4 admissible

1) Measure function

(defunc m4 (x y)
  :input-contract (and (natp x)(lonp y))
  :output-contract (natp (m4 x y))
  (len y))
  
2) Proof obligations that m2 shows f2 terminates
Recursive1 : (natp x) /\ (lonp y)) /\ ~(endp y) /\ (x = (first y))
=> (m4 x y) > (m4 (x + 1) (rest y))
Recursive2 : (natp x) /\ (lonp y)) /\ ~(endp y) /\ ~(x = (first y))
=> (m4 x y) > (m4 (x + 1) (rest y))

4) I.S from f2
     1/ ~((natp x) /\ (lonp y)) => phi
     2/ (natp x) /\ (lonp y) /\ (endp y) => phi
     3/ (natp x) /\ (lonp y)) /\ ~(endp y) /\ (x = (first y)) /\ phi|((x (x + 1)) (y (rest y)) => phi
     3/ (natp x) /\ (lonp y)) /\ ~(endp y) /\ ~(x = (first y)) /\ phi|((x (x + 1)) (y (rest y)) => phi
        

|#

#|
A5.
(defunc f5 (e l1 l2)
  :input-contract (and (listp l1)(listp l2))
  :output-contract (natp (f5 e l1 l2))
  (cond ((endp l1)  (len l2))
        ((endp l2)  (f5 e (rest l1) (cons e l2)))
        (t          (f5 e (cons e l1) (rest l2)))))

f5 is not admissible

1) f5 does not terminate (fail (6))
Example 
(f5 1 '(1 2) '(3 4))
= (f5 1 '(1 1 2) '(4)) <--
= (f5 1 '(1 1 2) '())    |
= (f5 1 '(1 2) '(1))     |
= (f5 1 '(1 1 2) '()) ----

2) (invalid) I.S
     1/ ~(and (listp l1)(listp l2)) => phi
     2/ (and (listp l1)(listp l2) (endp l1)) => phi
     3/ (and (listp l1)(listp l2) ~(endp l1) (endp l2) phi|((l1 (rest l1)) (l2 (cons e l2)))) => phi
     4/ (and (listp l1)(listp l2) ~(endp l1) ~(endp l2) phi|((l1 (cons e l1)) (l2 (rest l2)))) => phi

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section B: The Revenge of rem-smally
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; You probably thought that question was well behind
;; you. No such luck. Let's revisit our two mod functions
;; from the start of term and let's actually PROVE
;; that they spit out the same value.
;; Rem was renamed mod to hopefully reduce confusion with 
;; "remove" or other possible abbreviations.....and yes.  Mod
;; could be modify but we used the term mod regularly in CS 1800.
;;
;; Here is a modified solution from HW02:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mod-similar: Nat x Nat-{0} -> Nat
;;
;; (mod-similar x y) returns the remainder of the integer division of 
;; x by y assuming that x and y are relatively the same size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defunc mod-similar (x y)
  :input-contract (and (natp x)(posp y))
  :output-contract (natp (mod-similar x y))
  (if (< x y)
    x
    (mod-similar (- x y) y)))

(check= (mod-similar 3 3) 0)
(check= (mod-similar 3 4) 3)
(check= (mod-similar 4 3) 1)

(check= (mod-similar 300 3) 0)
(check= (mod-similar 3000 4) 0)
(check= (mod-similar 40000 3) 1)
(check= (mod-similar 40001 3) 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mod-smally: Nat x Nat-{0} -> Nat
;;
;; (mod-smally x y) returns the remainder of the integer division of 
;; x by y assuming that y is relatively small compared to x.
(defunc mod-smally (x y)
  :input-contract (and (natp x)(posp y))
  :output-contract (natp (mod-smally x y))
  (if (< x y)
    x
    (if (natp (/ x y))
      0
      (+ 1 (mod-smally (- x 1) y)))))

(check= (mod-smally 300 3) 0)
(check= (mod-smally 3000 4) 0)
(check= (mod-smally 40000 3) 1)
(check= (mod-smally 40001 3) 2)#|ACL2s-ToDo-Line|#





#| Prove that mod-smally = mod-similar.  You will likely need a lemma or two. 
The solution file uses the induction scheme mod-similar gives rise to but you are 
not forced to use this.

You can also assume the following (you can prove G1 if you want extra practice):
Given G1: (natp x) /\ (posp y) /\ (< x y) => ((mod-smally x y) = x)
Given G2: (natp x) /\ (posp y) /\ (natp z) /\ (equal (* y z)  x) =>  (natp (/ x y)) 
Given G3: (natp a) /\ (natp b) /\ (posp y) /\ (natp (/ a y)) /\ (natp (/ b y)) => (natp (/ (+ a b) y))

Rewrite mod-smally

(defunc mod-smally (x y)
  :input-contract (and (natp x)(posp y))
  :output-contract (natp (mod-smally x y))
  (cond ((< x y) x)
        ((natp (/ x y)) 0)
        (t (+ 1 (mod-smally (- x 1) y)))))

PROVE phi_mod: (natp x) /\ (posp y) => (mod-smally x y) = (mod-similar x y)

I.S for mod-similar
1/ ~ (natp x) /\ (posp y) => phi_mod (trivial)
2/ (natp x) /\ (posp y) /\ (< x y) => phi_mod
3/ (natp x) /\ (posp y) /\ ~(< x y) /\ phi_mod|(x (- x y)) => phi_mod

Obligation 2: (natp x) /\ (posp y) /\ (< x y) 
=> (natp x) /\ (posp y) => (mod-smally x y) = (mod-similar x y)

C1 (natp x) 
C2 (posp y) 
C3 (< x y) 

(mod-smally x y)
= {G1, C1, C2, C3, MP}
x

(mod-similar x y)
= {def mod-similar, C3, cond axiom}
x

Obligation 3: (natp x) /\ (posp y) /\ ~(< x y) /\ phi_mod|(x (- x y))
=> (natp x) /\ (posp y) => (mod-smally x y) = (mod-similar x y)

C1 (natp x) 
C2 (posp y) 
C3 ~(< x y) [x >= y]
C4 (natp (x - y)) /\ (posp y) => (mod-smally (x - y) y) = (mod-similar (x - y) y)
---------
C5 (natp (x - y)) {arithmetic, def natp, C3}
C6 (mod-smally (x - y) y) = (mod-similar (x - y) y) {C4, C5, C2, MP}

CASE1: x = y
-----
C7 ~(x < y) {case1}
C8 (natp (/ x y)) {arithmetic, case1, (natp (/ y y)) = (natp 1)}

right
(mod-similar x y)
= {def mod-similar}
(mod-similar (x - y) y)
= {def mod-similar, case1, arith, if axiom}
0

left
(mod-smally x y)
= {def mod-smally, C7, C8, cond axiom}
0



CASE2: x > y

right    
(mod-similar x y)
= {def mod-similar, C3, cond axiom}
(mod-similar (- x y) y)
= {C6}
(mod-smally (x - y) y)

left
(mod-smally x y) 
= {PHI_MOD_LEMMA1}
(mod-smally (x - y) y)
right

------------------------------------------
PHI_MOD_LEMMA1
(natp x) /\ (posp y) /\ (x > y) => (mod-smally x y) = (mod-smally (x - y) y)

IS for mod-smally:
1. (not (natp x)) /\ (not (posp y)) => phi (trivial)
2. (natp x) /\ (posp y) /\ (< x y) => phi (nil => phi)
3. (natp x) /\ (posp y) /\ ~(< x y) /\ (natp (/ x y)) => phi
4. ((natp x) /\ (posp y) /\ ~(< x y) /\ ~(natp (/ x y))  /\ phi | (( x (- x 1)))=> phi 

Obligation 3.
C1 (natp x)
C2 (posp y)
C3 ~(< x y)) 
C4 (x > y)
C5 (natp (/ x y))
-------------
C6 (natp (/ (- x y) y)) {arithmetic, C5, C4}**********
C7 (x > 2y) {Arithmetic, C5, C4}
C8 x - y > y {C7, Arithmetic}

left
(mod-smally x y) 
= {def mod-smally, C3, C5, cond axiom}
0 

right
(mod-smally (x - y) y)
= {def mod-smally, C8, arithmetic, C6, cond axiom}
0


Obligation 4:
C1 (natp x)
C2 (posp y)
C3 ~(< x y)
C4 (x > y)
C4 ~(natp (/ x y))
C5 (natp (- x 1)) /\ (posp y) /\ (> (- x 1) y) => (mod-smally (x - 1) y) = (mod-smally (x - y - 1) y)
---------------
C6 (natp (- x 1)) {C1}
C7 (- x 1) > y *************** x > y >= y > 1 <=> x - y >= y
C8 (mod-smally (x - 1) y) = (mod-smally (x - y - 1) y) {C5, C6, C7, MP}
C9 ~(natp (/ (x - y - 1) y)) *************** 


left
(mod-smally x y) 
= {def mod-smally, C3, C4, cond axiom}
(+ 1 (mod-smally (- x 1) y))
= {C8}
(+ 1 (mod-smally (x - y - 1) y))

right
(mod-smally (x - y - 1) y)
= {def mod-smally, C7, C9, cond axiom}
(+ 1 (mod-smally (x - y - 1) y))
= left



|#
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section C: Swap-count
;; This question is OPTINAL.....yes ALL of section C
;; is optional.  Sections D onwards are not optional.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Consider the following functions.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; swap-all: All x All x List -> List
;; Goes through list l and replaces all occurances of element e
;; with element f.
(defunc swap-all (e f l)
  :input-contract (listp l)
  :output-contract (listp (swap-all e f l))
  (cond ((endp l)            l)
        ((equal e (first l)) (cons f (swap-all e f (rest l))))
        (t                   (cons (first l)(swap-all e f (rest l))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; count: All x List -> Nat
;; Counts the number of occurences of element e in list l.
(defunc count (e l)
  :input-contract (listp l)
  :output-contract (natp (count e l))
  (cond ((endp l)            0)
        ((equal e (first l)) (+ 1 (count e (rest l))))
        (t                   (count e (rest l)))))

;; Here is a function showing how the number of elements change with swap-all
(thm (implies (listp l)(equal (len l)(len (swap-all e f l)))))

(defthm count-swap-thm 
  (implies (and (not (equal e f))(listp l))
           (equal (+ (count f l)(count e l)) 
                  (count f (swap-all e f l)))))
#| 
 OK.  Look at the theorem above. ACL2s has proved this in under a second
 and is making you look bad.  You can't let this stand.
 Reclaim your honor and prove count-swap-thm yourself.  
 Make sure you identify the induction scheme used.

 |#
 
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;D.  Yes tser
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
D1.Take the function tser (rest backwards) below which takes a 
list l and returns the list with the last element in the list removed.
|#
(defunc tser (l)
  :input-contract (and (listp l)(consp l))
  :output-contract (listp (tser l))
  (if (endp (rest l))
    nil
    (cons (first l) (tser (rest l)))))

(check= (tser '(1 2 3 4)) '(1 2 3))
(check= (tser '(1)) nil)

(check= (tser '(5 5)) '(5))
#|
Now prove the following conjecture:
phi_tser: (listp l) /\ (consp l) => ((rev (rest (rev l))) = (tser l))
      
Clearly identify your induction scheme and the function it is derived from.

You may need a lemma.  For the sake of your own sanity here's the lemma
I used (you will need to prove it if you use it):
L1 - (listp X)/\ (not (endp X)) /\ (listp Y) 
      => ((rest (app (rev X) Y)) = (app (rest (rev X)) Y) 

HINT: The proof for L1 DOES NOT NEED INDUCTION.  In fact you could do it
within the main function but when I saw it I assumed that the proof would
be complicated. I initially tried to prove L1 with 
induction without thinking about it and I got stuck (since I was trying
to change things to look like my inductive hypothesis).  The proof is simpler
than it may seem provided you consider the app first.

Prove L1: (listp X) /\ (not (endp X)) /\ (listp Y) 
      => ((rest (app (rev X) Y)) = (app (rest (rev X)) Y) 
      
      C1 (listp X)
      C2 (not (endp X)) 
      C3 (listp Y) 
      
      left
      (rest (app (rev X) Y)) 
      = {def app, rev, C2, cond axiom}
      (rest (cons (first (rev x)) (app (rest (rev x)) y))) 
      = {first/rest axiom}
      (app (rest (rev x)) y)
      = right
      
      
      

Prove PHI_TSER: (listp l) /\ (consp l) => (rev (rest (rev l))) = (tser l))

I.S for tser
1/ ~((listp l) /\ (consp l)) => phi (trivial)
2/ (listp l) /\ (consp l) /\ (endp (rest l)) => phi 
3/ (listp l) /\ (consp l) /\ ~(endp (rest l)) /\ phi|(l (rest l)) => phi

Obligation 2 (listp l) /\ (consp l) /\ (endp (rest l)) => (listp l) /\ (consp l) => ((rev (rest (rev l))) = (tser l))

C1 (listp l) 
C2 (consp l) 
C3 (endp (rest l))

left 
(rev (rest (rev l))) 
= {def rev, C2, cons axiom}
(rev (rest (app (rev (rest l)) (list (first l)))
= {def rev, C3}
(rev (rest (app nil (list (first l)))
= {def app}
(rev (rest (list (first l))))
= {first/rest}
(rev nil)
= {def rev}
nil

right
(tser l)
= {def tser, C3, cond axiom}
nil

Obligation 3
(listp l) /\ (consp l) /\ ~(endp (rest l)) /\ phi|(l (rest l))
=> (listp l) /\ (consp l) => (rev (rest (rev l))) = (tser l)

C1 (listp l) 
C2 (consp l) 
C3 ~(endp (rest l))
C4 (listp (rest l)) /\ (consp (rest l)) => ((rev (rest (rev (rest l)))) = (tser (rest l)))
---------------
C5a (listp (rest l)) {def listp, cons, C2}
C5 (consp (rest l)) {C3, def cons, endp}
C6 (rev (rest (rev (rest l)))) = (tser (rest l)) {C4, C5, C5a, MP}

left 
(rev (rest (rev l)))
= {def rev}

= {def rev, C2}
(rev (rest (app (rev (rest l)) (list (first l)))))
= {L1}
(rev (app (rest (rev (rest l)))
          (list (first l))))
= {rev-app}
(app (rev (list (first l)))
     (rev (rest (rev (rest l)))))
= {def rev, first/rest axiom}
(app (app (list (first l)) (rev nil))
     (rev (rest (rev (rest l)))))
= {def app, app-listp-nil}
(app (list (first l))
     (rev (rest (rev (rest l)))))



right
(tser l)
= {def tser, C3, cond axiom}
(cons (first l) (tser (rest l)))
= {C6}
(cons (first l) (rev (rest (rev (rest l)))))
= {def app}
(app (list (first l)) 
     (rev (rest (rev (rest l)))))
     
     

Lemma used: 
rev-app (listp x) /\ (listp y) => (rev (app x y)) = (app (rev y) (rev x)) {in class}
app-listp-nil (listp x) => (app x nil) = x {in class}


|#


#|
D2. 
Write a tail recursive version of tser (described above) named tser-t with
variables x and acc (the accumulator).

NOTE 1: If you are worried about efficiency, feel free to use rev* instead
of rev since we know they are equivalent from class.

NOTE 2: For additional practice, trying the proof with 
tser* calling (rev* (tser-t x nil)).  Just don't pass this other proof in.

Here is the function tser* (do not change it).
|#

(defunc tser-t (x acc)
  :input-contract (and (listp x)(consp x)(listp acc))
  :output-contract (listp (tser-t x acc))
  (cond ((endp (rest x)) (rev acc))
        (t (tser-t (rest x) (cons (first x) acc)))))
        
(check= (tser-t '(1 2) '()) '(1))
(check= (tser-t '(1) '(3 2)) '(2 3))
(check= (tser-t '(3 4) '(2 1)) '(1 2 3))

(defunc tser* (x)
  :input-contract (and (listp x)(consp x))
  :output-contract (listp (tser* x))
  (tser-t x nil))

(check= (tser* '(1 2 3 4)) '(1 2 3))
(check= (tser* '(1)) nil)

(check= (tser* '(5 5)) '(5))


(defthm l_tser
  (implies (and (listp x) (consp x) (listp acc))
           (equal (tser-t x acc)
                  (app (rev acc) (tser x)))))

#|

b) Write the generalized lemma (L_tser) describing the relationship 
between  tser-t, acc and tser.  Feel free to include your sample code calls
you used to determine the relationship (you should definitely do this even
if you don't include this in your solution)
(tser-t '(1 2 3 4) nil)   (tser '(1 2 3 4)) = '(1 2 3)
(tser-t '(2 3 4) '(1))    (tser '(2 3 4)) = '(2 3)

Lemma L_TSER: 
(listp x) /\ (consp x) /\ (listp acc) => (tser-t x acc) = (app (rev acc) (tser x)) 


c) Main Proof: Assuming L_tser is valid, prove the following conjecture
phi_tser: (listp x)/\(consp x) => ((tser* x) = (tser x))
C1(listp x)
C2(consp x)

(tser* x) 
= {def tser*}
(tser-t x nil)
= {L_tser}
(app (rev nil) (tser x))
= {def app, rev}
(tser x)



d) Prove L_tser.  Make sure you clearly identify the induction scheme you
used and the function it's derived from.


Induction Scheme from tser-t 
1. ~(and (listp x)(consp x)(listp acc)) => L_tser
trivial

2. (listp x) /\ (consp x) /\ (listp acc) /\ (endp (rest x)) => L_tser

C1 (listp x) 
C2 (consp x)
C3 (listp acc)
C4 (endp (rest x))

(tser-t x acc) 
= {def tser-t; C4}
(rev acc)

(app (rev acc) (tser x))
= {def tser; C4}
(app (rev acc) nil)
= {thm app_nil}
(rev acc)
= right


3. (listp x) /\ (consp x) /\ (listp acc) /\ ~(endp (rest x)) 
   /\ L_tser|((x (rest x))(acc (cons (first x) acc)) => L_tser

C1 (listp x) 
C2 (consp x)
C3 (listp acc)
C4 ~(endp (rest x))
C5 (listp (rest x)) /\ (consp (rest x)) /\ (listp (cons (first x) acc)) =>
   (tser-t (rest x) (cons (first x) acc)) = (app (rev (cons (first x) acc)) (tser (rest x)))
---------------------------
C6 (tser-t (rest x) (cons (first x) acc)) = (app (rev (cons (first x) acc)) (tser (rest x))) 
   {C2, C4, C3; axiom cons; MP}


(tser-t x acc) 
= {def tser-t; C4}
(tser-t (rest x) (cons (first x) acc))
= {C6}
(app (rev (cons (first x) acc)) (tser (rest x)))
= {def rev; axiom cons}
(app (app (rev acc) (list (first x))) (tser (rest x)))
= {thm associtivity_app}
(app (rev acc) (app (list (first x)) (tser (rest x))))


(app (rev acc) (tser x))
= {def tser; C4}
(app (rev acc) (cons (first l) (tser (rest l))))
= {def app; axiom cons, list}
(app (rev acc) (app (list (first l)) (tser (rest l))))
= right

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
E Removing outliers

Given that the end of term is fast approaching, my mind drifts
to statistical analysis and figuring out how students did on an
exam or assignment.  However, for the mean (or average) grade to
be meaningful I need to ensure that grades are normally distributed
(not part of the homework) and outliers are removed.....so how do we
do that?

First, we need to calculate the mean of a list of grades, determine
what is considered an outlier (we will simplifly this by stating 
> 40% from the mean is an outlier), remote outliers, and then
re-calculate the mean. If the list is empty, the mean is 0.

Now let's make this potentially faster by converting all of these functions
to be tail recursive.  However, since we are taking the average
of these scores, the order in a list doesn't matter. Thus the tail recurive
filter call can return elements in the reverse order without impacting
the average.  
|#
(defdata lopr (range rational (0 <= _ )))


(defunc abs (r)
  :input-contract (rationalp r)
  :output-contract (loprp (abs r))
  (if (< r 0)
    (unary-- r)
    r))

(defunc sum-lr (lr)
  :input-contract (lorp lr)
  :output-contract (rationalp (sum-lr lr))
  (if (endp lr)
    0
    (+ (first lr) (sum-lr (rest lr)))))

(defunc mean (lr)
  :input-contract (lorp lr)
  :output-contract (rationalp (mean lr))
  (if (endp lr)
    0
    (/ (sum-lr lr) (len lr))))

(defunc outlierp (r m d)
  :input-contract (and (rationalp r)(rationalp m)(loprp d))
  :output-contract (booleanp (outlierp r m d))
  (> (abs (- r m)) d))

(defunc filter-out (lr m d)
  :input-contract (and (lorp lr)(rationalp m)(loprp d))
  :output-contract (lorp (filter-out lr m d))
  (cond ((endp lr) lr)
        ((outlierp (first lr) m d) (filter-out (rest lr) m d))
        (t                       (cons (first lr)(filter-out (rest lr) m d)))))

;; You can ignore the next line. It is used to admit filter-mean
(acl2::in-theory (acl2::disable abs-definition-rule))

(defunc filter-mean (lr)
  :input-contract (lorp lr)
  :output-contract (rationalp (filter-mean lr))
  (let* ((m (mean lr))
         (d (abs (* 4/10 m))))
    (mean (filter-out lr m d))))


;;1) Write filter-out-t (no need for a filter-out*), sum-lr-t 
;;  (no need for a sum-lr*), and mean*
;; Notice that non-recursive functions like mean* and mean can be shown to be
;; equal if their recursive calls are equal for the same inputs (no induction needed)

(defunc filter-out-t (lr m d acc)
  :input-contract (and (lorp lr)(rationalp m)(loprp d)(lorp acc))
  :output-contract (lorp (filter-out-t lr m d acc))
  (cond ((endp lr) (rev acc))
        ((outlierp (first lr) m d) (filter-out-t (rest lr) m d acc))
        (t                       (filter-out-t (rest lr) m d (cons (first lr) acc)))))

;; mean* is not a function. Changed to mean
(defunc filter-mean* (lr)
  :input-contract (lorp lr)
  :output-contract (rationalp (filter-mean* lr))
  (let* ((m (mean lr))
        (d (abs (* 4/10 m))))
    (mean (filter-out-t lr m d nil))))

#|
2) Prove that filtered-mean* = filtered-mean
Notice that this will break our proof pattern a bit since filter-out and filter-out-t
should return the values in a different order. You will need a number of lemmas for this
proof.

filter-mean-same-phi
(lorp lr) => (filter-mean* lr) = (filter-mean lr)

Induction Scheme
1. ~ (and (lorp lr)(rationalp m)(loprp d)(lorp acc)) => filter-mean-same-phi
trivial

2. (lorp lr) /\ (rationalp m) /\ (loprp d) /\ (lorp acc) /\ (endp lr) => filter-mean-same-phi
C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 (lorp acc)
C5 (endp lr)

(filter-mean* lr) 
= {def filter-mean*; C5}
(mean (filter-out-t nil m d nil))
= {def filter-out-t}
(rev nil)
= {def rev}
(mean nil)

(filter-mean lr)
= {def filter-mean; C5}
(mean (filter-out nil m d))
= {def filter-out}
(mean nil)

3. (lorp lr) /\ (rationalp m) /\ (loprp d) /\ (lorp acc) /\ ~(endp lr) /\
   (outlierp (first lr) m d) /\ filter-mean-same-phi|((lr (rest lr))) 
   => filter-mean-same-phi
   
C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 (lorp acc)
C5 ~(endp lr)
C6 (outlierp (first lr) m d)
C7 (lorp (rest lr)) => (filter-mean* (rest lr)) = (filter-mean (rest lr))
------------------------------------------
C8 (filter-mean* (rest lr)) = (filter-mean (rest lr)) {C5, C7, MP}
C9 (mean (filter-out-t (rest lr) m d nil)) = (mean (filter-out (rest lr) m d)) 
   {def filter-mean*, filter-mean; C8}

(filter-mean* lr) 
= {def filter-mean*}
(mean (filter-out-t lr m d nil))
= {def filter-out-t; C5, C6}
(mean (filter-out-t (rest lr) m d nil))
= {C9}
(mean (filter-out (rest lr) m d))


(filter-mean lr)
= {def filter-mean}
(mean (filter-out lr m d))
= {def filter-out; C5, C6}
(mean (filter-out (rest lr) m d))

4. (lorp lr) /\ (rationalp m) /\ (loprp d) /\ (lorp acc) /\ ~(endp lr) /\
   ~(outlierp (first lr) m d) /\ filter-mean-same-phi|((lr (rest lr))(acc (cons (first lr) acc))) 
   => filter-mean-same-phi

C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 (lorp acc)
C5 ~(endp lr)
C6 ~(outlierp (first lr) m d)
C7 (lorp (rest lr)) => (filter-mean* (rest lr)) = (filter-mean (rest lr))
------------------------------------------
C8 (filter-mean* (rest lr)) = (filter-mean (rest lr)) {C5, C7, MP}
C9 (mean (filter-out-t (rest lr) m d nil)) = (mean (filter-out (rest lr) m d)) 
   {def filter-mean*, filter-mean; C8}
 
(filter-mean* lr) 
= {def filter-mean*}
(mean (filter-out-t lr m d nil))
= {def filter-out-t; C5, C6}
(mean (filter-out-t (rest lr) m d (cons (first lr) nil)))
= {filter_acc_lemma}
(mean (cons (first lr) (filter-out-t (rest lr) m d nil)))
= {remove_mean_lemma}
(/ (+ (first lr) (* (mean (filter-out-t (rest lr) m d nil)) (- (len lr) 1))) (len lr))
= {C9}
(/ (+ (first lr) (* (mean (filter-out (rest lr) m d)) (- (len lr) 1))) (len lr))

(filter-mean lr)
= {def filter-mean}
(mean (filter-out lr m d))
= {def filter-out; C5, C6}
(mean (cons (first lr) (filter-out (rest lr) m d)))
= {remove_mean_lemma}
(/ (+ (first lr) (* (mean (filter-out (rest lr) m d)) (- (len lr) 1))) (len lr))



filter_acc_lemma: 
(and (lorp lr)(rationalp m)(loprp d)(lorp acc)) /\ ~(endp lr) /\ ~(outlierp (first lr) m d) =>
(filter-out-t (rest lr) m d (cons (first lr) nil)) = (cons (first lr) (filter-out-t (rest lr) m d nil))

C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 (lorp acc)
C5 ~(endp lr)
C6 ~(outlierp (first lr) m d)

(filter-out-t (rest lr) m d (cons (first lr) nil)) 
= {def filter-out-t; C5, C6}
(filter-out-t (rest lr) m d (cons (first lr) nil))
= {axiom cons}
(filter-out-t (rest lr) m d (list (first lr)))

// induction of filter-out-t (same as previous induction & add unused contexts from 
   the original proof)
1st case trivial

C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 (endp (rest lr))

(filter-out-t (rest lr) m d (list (first lr)))
= {C4}
(filter-out-t nil m d (list (first lr)))
= {def filter-out-t}
(rev (list (first lr)))
= {def rev; axiom list, first}
(list (first lr))

(cons (first lr) (filter-out-t (rest lr) m d nil))
= {def filter-out-t, rev; C4}
(cons (first lr) nil)
= {axiom cons}
(list (first lr))


C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 ~(endp (rest lr))
C5 (outlierp (first (rest lr)))
C6 (filter-out-t (rest (rest lr)) m d (list (first lr))) =
   (cons (first lr) (filter-out-t (rest (rest lr)) m d nil))


(filter-out-t (rest lr) m d (list (first lr)))
= {def filter-out-t; C4, C5}
(filter-out-t (rest lr) m d (list (first lr)))
= {C6}
(cons (first lr) (filter-out-t (rest (rest lr)) m d nil))

(cons (first lr) (filter-out-t (rest lr) m d nil))
= {def filter-out-t}
(cons (first lr) (filter-out-t (rest (rest lr)) m d nil))

C1 (lorp lr)
C2 (rationalp m)
C3 (loprp d)
C4 ~(endp (rest lr))
C5 ~(outlierp (first (rest lr)))
C6 (filter-out-t (rest (rest lr)) m d (cons (first (rest lr)) (list (first lr)))) =
   (cons (first lr) (filter-out-t (rest (rest lr)) m d (cons (first (rest lr)) nil)))

(filter-out-t (rest lr) m d (list (first lr)))
= {def filter-out-t; C4, C5}
 (filter-out-t (rest (rest lr)) m d (cons (first (rest lr)) (list (first lr))))
= {C6}
(cons (first lr) (filter-out-t (rest (rest lr)) m d (cons (first (rest lr)) nil)))

   
(cons (first lr) (filter-out-t (rest lr) m d nil))
= {def filter-out-t}
(cons (first lr) (filter-out-t (rest (rest lr)) m d (cons (first (rest lr)) nil)))

remove_mean_lemma:
(rationalp x) /\ (lorp lor) =>
(mean (cons x lor)) = (/ (+ x (* (mean lor) (len lor))) (+ (len lor) 1))

C1 (rationalp x)
C2 (lorp lor)

(mean (cons x lor))
={def mean; axiom cons, if}
(/ (sum-lr (cons x lor)) (len (cons x lor)))
= {def sum-lr; axiom cons}
(/ (+ x (sum-lr lor)) (len (cons x lor)))
= {undo_mean_lemma; def len; axiom cons}
(/ (+ x (* (mean lor) (len lor))) (+ (len lor) 1))
= right

undo_mean_lemma
(lorp l) => (sum-lr l) = (* (mean l) (len l))

//induction scheme - len
1st case trivial

C1 (lorp l)
C2 (endp l)

(* (mean l) (len l))
= {def mean, len; C2}
(* 0 0)
= {Arithmetic}
0

(sum-lr l)
= {def sum-lr; C2}
0

C1 (lorp l)
C2 ~(endp l)

(* (mean l) (len l))
= {def mean; C2}
(* (/ (sum-lr l) (len l)) (len l))
= {Arithmetic}
(sum-lr l)
= left

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
G. A Heap of Work

Consider the binary heap data definition above.

A heap is a semi-ordered tree-based data structure such that the "top" or root node of 
a heap is the smallest element in the structure.  This is considered a min heap.  A max heap 
(not discussed here) has the largest value as the root node. A binary heap is a binary tree 
such that the value of the two children of any given node must be larger than the parent's 
value.  Hence a heap may look like this.
    3
 5     6
7 8   7 9

Calling pop on this heap gives the following
    5 
 7     6
  8   7 9

Popping again gives:
    6
 7     7
  8     9
  
Inserting the value 5 results in the following structure:
    6
 7     7
5 8     9

And then a series of operations which bubble the 5 up to the appropriate point
    5
 6     7
7 8     9

For more information on heaps see: https://en.wikipedia.org/wiki/Heap_(data_structure)

We will consider the following functions:
Insert: adds a value to the heap. The position of the value within the heap will vary
depending on the implementation
emptyp: Returns a boolean whether a heap is empty or not.
Pop: Remove the root node of the heap and adjust the heap accordingly.

G1.
What other basic functions should a heap have if implemented in ACL2s? Only write functions 
that cannot be created by a series of other basic functions.  

For example, function "heap-size" which returns the number of values in the heap 
would not be acceptable because it can be written  as a series of pop operations until 
the heap is empty.

* Give at least 2 "independent functions" that cannot be defined in terms of insert, emptyp,
or pop.
* You do not need to write the functions and your answers should be relatively simple but 
you need to clearly identify what the function does (like the the functions listed above).
* Feel free to implement the functions if you want to. Your answer will be a lot more 
obvious in such a case.

// creates a new heap
new-heap

// checks if input is a heap
heapp

// returns the maximum value in the heap
max-heap

// returns the minimum value in the heap
min-heap

|#
:logic

(defdata BinHeap
  (oneof nil
         (list rational BinHeap BinHeap)))

;; These functions can be difficult to admit so we will not
;; admit them in logic mode.  Your properties in G2 also don't need
;; to be proven as theorems.
:program

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; new-node: Rational x BinHeap x BinHeap -> BinHeap
;; (newnode v c1 c2) is a helper function
;; that makes a heap node with v as the value
;; and c1 and c2 as child nodes.
(defunc new-node (v c1 c2)
  :input-contract (and (rationalp v)(BinHeapp c1)(BinHeapp c2))
  :output-contract (BinHeapp (new-node v c1 c2))
  (list v c1 c2))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emptyp: BinHeap -> Boolean
;; (emptyp h) takse a heap h and returns
;; true if it is empty (has no values)
(defunc emptyp (h)
  :input-contract (BinHeapp h)
  :output-contract (booleanp (emptyp h))
  (equal h nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; heap-size: BinHeap -> Nat
;; (heap-size h) takes a heap h and returns
;; the number of values in it. An empty heap
;; returns 0.
(defunc heap-size (h)
  :input-contract (BinHeapp h)
  :output-contract (natp (heap-size h))
  (if (emptyp h)
    0
    (+ 1 (+ (heap-size (second h))
            (heap-size (third h))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; balance: BinHeap -> BinHeap
;; (balance par) takes a "parent" heap node par 
;; and swaps parent and child values if a child
;; node value is less than the parent's value
;; This works under the assumption that before 
;; insertion the heap is well formed. Thus at MOST 
;; one child can have a smaller value than the parent node.
(defunc balance (par)
  :input-contract (BinHeapp par)
  :output-contract (BinHeapp (balance par))
  (if (emptyp par)  
    par
    (let ((c1 (second par))
          (c2 (third par)))
      (cond ((and (not (emptyp c1))(< (first c1)(first par)))
             (new-node (first c1) 
                       (new-node (first par)(second c1)(third c1))
                       c2))
            ((and (not (emptyp c2))(< (first c2)(first par)))
             (new-node (first c2)  c1
                       (new-node (first par)(second c2)(third c2))))
            (t  par)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; insert: Rational x BinHeap -> BinHeap
;; (insert r h) inserts r at the shallowest
;; branch of the heap and then rebalances the heap
;; up to the root node to ensure the heap structure
;; maintained.
(defunc insert (r h)
  :input-contract (and (rationalp r)(BinHeapp h))
  :output-contract (BinHeapp (insert r h))
  (if (emptyp h)
    (list r nil nil)
    (let ((lDepth (heap-size (second h)))
          (rDepth (heap-size (third h))))
      (if (<= lDepth rDepth)
        (balance (new-node (first h) (insert r (second h)) (third h)))
        (balance (new-node (first h) (second h) (insert r (third h))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pop: BinHeap -> BinHeap
;; (pop h) removes the root element of the heap 
;; (the min value in the heap),  fixes the structure
;; and then returns the revised heap.
(defunc pop (h)
  :input-contract (BinHeapp h)
  :output-contract (BinHeapp (pop h))
  (cond ((emptyp h)  h)
        ((and (emptyp (second h))(emptyp (third h))) nil)
        ((emptyp (second h)) (third h))
        ((emptyp (third h)) (second h))
        ((< (first (second h))(first (third h))) 
         (list (first (second h)) (pop (second h))(third h)))
        (t  (list (first (third h)) (second h)(pop (third h))))))

;; Valid-heapp and valid-node are not strictly needed for heap definitions but it can help
;; with your testing.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; valid-heapp: BinHeap -> Boolean
;; (valid-heapp h) checks if the value of h is less than
;; or equal to the value of any child nodes.
(defunc valid-node (h)
  :input-contract (BinHeapp h)
  :output-contract (booleanp (valid-node h))
  (cond ((emptyp h) t)
        ((and (emptyp (second h))(emptyp (third h))) t)
        ((emptyp (second h)) (<= (first h)(first (third h))))
        ((emptyp (third h))  (<= (first h)(first (second h))))
        (t (and (<= (first h)(first (second h)))
                (<= (first h)(first (third h)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; valid-heapp: All -> Boolean
;; (valid-heapp h) traverses a heap h to confirm that
;; all child node values are strictly greater than the 
;; parent node values. If h is not a heap than return nil.
(defunc valid-heapp (h)
  :input-contract t
  :output-contract (booleanp (valid-heapp h))
  (if (not (BinHeapp h))
    nil    
    (if (emptyp h)
      t
      (if (valid-node h)
        (and (valid-heapp (second h))
             (valid-heapp (third h)))
        nil))))
  
  (defconst *test-heap* (insert 6 (insert 1 (insert 4 (insert 2 nil)))))
  (check= (valid-heapp *test-heap*) t)
  (check= (valid-heapp (pop *test-heap*)) t)

;; ....................

 
#|
G2.
 Above you can see an implementation of insert, emptyp and pop. For anyone who has 
 implemented a heap before, you'll notice how inefficient this implementation is. 
 In a language like Java, an array can be used and the place to insert the next 
 value is relatively fast. This begs the question: what guarantees does any heap 
 implementation need?
 * Write at least 2 more properties of a min heap that all implementations
   MUST pass. You can include the functions you described in G1.
 * Properties should be independent. A way to show this is to change the implementation
   of the functions and observe only the one property is no longer satisfied. We did
   this for properties of stacks in the lecture.
 * Properties should be written as a ACL2s theorem definition OR as a test?. 
   -If you want to test your functions (if you implemented code for G1), you can write
   test? to test if your properties are likely correct.  
   - If you simply wrote a function description, write the theorem as a comment.
 * See Chapter 8 of the lecture notes for more information about abstract data types
   and independent properties.
   
|#

;; Here are a couple properties
(test? (implies (and (rationalp r)(BinHeapp h)(emptyp h)) 
                (emptyp (pop (insert r h)))))

(test? (implies (valid-heapp h)
                (equals (balance h) h)))

(test? (implies (and (valid-heapp h) (not (emptyp h)))
                ((heap-size (pop h)) = (- (heap-size h) 1))))

#| Good luck on the exam everyone. |#