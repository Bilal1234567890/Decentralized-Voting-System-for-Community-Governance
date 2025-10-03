// multi-sig-finalization.clar
// Multi-signature proposal finalization contract
(define-constant REQUIRED-SIGNERS 2)
(define-map proposal-finalization (string-ascii) (list 10 principal))
(define-map proposal-status (string-ascii) (string-ascii)) ;; "pending" or "finalized"

// Events
(define-event proposal-approved (proposal string-ascii approver principal))
(define-event proposal-finalized (proposal string-ascii))

(define-public (approve-finalization (proposal string-ascii))
  (let (
        (status (default-to "pending" (map-get? proposal-status proposal)))
        (approvers (default-to (list) (map-get? proposal-finalization proposal)))
      )
    ;; Prevent approving if already finalized
    (asserts! (is-eq status "pending") (err 3))
    (asserts! (not (contains approvers tx-sender)) (err 1))
    (map-set proposal-finalization proposal (cons tx-sender approvers))
    (emit-event (proposal-approved proposal tx-sender))
    (ok true)
  )
)

(define-read-only (can-finalize (proposal string-ascii))
  (let ((approvers (default-to (list) (map-get? proposal-finalization proposal))))
    (>= (len approvers) REQUIRED-SIGNERS))
)

(define-public (finalize-proposal (proposal string-ascii))
  (let ((status (default-to "pending" (map-get? proposal-status proposal))))
    ;; Prevent double finalization
    (asserts! (is-eq status "pending") (err 3))
    (asserts! (can-finalize proposal) (err 2))
    ;; Set status to finalized
    (map-set proposal-status proposal "finalized")
    (emit-event (proposal-finalized proposal))
    ;; Finalization logic here
    (ok true)
  )
)