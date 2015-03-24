let result_of_http_call call =
  match call#status with
    | `Successful             -> (`Success call#response_body#value)
    | `Unserved               -> `Unserved
    | `Http_protocol_error e  -> (`Http_protocol_error e)
    | `Redirection            -> `Redirection
    | `Client_error           -> `Client_error
    | `Server_error           -> `Server_error

let prep_pipeline account_sid auth_token pipeline =
  (* Prep for SSL *)
  Ssl.init ();
  let ctx = Ssl.create_context Ssl.TLSv1 Ssl.Client_context in

  (* Prep for authentication *)
  let key_handler =
    object
      method inquire_key ~domain ~realm ~auth =
        Nethttp_client.key
          ~user:account_sid
          ~password:auth_token
          ~realm
          ~domain:(match domain with None -> [] | Some domain -> [ domain ])
      method invalidate_key _key = ()
    end
  in
  let basic_auth_handler =
    new Nethttp_client.basic_auth_handler
      (* ~enable_auth_in_advance:true *)
      key_handler
  in
  let digest_auth_handler =
    new Nethttp_client.digest_auth_handler
      (* ~enable_auth_in_advance:true *)
      key_handler
  in
  pipeline#add_auth_handler basic_auth_handler;
  pipeline#add_auth_handler digest_auth_handler
