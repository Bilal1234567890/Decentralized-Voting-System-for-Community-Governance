// Delegated Voting Contract
(define-map delegations (principal) (optional principal))

;; Event for delegation
(define-event vote-delegated (from principal to principal))
(define-event delegation-removed (from principal))

(define-public (delegate-vote (to principal))
  (begin
    (asserts! (not (is-eq tx-sender to)) (err 1))
    ;; Prevent circular delegation
    (asserts! (not (is-eq (unwrap-panic (get-final-delegate to)) tx-sender)) (err 3))
    (map-set delegations tx-sender (some to))
    (emit-event (vote-delegated tx-sender to))
    (ok true)))

(define-public (remove-delegation)
  (begin
    (map-delete delegations tx-sender)
    (emit-event (delegation-removed tx-sender))
    (ok true)))

(define-read-only (get-delegate (voter principal))
  (map-get? delegations voter))

;; Helper to get the final delegate in the chain
(define-read-only (get-final-delegate (voter principal))
  (let ((maybe-delegate (map-get? delegations voter)))
    (if (is-some maybe-delegate)
      (get-final-delegate (unwrap! maybe-delegate (err u0)))
      voter)))

(define-public (vote-with-delegation (candidate-name string-ascii))
  (let ((delegate (map-get? delegations tx-sender)))
    (if delegate
      (contract-call? .voting-system vote candidate-name)
      (err 2))))
