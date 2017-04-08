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
CS 2800 Homework 7 - Spring 2017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Purpose of this Assignment:

We realize that you all have lots on your plate right now and that you're
frantically preparing for the exam (provided you read this before the exam)
This homework is designed solely to give you more practice for the exam
and is thus designed to potentially be finished before Thursday.  It
is also meant to be not as time intensive as the previous assignments.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

This homework is to be done in a group of 2-3 students. 

If your group does not already exist:

 * One group member will create a group in BlackBoard
 
 * Other group members then join the group
 
 Submitting:
 
 * Homework is submitted by one group member. Therefore make sure the person
   submitting actually does so. In previous terms when everyone needed
   to submit we regularly had one person forget but the other submissions
   meant the team did not get a zero. Now if you forget, your team gets 0.
   - It wouldn't be a bad idea for group members to send confirmation 
     emails to each other to reduce anxiety.

 * Submit the homework file (this file) on Blackboard.  Do not rename 
   this file.  There will be a 10 point penalty for this.

 * You must list the names of ALL group members below, using the given
   format. This way we can confirm group membership with the BB groups.
   If you fail to follow these instructions, it costs us time and
   it will cost you points, so please read carefully.


Names of ALL group members: Mahitha Valluru, Preeta Hopwood, Tam Vu

Note: There will be a 10 pt penalty if your names do not follow 
this format.

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROPOSITIONAL LOGIC

We use the following ascii character combinations to represent the Boolean
connectives:

  NOT     ~

  AND     /\
  OR      \/ 

  IMPLIES =>

  EQUIV   =
  XOR     <>

The binding powers of these functions are listed from highest to lowest
in the above table. Within one group (no blank line), the binding powers
are equal. This is the same as in class.

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROGRAMMING:

For (parts of) this homework you will need to use ACL2s.

Technical instructions:

- open this file in ACL2s as hw07.lisp

- make sure you are in BEGINNER mode. This is essential! Note that you can
  only change the mode when the session is not running, so set the correct
  mode before starting the session.

- insert your solutions into this file where indicated (usually as "...")

- only add to the file. Do not remove or comment out anything pre-existing
  unless we are asking you to fix the code.

- make sure the entire file is accepted by ACL2s. In particular, there must
  be no "..." left in the code. If you don't finish all problems, comment
  the unfinished ones out. Comments should also be used for any English
  text that you may add. This file already contains many comments, so you
  can see what the syntax is.

- when done, save your file and submit it as hw07.lisp

- avoid submitting the session file (which shows your interaction with the
  theorem prover). This is not part of your solution. Only submit the lisp
  file.
  
We will use ACL2s' check= function for tests. This is a two-argument
function that rejects two inputs that do not evaluate equal. You can think
of check= roughly as defined like this:

(defunc check= (x y)
  :input-contract (equal x y)
  :output-contract (equal (check= x y) t)
  t)

That is, check= only accepts two inputs with equal value. For such inputs, t
(or "pass") is returned. For other inputs, you get an error. If any check=
test in your file does not pass, your file will be rejected.

Calls to test? are considered even more powerful.  Try to use
both
|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Equational Reasoning and Logical Equivalences

Here are some notes about equational proofs (and logical equivalence
when applicable):

1. The context: Remember to use propositional logic to rewrite
the context so that it has as many hypotheses as possible.  See
the lecture notes for details. Label the facts in your
context with C1, C2, ... as in the lecture notes.

2. The derived context: Draw a dashed line (----) after the context 
and add anything interesting that can be derived from the context.  
Use the same labeling scheme as was used in the context. Each derived
fact needs a justification. Again, look at the lecture notes for
more information.

3. Use the proof format shown in class and in the lecture notes,
which requires that you justify each step.  Explicitly name each
axiom, theorem or lemma you use but you can use any "shortcut"
we've used in lab or in the lectures. For example, you
do not need to cite the if axioms when using a definitional axiom.
Look at the lecture notes for examples.

5. When using the definitional axiom of a function, the
justification should say "Def. <function-name>".  When using the
contract theorem of a function, the justification should say
"Contract <function-name>".

6. Arithmetic facts such as commutativity of addition can be
used. The name for such facts is "arithmetic".

7. You can refer to the axioms for cons, and consp as the "cons axioms", 
Axioms for first and rest can be referred to as "first-rest axioms".
The axioms for if are named "if axioms"

8. Any propositional reasoning used can be justified by "propositional
reasoning", "Prop logic", or "PL", except you should use "MP" 
to explicitly identify when you use modus ponens and MT for Modus Tollens.

9. For any given propositional expression, feel free to re-write it
in infix notation (ex A =>(B/\C)).

