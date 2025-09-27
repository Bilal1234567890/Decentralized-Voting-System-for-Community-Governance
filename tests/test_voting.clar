 
;; Test voting system
(import (test-helpers) "test-helpers")

(define-test (test-add-candidate)
  (with-deployer
    (contract-call? .voting-system add-candidate "Proposal A")
    (contract-call? .voting-system add-candidate "Proposal B"))
  (assert-eq (map-size (contract-call? .voting-system get-all-candidates)) 2))

(define-test (test-vote)
  (with-deployer
    (contract-call? .voting-system add-candidate "Proposal A"))
  (with-simulated-blockchain
    (contract-call? .voting-system vote "Proposal A")
    (assert-eq (contract-call? .voting-system get-vote-count "Proposal A") 1)))