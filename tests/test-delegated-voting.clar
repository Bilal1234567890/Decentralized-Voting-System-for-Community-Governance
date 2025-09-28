;; Test Delegated Voting
(import (test-helpers) "test-helpers")

(define-test (test-delegate-vote)
  (with-deployer
    (contract-call? .delegated-voting delegate-vote 'SP2C2...)
    (assert-eq (contract-call? .delegated-voting get-delegate tx-sender) (some 'SP2C2...))))

(define-test (test-vote-with-delegation)
  (with-deployer
    (contract-call? .voting-system add-candidate "Proposal X")
    (contract-call? .delegated-voting delegate-vote 'SP2C2...)
    (contract-call? .delegated-voting vote-with-delegation "Proposal X")
    (assert-eq (contract-call? .voting-system get-vote-count "Proposal X") 1)))