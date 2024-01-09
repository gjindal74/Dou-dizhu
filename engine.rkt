;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname engine) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require "players.rkt")
(define hand0 '(3 3 3 3 4 5 6 7 7 7 9 9 Jack Jack Queen King 2 2 Black Red))
(define hand1 '(4 4 4 5 5 6 6 7 8 9 10 Jack Queen King Ace 2 2))
(define hand2 '(5 6 8 8 8 9 10 10 10 Jack Queen Queen King King Ace Ace Ace))
;;(doudizhu players hands) consumes a list of players and hands given to them and tells that who wins
;;according to their playing techniques
;;examples:
(check-expect (doudizhu (list goldfish goldfish goldfish) (list hand0 hand1 hand2)) 'Left)
(check-expect (doudizhu (list reckless goldfish goldfish) (list hand0 hand1 hand2)) 'Landlord)
;;doudizhu: (listof X) (listof (listof Any))-> Sym
(define (doudizhu players hands)
  (local [(define (card-remove lst lst1) ;;(card-remove lst lst1) consumes two lists and takes out the
            ;;elements of first list from the second list
            ;;card-remove:(listof Any) (listof Any)-> (listof Any)
  (cond
    [(empty? lst) lst1 ]
    [(equal? (first lst) (first lst1)) (card-remove (rest lst) (rest lst1))]
    [else (cons (first lst1) (card-remove lst (rest lst1)))]))

  (define (helper players hand played) ;;(helper players hand played) consumes the lists of players
    ;; and the hands given to them and the list of cards played and adds the cards played to played
    ;;list and tells that whose cards finishes first
    ;;helper: (listof X) (listof (listof Any)) (listof Any)-> Sym
    (local
       [(define landlord (first players))
  (define right (second players))
  (define left (third players))
  (define h1 (first hand))
  (define h2 (second hand))
  (define h3 (third hand))]
  (cond
    [(empty? h1) 'Landlord]
    [(empty? h2) 'Right]
    [(empty? h3) 'Left]
    [(= 0 (remainder (length played) 3)) (helper players (list (card-remove
                                                           (landlord h1 'Landlord played) h1) h2 h3)
                                                 (cons (landlord h1 'Landlord played) played))]
    [(= 1 (remainder (length played) 3)) (helper players (list h1 (card-remove
                                                               (right h2 'Right played) h2) h3)
                                                 (cons (right h2 'Right played) played))]
    [(= 2 (remainder (length played) 3)) (helper players (list h1 h2 (card-remove
                                                                  (left h3 'Left played) h3))
                                                 (cons (left h3 'Left played) played))])))]
          (helper players hands empty)))
;;tests: 
 (check-expect (doudizhu (list cautious reckless goldfish) (list hand0 hand1 hand2)) 'Landlord) 
  (check-expect (doudizhu (list reckless reckless reckless) (list hand0 hand1 hand2)) 'Right)
    (check-expect (doudizhu (list reckless reckless cautious) (list hand0 hand1 hand2)) 'Left)
    (check-expect (doudizhu (list cautious cautious goldfish) (list hand0 hand1 hand2)) 'Landlord)
