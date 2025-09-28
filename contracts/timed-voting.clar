;; Timed Voting Contract Extension
(define-constant VOTING-DURATION-BLOCKS u144) ;; e.g., ~24 hours if 10 min/block
(define-map proposal-start-block (string-ascii) uint)

(define-public (add-proposal (name string-ascii))
  (begin
    (asserts! (contract-own? tx-sender) (err 1))
    (asserts! (not (map-has-key? proposal-start-block name)) (err 2))
    (map-set proposal-start-block name block-height)
    (ok true)))

(define-public (vote (proposal-name string-ascii))
  (let ((start-block (map-get? proposal-start-block proposal-name)))
    (asserts! start-block (err 3))
    (asserts! (<= block-height (+ start-block VOTING-DURATION-BLOCKS)) (err 4))
    ;; Call main voting contract's vote function (assume .voting-system)
    (contract-call? .voting-system vote proposal-name)))

(define-read-only (get-proposal-start (proposal-name string-ascii))
  (map-get? proposal-start-block proposal-name))