 
;; Define constants
(define-constant MAX-CANDIDATES 10)
(define-constant MAX-CANDIDATE-NAME-LENGTH 32)

;; Data structures
(define-map candidates (string-ascii) uint)
(define-map voters (principal) bool)  ;; Track voters to prevent double voting
(define-constant owner tx-sender)     ;; Contract owner

;; Add a candidate (only owner)
(define-public (add-candidate (name string-ascii))
  (begin
    (asserts! (contract-own? tx-sender) (err 1))  ;; Only owner can add candidates
    (asserts! (< (map-size candidates) MAX-CANDIDATES) (err 2))  ;; Max candidates limit
    (asserts! (<= (string-length? name) MAX-CANDIDATE-NAME-LENGTH) (err 3))  ;; Name length limit
    (map-set candidates name 0)
    (ok true)))

;; Vote for a candidate
(define-public (vote (candidate-name string-ascii))
  (begin
    (asserts! (map-has-key? candidates candidate-name) (err 4))  ;; Candidate must exist
    (asserts! (not (map-get? voters tx-sender)) (err 5))  ;; Prevent double voting
    (map-set voters tx-sender true)  ;; Mark voter as having voted
    (let ((current-votes (map-get? candidates candidate-name)))
      (map-set candidates candidate-name (+ current-votes 1))
      (ok true))))

;; Get vote count for a candidate
(define-read-only (get-vote-count (candidate-name string-ascii))
  (map-get? candidates candidate-name))

;; Get all candidates
(define-read-only (get-all-candidates)
  (map-values candidates))