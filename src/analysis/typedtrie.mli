(* {{{ COPYING *(

  This file is part of Merlin, an helper for ocaml editors

  Copyright (C) 2013 - 2015  Frédéric Bour  <frederic.bour(_)lakaban.net>
                             Thomas Refis  <refis.thomas(_)gmail.com>
                             Simon Castellan  <simon.castellan(_)iuwt.fr>

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  The Software is provided "as is", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. In no event shall
  the authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising
  from, out of or in connection with the software or the use or other dealings
  in the Software.

)* }}} *)

type t = Cmt_cache.trie
type result =
  | Found of Location.t
    (** Found at location *)
  | Alias_of of Location.t * string list
    (** Alias of [string list], introduced at [Location.t] *)
  | Resolves_to of string list * Location.t option
    (** Not found in trie, look for [string list] in loadpath.
        If the second parameter is [Some] it means we encountered an include or
        module alias at some point, so we can always fallback there if we don't
        find anything in the loadpath. *)

val section : Logger.Section.t

val of_browses : BrowseT.t list -> t

val follow : ?before:Lexing.position -> t -> string list -> result
(** [follow ?before t path] will follow [path] in [t], using [before] to
    select the right branch in presence of shadowing. *)

val find : ?before:Lexing.position -> t -> string list -> result
(** [find ?before t path] starts by going down in [t] following branches
    enclosing [before]. Then it will behave as [follow ?before].
    If [follow] returns [Resolves_to (p, _)] it will go back up in the trie, and
    will try to [follow] again with [before] set to the the start of the node we
    just got up from. *)

(* For debugging purposes. *)
val dump : Format.formatter -> t -> unit
