;; Extended Test Suite
(import (test-helpers) "test-helpers")

(define-test (test-double-vote)
  (with-deployer
    (contract-call? .voting-system add-candidate "Proposal Y")
    (contract-call? .voting-system vote "Proposal Y")
    (assert-err (contract-call? .voting-system vote "Proposal Y") 5)))

(define-test (test-timed-voting-window)
  (with-deployer
    (contract-call? .timed-voting add-proposal "Proposal Z")
    ;; Simulate block height within window
    (contract-call? .timed-voting vote "Proposal Z")
    ;; Simulate block height after window (pseudo-code)
    ;; (assert-err (contract-call? .timed-voting vote "Proposal Z") 4)
  ))

(define-test (test-multi-sig-finalization)
  (with-deployer
    (contract-call? .multi-sig-finalization approve-finalization "Proposal W")
    (contract-call? .multi-sig-finalization approve-finalization "Proposal W")
    (assert-eq (contract-call? .multi-sig-finalization can-finalize "Proposal W") true)
    (contract-call? .multi-sig-finalization finalize-proposal "Proposal W")))

(define-test (test-edge-case-empty-proposal)
  (with-deployer
    (assert-err (contract-call? .voting-system add-candidate "") 6)))

(define-test (test-edge-case-long-proposal)
  (with-deployer
    (assert-err (contract-call? .voting-system add-candidate (repeat "a" 256)) 7)))

(define-test (test-delegation-voting)
  (with-deployer
    (contract-call? .voting-system add-candidate "Proposal A")
    (contract-call? .voting-system delegate "delegate-key")
    (contract-call? .voting-system vote "Proposal A")
    (assert-eq (contract-call? .voting-system get-vote-count "Proposal A") 1)))

(define-test (test-time-based-voting)
  (with-deployer
    (contract-call? .timed-voting add-proposal "Proposal B" 10)
    ;; Fast-forward time
    (mine-blocks 5)
    (contract-call? .timed-voting vote "Proposal B")
    (assert-eq (contract-call? .timed-voting get-vote-count "Proposal B") 1)))