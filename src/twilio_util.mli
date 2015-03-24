(** Utility functions for the Twilio API *)

val result_of_http_call : Nethttp_client.http_call -> Twilio_types.http_call_result
  (** Convert the result of the [http_call] into a Twilio result.
      The request should be served, i.e [http_call#served] is [true];
   *)

val prep_pipeline : string -> string -> Nethttp_client.pipeline -> unit
  (** Prep the pipeline with the Twilio account credentials *)
