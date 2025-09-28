// Delegated Voting Contract
(define-map delegations (principal) (optional principal))

(define-public (delegate-vote (to principal))
  (begin
    (asserts! (not (is-eq tx-sender to)) (err 1))
    (map-set delegations tx-sender (some to))
    (ok true)))

(define-read-only (get-delegate (voter principal))
  (map-get? delegations voter))

(define-public (vote-with-delegation (candidate-name string-ascii))
  (let ((delegate (map-get? delegations tx-sender)))
    (if delegate
      (contract-call? .voting-system vote candidate-name)
      (err 2))))