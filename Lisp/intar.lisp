;D'Occhio	Mario	900002

;costante per l'infinito negativo.
(defconstant +neg-infinity+ '+neg-infinity+)

;costante per l'infinito positivo.
(defconstant +pos-infinity+ '+pos-infinity+)

;costante per l'intervallo vuoto.
(defconstant +empty-interval+ nil)

;funzione che ritorna l'intervallo vuoto.
(defun empty-interval ()
	+empty-interval+)

;definisco la somma sui reali estesi con gli infiniti.
(defun +e (&optional x y)
	(cond ((and (null x) (null y)) 0)
		  ((null y) x)
		  ((eql x +pos-infinity+)
				(cond ((eql y +pos-infinity+) +pos-infinity+)
					  ((eql y +neg-infinity+) (error "+inf-inf error"))
					  (T +pos-infinity+)))
		  ((eql x +neg-infinity+)
				(cond ((eql y +neg-infinity+) +neg-infinity+)
					  ((eql y +pos-infinity+) (error "-inf+inf error"))
					  (T +neg-infinity+)))
		  ((numberp x) 
				(cond ((numberp y) (+ x y))
					  ((eql y +pos-infinity+) +pos-infinity+)
					  ((eql y +neg-infinity+) +neg-infinity+)))
		  (T (error "input non valido"))))

;definisco la differenza sui reali estesi con gli infiniti.
;nel caso di input unario restituisce il reciproco additivo.
;ho definito entrambi i reciproci quando x = +-inf e y non c'è. 
(defun -e (x &optional y)
	(cond ((and (null y) (eql x +neg-infinity+)) +pos-infinity+)
		  ((and (null y) (eql x +pos-infinity+)) +neg-infinity+)
		  ((and (null y) (numberp x)) (- x))
		  ((eql x +pos-infinity+) 
				(cond ((eql y +pos-infinity+) (error "+inf-inf error"))
					  ((eql y +neg-infinity+) +pos-infinity+)
					  (T +pos-infinity+)))
		  ((eql x +neg-infinity+)
				(cond ((eql y +neg-infinity+) (error "-inf+inf error"))
					  ((eql y +pos-infinity+) +neg-infinity+)
					  (T +neg-infinity+)))
		  ((numberp x) 
				(cond ((numberp y) (- x y))
					  ((eql y +pos-infinity+) +neg-infinity+)
					  ((eql y +neg-infinity+) +pos-infinity+)))
		  (T (error "input non valido"))))

;definisco il prodotto sui reali estesi.
(defun *e (&optional x y)
	(cond ((and (null x) (null y)) 1)
		  ((null y) x)
		  ((eql x +pos-infinity+)
				(cond ((eql y +pos-infinity+) +pos-infinity+)
					  ((eql y +neg-infinity+) +neg-infinity+)
					  ((zerop y) (error "+inf * 0"))
					  ((minusp y) +neg-infinity+)
					  (T +pos-infinity+)))
		  ((eql x +neg-infinity+)
				(cond ((eql y +pos-infinity+) +neg-infinity+)
					  ((eql y +neg-infinity+) +pos-infinity+)
					  ((zerop y) (error "-inf * 0"))
					  ((minusp y) +pos-infinity+)
					  (T +neg-infinity+)))
		  ((minusp x)
				(cond ((eql y +pos-infinity+) +neg-infinity+)
					  ((eql y +neg-infinity+) +pos-infinity+)
					  (T (* x y))))
		  ((plusp x)
				(cond ((eql y +pos-infinity+) +pos-infinity+)
					  ((eql y +neg-infinity+) +neg-infinity+)
			          (T (* x y))))
		  (T (error "input non valido"))))

;definisco la divisione con i reali estesi.
(defun /e (x &optional y)
	(cond ((null y) (/ 1.0 x))
	      ((eql y 0) (error "divisione per zero"))
		  ((eql x 0) 0)
		  ((eql x +pos-infinity+)
				(cond ((eql y +pos-infinity+) (error "+inf/+inf"))
					  ((eql y +neg-infinity+) (error "+inf/-inf"))
					  ((plusp y) +pos-infinity+)
					  ((minusp y) +neg-infinity+)))
		  ((eql x +neg-infinity+)
				(cond ((eql y +pos-infinity+) (error "-inf/+inf"))
					  ((eql y +neg-infinity+) (error "-inf/-inf"))
					  ((plusp y) +neg-infinity+)
					  ((minusp y) +pos-infinity+)))
		  ((numberp x)
				(cond ((or (eql y +neg-infinity+) 
				           (eql y +pos-infinity+)) 0)
					  (T (/ x y))))
          (T (error "input non valido"))))
				  
;vediamo ora le funzioni legate agli intervalli.
;iniziando dal "costruttore" degli intervalli.
(defun interval (&optional l h)
	(cond ((and (null l) (null h)) (empty-interval))
		  ((and (or (eql l +pos-infinity+) 
		            (eql l +neg-infinity+)
					(numberp l))
				(null h)) 
				(list l l))
		  ((and (numberp l) (numberp h))
				(cond ((> l h) (empty-interval))
					  ((<= l h) (list l h))))
		  ((and (eql l +neg-infinity+) (numberp h)) (list l h))
		  ((and (eql l +pos-infinity+) (numberp h)) (empty-interval))
		  ((and (eql l +neg-infinity+)
				(eql h +neg-infinity+)) (list l h))
		  ((and (eql l +pos-infinity+)
				(eql h +pos-infinity+)) (list l h))
		  ((and (eql l +pos-infinity+)
				(eql h +neg-infinity+)) (empty-interval))
		  ((and (eql l +neg-infinity+)
				(eql h +pos-infinity+)) (list l h))
		  ((and (numberp l)
				(eql h +pos-infinity+)) (list l h))
		  ((and (numberp l)
				(eql h +neg-infinity+)) (empty-interval))
		  (T (error "input non valido"))))

;funzione che mostra la rappresentazione dell'intero intervallo I_R.
(defun whole-interval ()
	(interval +neg-infinity+ +pos-infinity+))
	
;funzione che ritorna T se x è un intervallo, NIL altrimenti.
(defun is-interval (x)
	(or (eql x nil)
	    (and (listp x)
	         (= (length x) 2)
	         (or (and (eql (first x) +neg-infinity+)
				      (eql (second x) +pos-infinity+))
		         (and (eql (first x) +pos-infinity+) 
			     	  (eql (second x) +pos-infinity+))
		         (and (eql (first x) +neg-infinity+) 
			     	  (eql (second x) +neg-infinity+))
		         (and (eql (first x) +neg-infinity+) 
				      (numberp (second x)))			  
		         (and (numberp (first x)) 
			    	  (eql (second x) +pos-infinity+))
		         (and (numberp (first x)) 
			    	  (numberp (second x)) 
			    	  (<= (first x) (second x)))))))
	
;funzione che ritorna T se ho un intervallo nullo, NIL altrimenti.
(defun is-empty (x)
	(if (is-interval x)
		(if (null x) T NIL)
		(error "x non e' un intervallo")))

;funzione che ritorna T se ho un intervallo singleton [l l],
;NIL altrimenti.
(defun is-singleton (x)
	(if (is-interval x)
		(if (eql (first x) (second x)) T NIL)
		(error "x non e' un intervallo")))

;funzione che ritorna il primo elemento se i è un intervallo
;non vuoto, altrimenti torna errore.
(defun inf (i)
	(cond ((not (is-interval i))
			    (error "input non e' un intervallo"))
		  ((is-empty i)
				(error "intervallo vuoto"))
		  (T (first i))))

;funzione che ritorna il secondo elemento se i è un intervallo
;non vuoto, altrimenti torna errore.
(defun sup (i)
	(cond ((not (is-interval i))
			    (error "input non e' un intervallo"))
		  ((is-empty i)
				(error "intervallo vuoto"))
		  (T (second i))))

;le cinque funzioni seguenti sono funzioni "di supporto" per
;estendere con gli infiniti gli operatori di >=, <=, <, >
;e la funzione numberp.
(defun <=e (x y)
	(if (or (and (eql x +pos-infinity+) (numberp y))
			(and (eql y +neg-infinity+) (numberp x)))
	         nil
	        (or (eql x y)
				(eql x +neg-infinity+)
				(eql y +pos-infinity+)
				(<= x y))))

(defun >=e (x y)
	(if (or (and (eql y +pos-infinity+) (numberp x))
		    (and (eql x +neg-infinity+) (numberp y)))
			 nil
			(or (eql x y)
				(eql x +pos-infinity+)
				(eql y +neg-infinity+)
				(>= x y))))

(defun <e (x y)
	(if (or (and (eql x +pos-infinity+) (numberp y))
			(and (eql y +neg-infinity+) (numberp x)))
	         nil
	        (or (eql x +neg-infinity+)
				(eql y +pos-infinity+)
				(< x y))))

(defun >e (x y)
	(if (or (and (eql y +pos-infinity+) (numberp x))
		    (and (eql x +neg-infinity+) (numberp y)))
			 nil
			(or (eql x +pos-infinity+)
				(eql y +neg-infinity+)
				(> x y))))

(defun numberpe (x)
	(or (numberp x)
		(eql x +pos-infinity+)
		(eql x +neg-infinity+)))

	  
;funzione che verifica se un intervallo i contiene x,
;che può essere un numero o un intervallo.
(defun contains (i x)
	(cond ((not (is-interval i))
			    (error "input i non e' un intervallo"))
		  ((is-empty i)
			    (error "input i non puo' essere vuoto"))
		  ((and (numberpe x)
			    (<=e (inf i) x) 
				(>=e (sup i) x)) T)
		  ((and (is-interval x)
				(<=e (inf i) (inf x))
				(<=e (sup x) (sup i))) T)
		  (T nil)))
			
;funzione che verifica l'overlap di due intervalli i1 e i2.
;chiama error se almeno uno dei due non è un intervallo.
(defun overlap (i1 i2)
	(cond ((or (not (is-interval i1)) (not (is-interval i2)))
		       (error "entrambi gli argomenti devono essere intervalli"))
		  ((and (>=e (sup i1) (inf i2))
			    (>=e (sup i2) (inf i1))) T)
		  (T nil)))

;funzione che calcola la somma di due intervalli.
;senza argomenti restituisce l'intervallo singleton [0, 0].
;se x e y sono numeri reali vengono convertiti in singleton.
;se x e y non sono reali o intervalli viene chiamato errore.
(defun i+ (&optional x y)
	(cond ((and (null x) (null y)) (interval 0 0))
		  ((numberpe x) (if (null y)
							(interval x x)
							(i+ (interval x x) y)))
		  ((numberpe y) (if (null x)
							(interval y y)
							(i+ x (interval y y))))
		  ((and (is-interval x) (is-interval y))
				(let ((a (inf x)) (b (sup x))
					  (c (inf y)) (d (sup y)))
				(interval (+e a c) (+e b d))))
		  (T (error "input non valido: ~a, ~a" x y))))

;funzione che calcola la differenza di due intervalli.
;se viene passato un solo argomento ritorna il reciproco
;di quell'intervallo.
(defun i- (x &optional y)
	(cond ((null y) (if (is-interval x)
						(interval (-e (sup x)) (-e (inf x)))
						(i- (interval x x))))
	      ((numberpe x) (i- (interval x x) y))
		  ((numberpe y) (i- x (interval y y)))
		  ((and (is-interval x) (is-interval y))
				(let ((a (inf x)) (b (sup x))
					  (c (inf y)) (d (sup y)))
				(interval (-e a d) (-e b c))))
		  (T (error "input non valido: ~a, ~a" x y))))

;le due seguenti funzioni sono di supporto per trovare
;massimo e minimo di una lista considerando anche gli 
;infiniti.
(defun mine (&rest args)
	(reduce (lambda (x y)
				(cond ((eql y +neg-infinity+) y)
					  ((eql x +neg-infinity+) x)
					  ((eql y +pos-infinity+) x)
					  ((eql x +pos-infinity+) y)
					  (T (min x y))))
			args))

(defun maxe (&rest args)
	(reduce (lambda (x y)
				(cond ((eql y +pos-infinity+) y)
					  ((eql x +pos-infinity+) x)
					  ((eql y +neg-infinity+) x)
					  ((eql x +neg-infinity+) y)
					  (T (max x y))))
			args))
	

;funzione che calcola il prodotto tra due intervalli.
;se chiamata senza argomenti ritorna il singleton [1, 1].
(defun i* (&optional x y)
	(cond ((and (null x) (null y) (interval 1 1)))
		  ((null y) (if (is-interval x)
						 x
						(interval x x)))
		  ((numberpe x) (i* (interval x x) y))
		  ((numberpe y) (i* x (interval y y)))
		  ((is-empty x) +empty-interval+)
		  ((is-empty y) +empty-interval+)
		  ((and (is-interval x) (is-interval y))
				(let* ((a (inf x)) (b (sup x)) (c (inf y)) (d (sup y))
					 (mins (mine (*e a c) (*e a d) (*e b c) (*e b d)))
					 (maxs (maxe (*e a c) (*e a d) (*e b c) (*e b d))))
				(interval mins maxs)))
		  (T (error "input non valido: ~a, ~a" x y))))

;funzione di supporto che classifica gli intervalli con
;i "tipi" segnati nel testo.
(defun tipo-int (interval)
	(let ((low (inf interval)) (high (sup interval)))
		(cond ((and (<e low 0) (<e 0 high)) 'M)
			  ((and (eql 0 low) (eql 0 high)) 'Z)
			  ((and (<=e 0 low) (<=e low high) (<e 0 high))
					(if (eql 0 low) 'P0 'P1))
			  ((and (<=e low high) (<=e high 0) (<e low 0))
					(if (eql 0 high) 'N0 'N1))
			  (T (error "intervallo sbagliato")))))

;funzione che calcola la divisione tra due intervalli,
;usando la funzione tipo-int per assegnare i tipi agli
;intervalli e un doppio "switch case" per verificarli.
(defun i/ (x &optional y)
	(cond ((null y) (if (is-interval x)
	                 (interval (/e 1 (inf x)) (/e 1 (sup x)))
					 (i/ (interval x x))))
		  ((numberpe x) (i/ (interval x x) y))
		  ((numberpe y) (i/ x (interval y y)))
		  ((is-empty x) +empty-interval+)
		  ((is-empty y) +empty-interval+)
		  ((and (is-interval x) (is-interval y))
			(let ((tipo1 (tipo-int x)) (tipo2 (tipo-int y)))
				(case tipo1 
					(P1
						(case tipo2
							(P0 (interval (/e (inf x) (sup y)) 
										  +pos-infinity+))
							(P1	(interval (/e (inf x) (sup y)) 
										  (/e (sup x) (inf y))))
							(M (list (interval +neg-infinity+ 
									 (/e (inf x) (inf y)))
									 (interval (/e (inf x) (sup y))
									 +pos-infinity+)))
							(N0 (interval +neg-infinity+ 
										  (/e (inf x) (inf y))))
							(N1	(interval (/e (sup x) (sup y)) 
										  (/e (inf x) (inf y))))))
					(P0
						(case tipo2
							(P0 (interval 0 +pos-infinity+))
							(P1 (interval 0 (/e (sup x) (inf y))))
							(M (whole-interval))
							(N0 (interval +neg-infinity+ 0))
							(N1 (interval (/e (sup x) (sup y)) 0))))
					(M
						(case tipo2
							(P0 (whole-interval))
							(P1 (interval (/e (inf x) (inf y)) 
										  (/e (sup x) (inf y))))
							(M (whole-interval))
							(N0 (whole-interval))
							(N1 (interval (/e (sup x) (sup y)) 
										  (/e (inf x) (sup y))))))
					(N0
						(case tipo2
							(P0 (interval +neg-infinity+ 0))
							(P1 (interval (/e (inf x) (inf y)) 0))
							(M (whole-interval))
							(N0 (interval 0 +pos-infinity+))
							(N1 (interval 0 (/e (inf x) (sup y))))))
					(N1
						(case tipo2
							(P0 (interval +neg-infinity+ 
										  (/e (sup x) (sup y))))
							(P1	(interval (/e (inf x) (inf y)) 
										  (/e (sup x) (sup y))))
							(M (list (interval +neg-infinity+ 
									 (/e (sup x) (sup y)))
									 (interval (/e (sup x) (inf y))
									 +pos-infinity+)))
							(N0 (interval (/e (sup x) (inf y)) 
										  +pos-infinity+))
							(N1	(interval (/e (sup x) (inf y)) 
										  (/e (inf x) (sup y)))))))))      
		  (T (error "input non valido: ~a, ~a" x y))))