10. For this homework, you can only use theorems we explicitly
tell you you can use or we have covered in class / lab / previous
assignments. You can, of course, use the definitional axiom and contract 
theorem for any function used or defined in this homework. You
may also use theorems you've proven earlier in the homework.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

For each conjecture make sure you:

- Perform contract checking and contract completion. This is to make 
  all functions in the conjecture pass all input contracts.
  
- Run some tests to make an educated guess as to whether the conjecture is
  true or false. In the latter case, give a counterexample to the
  conjecture, and show that it evaluates to false. Else, give a proof 
  using equational reasoning, following instructions 1 to 10 above.

|#


#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section 1: Propositional Expressions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Simplify each of the following propositional expressions using 
logical equivalences like we have done in previous assignments 
and then group them based on what they are equivalent to.  

For example, the following 3 expressions would be grouped as follows:
EX1) a /\ (b \/ a ) 
     = {Absorption}
     a
EX2) (a /\ T) /\ ~a
     = {Associativity, Commutative}
     (a /\ ~a /\ T)
     = {(p /\ nil) = nil, p/\~p = nil}
     nil
EX3) ~a => a
     = {~p => p = p}
     a

Group 1 (A): EX1 EX3
Group 2 (nil): EX2

1) (( a /\ b ) \/ ( b /\ c )) /\ ( d /\ a ) /\ ( ~b \/ ~d )
   = {Distributivity}
   (((a /\ b) \/ b) /\ ((a /\ b) \/ c)) /\ (d /\ a) /\ (~b \/ ~d)
   = {Absorption}
   (b /\ ((a /\ b) \/ c)) /\ (d /\ a) /\ (~b \/ ~d)
   = {Distributivity}
   (b /\ ((a \/ c) /\ (b \/ c))) /\ (d /\ a) /\ (~b \/ ~d)
   = {Simplification}
   (b /\ (a \/ c) /\ (b \/ c)) /\ (d /\ a) /\ (~b \/ ~d)
   = {Equality}
   (b /\ (b \/ c) /\ (a \/ c)) /\ (d /\ a) /\ (~b \/ ~d)
   = {Absorption}
   (b /\ (a \/ c)) /\ (d /\ a) /\ (~b \/ ~d)
   = {Simplification}
   b /\ (a \/ c) /\ (d /\ a) /\ (~b \/ ~d)
   = {Equality}
   b /\ (~b \/ ~d) /\ (a \/ c) /\ (d /\ a)
   = {Distributivity}
   ((b /\ ~b) \/ (b /\ ~d)) /\ (a \/ c) /\ (d /\ a)
   = {Equality}
   (nil \/ (b /\ ~d)) /\ (a \/ c) /\ (d /\ a)
   = {Equality}
   (b /\ ~d) /\ (a \/ c) /\ (d /\ a)
   = {Equality}
   (a \/ c) /\ (b /\ ~d) /\ (d /\ a)
   = {Associativity}
   (a \/ c) /\ (b /\ a) /\ (~d /\ d)
   = {Equality} 
   (a \/ c) /\ (b /\ a) /\ nil
   = {Equality}
   nil
   

  
2) a \/ ( p => ~p ) \/ ( b /\ a )
   = {p => ~p = ~p}
   a \/ ~p \/ (b /\ a)
   = {Commutativity}
   a \/ (b /\ a) \/ ~p
   = {Absorption}
   a \/ ~p
   
   

  
3) ( b = b ) /\ (( b <> b ) \/ a)
   = {Equality}
   T /\ ((b <> b) \/ a)
   = {Equality involving T}
   ((b <> b) \/ a)
   = {Equality involving Xor}
   (nil \/ a)
   = {Equality involving nil}
   a

4) p /\ ~a  => nil
   = {Definition of implies}
   ~(p /\ ~a) \/ nil
   = {Equality involving nil}
   a \/ ~p 

5) ( a <> ~a ) => ( ~p \/ a ) /\ ( ~a /\ p )
   = {Equality involving Xor}
   T => (~p \/ a) /\ (~a /\ p)
   = {De Morgan's, commutative}
   T => ~(~a /\ p) /\ (~a /\ p)
   = {(x (~a /\ p)), x /\ ~x = nil}
   T => nil
   = {Definition of implies}
   nil


6) ~(t => p <> ~( p /\ a ) => ~( p => ~a )) 
   = {Definition of implies}
   ~(p <> ~( p /\ a ) => ~( p => ~a ))
   = {Definition of implies}
   ~(p <> ~( p /\ a ) => ~(~p \/ ~a))
   = {De Morgan's, equality with nil}
   ~(p <> ~(p /\ a)  => (p /\ a))
   = {(x (p /\ a)), ~x => x = x}
   ~(p <> (p /\ a))
   = {definition of xor}
   ~(p = (p /\ a))
   = {equality}
   t
   
Indicate your groups here:
Group 1 (nil): 1 5 
Group 2 (a \/ ~p): 2 4
Group 4 (a): 3
Group 5 (t): 6

|#

#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section 2: Truth Tables & Classifications
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Write a truth table for each of these expressions
then clearly state if the expression is valid, satisfiable,
falsifiable, or unsatisfiable. Truth tables should
have a column for each sub-part of the expression like
you wrote in a previous homework.

a) ~( p /\ ~q ) => q

  p  |  q  |  ~q  |  (p /\ ~q)   |  ~(p /\ ~q)   |   ~(p /\ ~q) => q
