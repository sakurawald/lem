(in-package :lem-language-server)

(define-request (initialize "initialize") (params protocol:initialize-params)
  (log:info "initialize")
  (setf (server-client-capabilities *server*) params)
  (convert-to-json
   (make-instance
    'protocol:initialize-result
    :capabilities (make-instance
                   'protocol:server-capabilities
                   ;; :position-encoding
                   :text-document-sync (make-instance
                                        'protocol:text-document-sync-options
                                        :open-close t
                                        :change protocol:text-document-sync-kind-incremental
                                        :will-save nil
                                        :will-save-wait-until nil
                                        :save t)
                   ;; :notebook-document-sync
                   ;; :completion-provider
                   ;; :hover-provider
                   ;; :signature-help-provider
                   ;; :declaration-provider
                   ;; :definition-provider
                   ;; :type-definition-provider
                   ;; :implementation-provider
                   ;; :references-provider
                   ;; :document-highlight-provider
                   ;; :document-symbol-provider
                   ;; :code-action-provider
                   ;; :code-lens-provider
                   ;; :document-link-provider
                   ;; :color-provider
                   ;; :document-formatting-provider
                   ;; :document-range-formatting-provider
                   ;; :document-on-type-formatting-provider
                   ;; :rename-provider
                   ;; :folding-range-provider
                   ;; :execute-command-provider
                   ;; :selection-range-provider
                   ;; :linked-editing-range-provider
                   ;; :call-hierarchy-provider
                   ;; :semantic-tokens-provider
                   ;; :moniker-provider
                   ;; :type-hierarchy-provider
                   ;; :inline-value-provider
                   ;; :inlay-hint-provider
                   ;; :diagnostic-provider
                   ;; :workspace-symbol-provider
                   ;; :workspace
                   :experimental nil)
    :server-info (make-lsp-map :name *language-server-name*
                               :version *language-server-version*))))

(define-request (initialized "initialized") (params protocol:initialized-params)
  (declare (ignore params))
  (values))

#+TODO
(define-request (client-register-capability "client/registerCapability") (params protocol:registration-params)
  )

#+TODO
(define-request (client-unregister-capability "client/unregisterCapability") (params protocol:unregistration-params)
  )

#+TODO
(define-request (set-trace "$/setTrace") (params protocol:set-trace-params)
  )

#+TODO
(define-request (log-trace "$/logTrace") (params protocol:log-trace-params)
  )

(define-request (shutdown "shutdown") ()
  (setf (shutdown-request-received-p (current-server)) t)
  nil)

(define-request (exit "exit") ()
  (if (shutdown-request-received-p (current-server))
      (uiop:quit 0)
      (uiop:quit 1))
  (values))
