Require Import Coq.Lists.List.
Require Import ListString.All.
Require Import Model.

Import ListNotations.

Module Arguments.
  Definition t := list (LString.t * list LString.t).

  Fixpoint find (args : t) (key : LString.t) : option (list LString.t) :=
    match args with
    | [] => None
    | (key', values) :: args =>
      if LString.eqb key key' then
        Some values
      else
        find args key
    end.
End Arguments.

Module Cookies.
  Definition t := list (LString.t * LString.t).
End Cookies.

Module Request.
  Inductive t :=
  | Get (path : list LString.t) (args : Arguments.t) (cookies : Cookies.t).
End Request.

Module Answer.
  Module Content.
    Inductive t :=
    | Index (posts : list Post.Header.t)
    | PostShow (post : option Post.t)
    | PostEdit (post : option Post.t)
    | PostUpdate (is_success : bool).
  End Content.

  Inductive t :=
  | Error
  | Static (mime_type : LString.t) (content : LString.t)
  | Login | Logout
  | Success (is_logged : bool) (content : Content.t).
End Answer.
