
; Extending QF_S:
; constant emptybag, 
; the function bag, 
; the multiset comparison operator <=, bag-le, bag-gt, bag-ge
; bagunion, intersection, difference of multisets
; an element is contained in a multiset

(set-logic QF_SLRDI)

;; declare sorts
(declare-sort Lst_t 0)

;; declare fields
(declare-fun next () (Field Lst_t Lst_t))
(declare-fun data () (Field Lst_t Int))

;; declare predicates
(define-fun slseg ((?E Lst_t) (?d1 Int)  (?F Lst_t) (?d2 Int)) Space (tospace 
	(or 
	(and (= ?E ?F) 
		(tobool emp
		)
		(= ?d1 ?d2)
	)
 
	(exists ((?X Lst_t)  (?d3 Int)) 
	(and  (<= ?d1 ?d3)
		(tobool (ssep 
		(pto ?E (sref (ref next ?X) (ref data ?d1)) ) 
		(slseg ?X ?d3 ?F ?d2)
		)
		)
		
	) 
	)
	)
))

;; declare variables
(declare-fun root () Lst_t)
(declare-fun cur1 () Lst_t)
(declare-fun X () Lst_t)
(declare-fun M0 () BagInt)
(declare-fun M1 () BagInt)
(declare-fun M2 () BagInt)
(declare-fun key () Int)
(declare-fun d () Int)
(declare-fun d0 () Int)
(declare-fun d1 () Int)
(declare-fun d2 () Int)
(declare-fun d3 () Int)
(declare-fun ret () Int)

;; declare set of locations

(declare-fun alpha1 () SetLoc)
(declare-fun alpha2 () SetLoc)
(declare-fun alpha3 () SetLoc)

;; VC3: slseg(root,cur1,M0,M1) * cur1 |-> (((next,X),(data,d)) * slist(X,M2) & 
;; M1 = {d} cup M2 & d <= M2 & d > key & (key in M0 <=> key in M1) & ret = 0 |-
;; slist(root,M0) ! (key in M0) & ret = 0


(assert 
	(and
	(tobool 
	(ssep 
		(index alpha1 (slseg root d0 cur1 d1) ) 
		(pto cur1 (sref (ref next X) (ref data d) ) ) 
		(index alpha2 (slseg X d2 nil d3) )
	))
	(<=  d1 d) (<= d d2)
	(> d key) (< key d2)
	(= ret 0)
	)
)

(assert (not 
	(and 
	(tobool 
		(index alpha3 (slseg root d0 nil d3)) 
	)
	(= ret 0)
	)
))

(check-sat)