=====================================================================
  F  |  F  |   T  |      F       |       T       |         F         
  F  |  T  |   F  |      F       |       T       |         T         
  T  |  F  |   T  |      T       |       F       |         T         
  T  |  T  |   F  |      F       |       T       |         F  

  The expression is satisfiable and falsifiable.

 
b) ( p /\ q <> r) <> r
Notice anything about xor?  What is ( p /\ q ) <> ( r <> r ) 
(you don't need to write this truth table)?

  p  |  q  |   r  |    p /\ q    |  p /\ q <> r  | (p /\ q <> r) <> r
=====================================================================
  F  |  F  |   F  |      F       |       F       |         F         
  F  |  F  |   T  |      F       |       T       |         F         
  F  |  T  |   F  |      F       |       F       |         F         
  F  |  T  |   T  |      F       |       T       |         F  
  T  |  F  |   F  |      F       |       F       |         F         
  T  |  F  |   T  |      F       |       T       |         F         
  T  |  T  |   F  |      T       |       T       |         T         
  T  |  T  |   T  |      T       |       F       |         T
  
  (p /\ q <> r) <> r is equivalent to p /\ q, so we did not need to include the last
  two columns. Xor basically "cancels out" and we are left with p /\ q.
  
  The expression is satisfiable and falsifiable.


|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section 3: PROGRAMMING IN ACL2s
;; Quadoku Validator
;; For Information on how to play sudoku: 
;; http://www.sudokukingdom.com/rules.php
;; or https://en.wikipedia.org/wiki/Sudoku
;; 
;; Instead of Sudoku which uses a 9x9 board, we will play 
;; Quadoku which uses a 4x4 board. For each row, column or block of
;; 4 cells, the group is considered valid if the numbers 1-4 are
;; present. Thus numbers are not duplicated and there are no blank
;; cells (indicated by 0). Blocks of cells are the four 2x2 
;; groups that compose the main board. 
;;
;; Let's make a Quadoku tester such that any quadoku board can be 
;; evaluated as to whether it was done correctly, there are empty 
;; cells or there is a mistake in the solution.
;; Any invalid row, column or block means the quadoku board has 
;; not been solved correctly.

;; The set of admissible symbols in a 4x4 quadoku grid.
(defdata qval (range integer (0 <= _ <= 4)))

;; A group of quadoku numbers consists of 4 positions
;; (a row, column, or 2x2 block) which are positive numbers
;; or 0.
(defdata qgroup (list qval qval qval qval))

;; Make a defdata for group-type which is a 'row, 'column or 'block
(defdata group-type (oneof 'row 'column 'block)) ;; SOLUTION

;; a quadoku board contains 4 qgroups indicating
;; each ROW of the board. Define this data structure
(defdata q-board (list qgroup qgroup qgroup qgroup)) ;; SOLUTION

;; Make your own quadoku board to test your results.
;; Here is one to play with.
(defconst *test-row1* (list 1 2 3 4))
(defconst *test-row2* (list 1 2 3 4))
(defconst *test-row3* (list 1 2 3 4))
(defconst *test-row4* (list 1 2 3 4))

(defconst *test-board* (list *test-row1* *test-row2* 
                             *test-row3* *test-row4* ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start: Useful functions / theorems for sections 3 & 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; len2: list -> natp
;; (len2 l) returns the number of elements in list l
(defunc len2 (l)
  :input-contract (listp l)
  :output-contract (natp (len2 l))
  (if (endp l)
    0
    (+ 1 (len2 (rest l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; in2: list -> boolean
;; (in2 a l) returns true iff a is an element
;; in l.  Otherwise return nil.
(defunc in2 (a l)
  :input-contract (listp l)
  :output-contract (booleanp (in2 a l))
  (if (endp l)
    nil
    (or (equal a (first l)) (in2 a (rest l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; no-dupes: list -> boolean
;; (no-dupes l) takes a list l and returns true
;; iff there are no duplicate elements in l
(defunc no-dupes (l)
  :input-contract (listp l)
  :output-contract (booleanp (no-dupes l))
  (if (endp l)
    t
    (if (in2 (first l)(rest l))
      nil
      (no-dupes (rest l)))))

(test? (implies (and (listp l1) (listp l2) (listp l3))
                (not (no-dupes (app l1 (app (cons e1 l2)(cons e1 l3)))))))
(test? (implies (and (listp l)(no-dupes l))
                (not (in2 (first l) (rest l)))))

(check= (no-dupes '(a b c d e)) t)
(check= (no-dupes '(a b c b e)) nil)
(check= (no-dupes nil) t)
(check= (no-dupes '(a)) t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; num-unique: list -> natp
;; (num-unique l) takes a list and returns the number
;; of unique elements in it.
(defunc num-unique (l)
  :input-contract (listp l)
  :output-contract (natp (num-unique l))
  (cond ((endp l) 0)
        ((in2 (first l)(rest l)) (num-unique (rest l)))
        (t                      (+ 1 (num-unique (rest l))))))

(check= (num-unique '(1 2 3 4 3 2 1)) 4)
(test? (implies (and (listp l)(not (in2 a l)))
                (equal (num-unique (cons a l))(+ 1 (num-unique l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theorems to help you code: you can use them in your proofs
;; later and it may help ACL2s prove things about your code.
(defthm q-group-len-thm (implies (qgroupp q)(equal (len q) 4)))
(defthm q-board-len-thm (implies (q-boardp b)
                                 (equal (len b) 4)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; END: Useful functions / Theorems for Sections 3 & 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make your own quadoku board to test your results.
;; The boards below are used in later tests so make a new
;; board.
(defconst *test2-row1* (list 1 2 3 4))
(defconst *test2-row2* (list 3 4 2 1))
(defconst *test2-row3* (list 4 3 1 2))
(defconst *test2-row4* (list 2 1 4 3))

(defconst *test2-board* (list *test2-row1* *test2-row2* 
                              *test2-row3* *test2-row4* ))

(defconst *test3-row1* (list 0 2 0 4))
(defconst *test3-row2* (list 3 0 2 1))
(defconst *test3-row3* (list 4 3 0 0))
(defconst *test3-row4* (list 0 1 4 3))

(defconst *test3-board* (list *test3-row1* *test3-row2* 
                              *test3-row3* *test3-row4* ))

;; new quadoku board
(defconst *row1* (list 3 4 2 1))
(defconst *row2* (list 1 2 4 3))
(defconst *row3* (list 2 1 3 4))
(defconst *row4* (list 4 3 1 2))

(defconst *column1* (list 3 1 2 4))
(defconst *column2* (list 4 2 1 3))
(defconst *column3* (list 2 4 3 1))
(defconst *column4* (list 1 3 4 2))

;; goes from top left to top right to bottom left to bottom right
(defconst *block1* (list 3 4 1 2))
(defconst *block2* (list 2 1 4 3))
(defconst *block3* (list 2 1 4 3))
(defconst *block4* (list 3 4 1 2))

;; qboards with the same value
(defconst *qboardR* (list *row1* *row2* *row3* *row4*))

;; q-idx either represents a valid index into the quadoku board
;; OR a filled in value on the board.
(defdata q-idx (range integer (0 < _ <= 4)))
(check= (q-idxp 0) nil)
(check= (q-idxp 1) t)
(check= (q-idxp 3) t)
(check= (q-idxp 4) t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; valid-qgroupp: qgroup -> Boolean
;; (valid-qgroupp g) returns true if the qgroup
;; g contains values 1-4 with no repetition.
(defunc valid-qgroupp (g)
  :input-contract (qgroupp g)
  :output-contract (booleanp (valid-qgroupp g))
  (and (not (in2 0 g))(no-dupes g)))

(check= (valid-qgroupp *test2-row4*) t)
(check= (valid-qgroupp *test-row1*) t)

;;;;;;;;;;;;;;;;;; WRITE ADDITIONAL TESTS ;;;;;;;;;;;;;;;;;;;;;;;;

(check= (valid-qgroupp *column1*) t)
(check= (valid-qgroupp *block1*) t)
(check= (valid-qgroupp *row1*) t)
(check= (valid-qgroupp *test3-row1*) nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FIX THE CODE: this can include changing the signature
;;               or the function body
;; get-group-cell: q-idx x qgroup -> qval
;;
;; (get-group-cell c g) takes a column index c
;; and a qgroup g and returns the value at cell c.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defunc get-group-cell (c g)
  :input-contract (and (q-idxp c)
                       (qgroupp g))
  :output-contract (qvalp (get-group-cell c g))
  (cond ((equal c 1) (first g))
        ((equal c 2) (second g))
        ((equal c 3) (third g))
        (t           (fourth g))))

(check= (get-group-cell 2 *column1*) 1)
(check= (get-group-cell 4 *column2*) 3)
(check= (get-group-cell 3 *column1*) 2)
(check= (get-group-cell 1 *column2*) 4)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINE
;; get-cell: q-idx x q-idx x q-board -> qvalp
;;
;; (get-cell r c b) takes a row index r, a column index c
;; and a q-board b and returns the value at cell (r, c).
;; Notice positions start at 1 and not 0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defunc get-cell (r c b)
  :input-contract (and (q-idxp r) (q-idxp c) (q-boardp b))
  :output-contract (qvalp (get-cell r c b))
  (cond ((equal r 1) (get-group-cell c (first b)))
        ((equal r 2) (get-group-cell c (second b)))
        ((equal r 3) (get-group-cell c (third b)))
        (t       (get-group-cell c (fourth b)))))

(check= (get-cell 2 3 *test2-board*) 2)
(check= (get-cell 1 1 *test3-board*) 0)
(check= (get-cell 4 1 *qboardR*) 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINE
;; get-row: q-idx x q-board -> qgroup 
;; (get-row idx b) take an q-idx idx between 1 and 4 and
;; a quadoku board b and returns a qgroup representing 
;; all elements in the idx-th row of b. 
(defunc get-row (idx b)
  :input-contract (and (q-idxp idx) (q-boardp b))
  :output-contract (qgroupp (get-row idx b))
  (cond ((equal idx 1) (first b))
        ((equal idx 2) (second b))
        ((equal idx 3) (third b))
        (t             (fourth b))))

(check= (get-row 1 *test2-board*) *test2-row1*)
(check= (get-row 4 *test2-board*) *test2-row4*)
(check= (get-row 2 *qboardR*) *row2*)
(check= (get-row 3 *qboardR*) *row3*)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINE
;; get-column: q-idx x q-board -> qgroup 
;; (get-column idx b) take an q-idx idx between 1 and 4 
;; and a quadoku board b and returns a qgroup representing
;; all elements in the idx-th column of b.
(defunc get-column (idx b)
  :input-contract (and (q-idxp idx) (q-boardp b))
  :output-contract (qgroupp (get-column idx b))
  (cond ((equal idx 1) (list (first (first b))
                             (first (second b))
                             (first (third b))
                             (first (fourth b))))
        ((equal idx 2) (list (second (first b))
                             (second (second b))
                             (second (third b))
                             (second (fourth b))))
        ((equal idx 3) (list (third (first b))
                             (third (second b))
                             (third (third b))
                             (third (fourth b))))
        (t             (list (fourth (first b))
                             (fourth (second b))
                             (fourth (third b))
                             (fourth (fourth b))))))

(check= (get-column 1 *test2-board*) '(1 3 4 2))
(check= (get-column 4 *test2-board*) '(4 1 2 3))

(check= (get-column 2 *qboardR*) *column2*)
(check= (get-column 3 *qboardR*) *column3*)

(defdata qidx-off (oneof 0 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; get-block-offset: qidx-off x qidx-off x q-board -> qgroup 
;; (get-block-offset offR offC b) takes two qidx-offset values
;; (offR for the row and offC for the column) and a q-board b.
;; A qgroup block offset from 1 1 by the offR and offC is 
;; returned.
(defunc get-block-offset (offR offC b)
  :input-contract (and (qidx-offp offR)(qidx-offp offC)(q-boardp b))
  :output-contract (qgroupp (get-block-offset offR offC b))
  (list (get-cell (+ offR 1) (+ offC 1) b)
        (get-cell (+ offR 1) (+ offC 2) b)
        (get-cell (+ offR 2) (+ offC 1) b)
        (get-cell (+ offR 2) (+ offC 2) b)))

(check= (get-block-offset 0 0 *qboardR*) *block1*)
(check= (get-block-offset 0 2 *qboardR*) *block3*)
(check= (get-block-offset 2 0 *qboardR*) *block2*)
(check= (get-block-offset 2 2 *qboardR*) *block4*)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINE
;; get-block: q-idx x q-board -> qgroup 
;; (get-block idx b) take an q-idxp idx between 1 and 4 and
;; a quadoku board b and returns a qgroup representing all 
;; elements in the idx-th block of b. Blocks are numbered 
;; from the top left (with cell (1,1)) to the top right (block 2
;; with cell 1, 4) and then from top to bottom
;; Thus block 4 includes cell (4,4). Cells in a block are 
;; numbered in the same way.
(defunc get-block (idx b)
  :input-contract (and (q-idxp idx) (q-boardp b))
  :output-contract (qgroupp (get-block idx b))
  (cond ((equal idx 1) (get-block-offset 0 0 b))
        ((equal idx 2) (get-block-offset 2 0 b))
        ((equal idx 3) (get-block-offset 0 2 b))
        (t             (get-block-offset 2 2 b))))
       
(check= (get-block 1 *test2-board*) '(1 2 3 4))
(check= (get-block 3 *test2-board*) '(3 4 2 1))
(check= (get-block 1 *test3-board*) '(0 2 3 0))

(check= (get-block 1 *qboardR*) *block1*)
(check= (get-block 2 *qboardR*) *block3*)
(check= (get-block 3 *qboardR*) *block2*)
(check= (get-block 4 *qboardR*) *block4*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** FIX CODE (and comment) to make it work***
;; valid-typep: group-type x q-idx x q-board
;;
;; (valid-typep type idx b) takes a symbol type and an 
;; q-board b and tests the validity of 
;; a qgroup type (row, column, block) from 1 to 4.  
(defunc valid-typep (type idx b)
  :input-contract (and (group-typep type)(q-idxp idx)(q-boardp b)) 
  :output-contract (booleanp (valid-typep type idx b))
  (cond ((equal type 'row)    (valid-qgroupp (get-row idx b)))
        ((equal type 'column) (valid-qgroupp (get-column idx b)))
        (t                    (valid-qgroupp (get-block idx b)))))
  
(check= (valid-typep 'row 1 *test-board*) t)
(check= (valid-typep 'column 1 *test-board*) nil)
(check= (valid-typep 'column 1 *test2-board*) t)
(check= (valid-typep 'block 1 *test2-board*) t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; valid-all-typep: group-type x q-board -> boolean
;; (valid-all-typep type b) takes a q-board b and 
;; a type of group (row, column, or block) and returns
;; whether all groups of that type are correctly
;; filled in.
(defunc valid-all-typep (type b)
  :input-contract (and (group-typep type)(q-boardp b))
  :output-contract (booleanp (valid-all-typep type b))
  (and (valid-typep type 1 b)(valid-typep type 2 b)
       (valid-typep type 3 b)(valid-typep type 4 b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GIVEN
;; valid-qboardp: q-board -> boolean
;; (valid-qboardp b) takes a q-board b and returns
;; whether it is correctly filled in with all
;; rows, columns, and blocks on the board having
;; valid values.
(defunc valid-qboardp (b)
  :input-contract (q-boardp b)
  :output-contract (booleanp (valid-qboardp b))
  (and (valid-all-typep 'row b)
       (valid-all-typep 'column b)
       (valid-all-typep 'block b)))

(check= (valid-qboardp *test-board*) nil)
(check= (valid-qboardp *test2-board*) t)

;;;;;;;;;;;;;; ADD YOUR OWN TESTS FOR YOUR OWN BOARD ;;;;;;;;;

(check= (valid-all-typep 'row *qboardR*) t)
(check= (valid-all-typep 'column *qboardR*) t)
(check= (valid-all-typep 'block *qboardR*) t)

(check= (valid-qboardp *qboardR*) t)#|ACL2s-ToDo-Line|#


#|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Section 4: Equational Reasoning
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Prove the following conjectures are valid.  Function definitions can
be found above in section 3.

a) **UNMARKED EXTRA PRACTICE**
   (implies (listp l)
            (implies (or (endp l)
                         (and (not (endp l))(in2 (first l)(rest l))
                              (implies (listp (rest l))(<= (num-unique (rest l))(len2 (rest l)))))
                         (and (not (endp l))(not (in2 (first l)(rest l)))
                              (implies (listp (rest l))(<= (num-unique (rest l))(len2 (rest l))))))
                     (<= (num-unique l)(len2 l))))

(listp l) =>
         ( (endp l) \/ ( ~(endp l) /\ (in2 (first l) (rest l)) /\ ((listp (rest l))
                       => ((num-unique (rest l)) <= (len2 (rest l)))))
                    \/ ( ~(endp l) /\ ~(in2 (first l) (rest l)) /\ ((listp (rest l))
                       => ((num-unique (rest l)) <= (len2 (rest l))))))
         => ((num-unique l) <= (len2 l))
         

((listp l) /\ (endp l)) \/
((listp l) /\ ( ~(endp l) /\ (in2 (first l) (rest l)) /\ 
              ((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l)))))) \/
((listp l) /\ ( ~(endp l) /\ ~(in2 (first l) (rest l)) /\
              ((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l))))))
=> ((num-unique l) <= (len2 l))



(((listp l) /\ (endp l)) => ((num-unique l) <= (len2 l)))
/\
(((listp l) /\ ( ~(endp l) /\ (in2 (first l) (rest l)) /\ 
((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l))))))
=> ((num-unique l) <= (len2 l)))
/\
(((listp l) /\ ( ~(endp l) /\ ~(in2 (first l) (rest l)) /\ 
((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l))))))
=> ((num-unique l) <= (len2 l)))

Conjecture 1:
(((listp l) /\ (endp l)) => ((num-unique l) <= (len2 l)))

C1 (listp l)
C2 (endp l)

(num-unique l)
= {def num-unique, endp; axiom cond; C2}
0

(len2 l)
= {def len2, endp; axiom if; C2}
0

Conjecture 2:
(((listp l) /\ ( ~(endp l) /\ (in2 (first l) (rest l)) /\ 
((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l))))))
=> ((num-unique l) <= (len2 l)))

C1 (listp l)
C2 ~(endp l)
C3 (in2 (first l) (rest l))
C4 (listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l)))
------------------------------------------------------------
C5 (consp l) {C2; def endp; Boolean Logic}
C6 (listp (rest l)) {C5; axiom listp, rest, consp}
C7 (num-unique (rest l)) <= (len2 (rest l)) {MP; C6}

(num-unique l)
= {def num-unique; axiom cond; C5, C3}
(num-unique (rest l))

(len2 l)
= {def len2; axiom if; C5}
(+ 1 (len2 (rest l)))

{C7}
(num-unique (rest l)) <= (len2 (rest l)) <= (+ 1 (len2 (rest l)))

Conjecture 3:
(((listp l) /\ ( ~(endp l) /\ ~(in2 (first l) (rest l)) /\ 
((listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l))))))
=> ((num-unique l) <= (len2 l)))

C1 (listp l)
C2 ~(endp l)
C3 ~(in2 (first l) (rest l))
C4 (listp (rest l)) => ((num-unique (rest l)) <= (len2 (rest l)))
-------------------------------------------------------------------
C5 (consp l) {C2; def endp; Boolean Logic}
C6 (listp (rest l)) {C5; axiom listp, rest, consp}
C7 (num-unique (rest l)) <= (len2 (rest l)) {MP; C6}

(num-unique l)
= {def num-unique; axiom cond; C5, C3}
(+ 1 (num-unique (rest l)))

(len2 l)
= {def len2; axiom if; C5}
(+ 1 (len2 (rest l)))

(+ 1 (num-unique (rest l))) <= (+ 1 (len2 (rest l)))
={Arithmetic}
(num-unique (rest l)) <= (len2 (rest l))
={C7}
t

b) (implies (and (listp l)(no-dupes l)) 
            (and (implies (endp l)(equal (num-unique l)(len2 l)))
                 (implies (and (not (endp l))
                               (implies (and (listp (rest l))(no-dupes (rest l)))
                                        (equal (num-unique (rest l))(len2 (rest l)))))
                          (equal (num-unique l)(len2 l)))))

(listp l) /\ (no-dupes l) => ((endp l) => ((num-unique l) = (len2 l))) /\
                             ((~(endp l) /\ 
                                       ((listp (rest l)) /\ 
                                       (no-dupes (rest l)) => ((num-unique l) = (len2 l))))
                              => ((num-unique l) = (len2 l)))
                              
Conjecture 1: 
(listp l) /\ (no-dupes l) => ((endp l) => ((num-unique l) = (len2 l)))
(listp l) /\ (no-dupes l) /\ (endp l) => ((num-unique l) = (len2 l))

C1 (listp l)
C2 (no-dupes l)
C3 (endp l)

(num-unique l)
= {def num-unique, endp; axiom cond; C3}
0

(len2 l)
= {def len2, endp; axiom if; C3}
0

Conjecture 2:
(listp l) /\ (no-dupes l) => ((~(endp l) /\ 
                                       ((listp (rest l)) /\ 
                                       (no-dupes (rest l)) => ((num-unique (rest l)) = (len2 (rest l)))))
                              => ((num-unique l) = (len2 l)))
(listp l) /\ (no-dupes l) /\ ~(endp l) /\ 
((listp (rest l)) /\ (no-dupes (rest l)) => ((num-unique (rest l)) = (len2 (rest l))))
                              => ((num-unique l) = (len2 l))
                              
C1 (listp l)
C2 (no-dupes l)
C3 ~(endp l)
C4 (listp (rest l)) /\ (no-dupes (rest l)) => ((num-unique (rest l)) = (len2 (rest l)))
---------------------------------------------------------------------------
C5 (consp l) {def endp; Boolean Logic; C3}
C6 (listp (rest l)) {C5}
C7 (no-dupes (rest l)) {def no-dupes; axiom if, consp; C2, C5}
C8 (num-unique (rest l)) = (len2 (rest l)) {C6, C7; MP}
C9 ~(in2 (first l) (rest l)) {C2; axiom if; def no-dupes}

(num-unique l)
= {def num-unique, endp; axiom cond, consp; C5}
(if (in2 (first l)(rest l)) 
    (num-unique (rest l)) 
    (+ 1 (num-unique (rest l))))
={C9; axiom if; }
(+ 1 (num-unique (rest l)))



(len2 l)
={def len2, endp; axiom if, consp; C5}
(+ 1 (len2 (rest l))
                     
(+ 1 (num-unique (rest l))) = (+ 1 (len2 (rest l)))
= {Arithmetic; C8}
t

We will claim that this gives us the following theorem (even if you don't
finish the proof)
Phi_nd_uniquelen: (implies (and (listp l)(no-dupes l))
                           (equal (num-unique l)(len2 l)))

                           
                           
c) The function valid-qgroupp seems strange.  We
don't actually check if 1-4 are all in the group. Instead we check 
for conditions that indicate they cannot all be in the group.
However, consider the following function:

(defunc valid-qgroup2p (g)
  :input-contract (qgroupp g)
  :output-contract (booleanp (valid-qgroup2p g))
  (and (in 1 g)(in 2 g)(in 3 g)(in 4 g)))

Prove the following conjecture is valid thus showing
that the functions are equivalent.
   (implies (qgroupp g) (and (implies (valid-qgroup2p g)
                                      (valid-qgroupp g))
                             (implies (valid-qgroupp g)
                                      (valid-qgroup2p g))))

You might want to look at q-group-len-thm above (ACL2s has proved this is
a theorem).

You can use any theorems above. You can also assume the following are theorems.
Phi_group4_nd: (implies (and (qgroupp g)(in 1 g)(in 2 g)(in 3 g)(in 4 g))
                        (no-dupes g))
Phi_exclude0: (implies (and (qgroupp g)(in 1 g)(in 2 g)(in 3 g)(in 4 g))
                            (not (in 0 g)))

Phi_unique_ex0: (implies (and (qgroupp g)(equal (num-unique g) 4)(not (in 0 g)))
                         (and (in 1 g)(in 2 g)(in 3 g)(in 4 g)))
                          

(qgroupp g) => ((valid-qgroup2p g) => (valid-qgroupp g)) /\ ((valid-qgroupp g) => (valid-qgroup2p g))

((qgroupp g) => ((valid-qgroup2p g) => (valid-qgroupp g))) /\ 
((qgroupp g) => ((valid-qgroupp g) => (valid-qgroup2p g)))

((qgroupp g) /\ (valid-qgroup2p g) => (valid-qgroupp g)) /\ 
((qgroupp g) /\ (valid-qgroupp g) => (valid-qgroup2p g))

Conjecture 1:
((qgroupp g) /\ (valid-qgroup2p g) => (valid-qgroupp g))   

C1 (qgroupp g)
C2 (valid-qgroup2p g)
---------------------
C3 (and (in 1 g)(in 2 g)(in 3 g)(in 4 g)) {def valid-qgroup2p; C2}
C4 (no-dupes g) {Phi_group4_nd; C1, C3; MP}
C5 (not (in 0 g)) {Phi_exclude0; C1, C3; MP}

(valid-qgroupp g)
={def valid-qgroupp}
(and (not (in2 0 g))(no-dupes g))
= {C4, C5; Boolean Logic}
t

Conjecture 2:
((qgroupp g) /\ (valid-qgroupp g) => (valid-qgroup2p g))

C1 (qgroupp g)
C2 (valid-qgroupp g)
---------------------
C3 (not (in2 0 g)) /\ (no-dupes g) {def valid-qgroupp}
C4 (num-unique g) == 4 {def qgroup, no-dupes}
C5 (and (in 1 g)(in 2 g)(in 3 g)(in 4 g)) {C1, C3, C4; Phi_unique_ex0}

(valid-qgroup2p g) 
= {def valid-qgroup2p}
(and (in 1 g)(in 2 g)(in 3 g)(in 4 g))
= {C5}
t


|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Feedback (5 points)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|

Each week we will ask a couple questions to monitor how the course
is progressing.  This should be a far shorter questionnaire than 
for HW05. 

Please fill out the following form.

https://goo.gl/forms/SRabgC8TXZhqJV3q1

As before, feedback is anonymous and each team member should fill out
the form (only once per person).

After you fill out the form, write your name below in this file, not
on the questionnaire. We have no way of checking if you submitted the
file, but by writing your name below you are claiming that you did,
and we'll take your word for it.  

5 points will be awarded to each team member for filling out the 
questionnaire.

The following team members filled out the feedback survey provided by 
the link above:
---------------------------------------------
Preeta Hopwood
Mahitha Valluru
Tam Vu

|#