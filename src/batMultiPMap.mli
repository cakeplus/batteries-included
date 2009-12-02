(*
 * MultiPMap - Polymorphic maps with multiple associations
 * Copyright (C) 1996-2003 Xavier Leroy, Nicolas Cannasse, Markus Mottl
 * Copyright (C) 2008      David Teller, LIFO, Universite d'Orleans
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version,
 * with the special exception on linking described in file LICENSE.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

(** 
    Polymorphic Multi-Map.

    This is a polymorphic multi-map, i.e. an association from 1 to many.

    @author Xavier Leroy
    @author Nicolas Cannasse
    @author Markus Mottle
    @author David Teller
*)

type ('a, 'b) t

val empty : ('a, 'b) t
(** The empty map, using [compare] as key comparison function. *)

val is_empty : ('a, 'b) t -> bool
(** returns true if the map is empty. *)

val create : ('a -> 'a -> int) -> ('b -> 'b -> int) -> ('a, 'b) t
(** creates a new empty map, using the provided function for key comparison.*)

val add : 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
(** [add x y m] returns a map containing the same bindings as
    [m], plus a binding of [x] to [y].*)

val find : 'a -> ('a, 'b) t -> 'b BatPSet.t
(** [find x m] returns the current binding of [x] in [m]*)

val remove_all : 'a -> ('a, 'b) t -> ('a, 'b) t
(** [remove_all x m] returns a map containing the same bindings as
    [m], except for [x] which is unbound in the returned map. *)

val remove : 'a -> 'b -> ('a, 'b) t -> ('a, 'b) t
(** [remove k d m] returns a map containing the same bindings as
    [m], except for [k] which is not bound to [d] anymore in the returned
    map. If [k] was not bound to [d], nothing is changed. If the operation
    removes the last binding of [k], then [k] is also removed from the set
    of keys.*)

val mem : 'a -> ('a, 'b) t -> bool
(** [mem x m] returns [true] if [m] contains at least a binding for [x],
    and [false] otherwise. *)

val iter : ('a -> 'b BatPSet.t-> unit) -> ('a, 'b) t -> unit
(** [iter f m] applies [f] to all bindings in map [m].
    [f] receives the key as first argument, and the associated value
    as second argument. The order in which the bindings are passed to
    [f] is unspecified. Only current bindings are presented to [f]:
    bindings hidden by more recent bindings are not passed to [f]. *)

val map : ('b BatPSet.t -> 'c BatPSet.t) -> (('b -> 'b -> int) -> ('c -> 'c -> int)) -> ('a, 'b) t -> ('a, 'c) t
(** [map f m] returns a map with same domain as [m], where the
    associated value [a] of all bindings of [m] has been
    replaced by the result of the application of [f] to [a].
    The order in which the associated values are passed to [f]
    is unspecified. *)

val mapi : ('a -> 'b BatPSet.t -> 'c BatPSet.t) -> (('b -> 'b -> int) -> ('c -> 'c -> int)) -> ('a, 'b) t -> ('a, 'c) t
(** Same as [map], but the function receives as arguments both the
    key and the associated value for each binding of the map. *)

val fold : ('b BatPSet.t -> 'c -> 'c) -> ('a , 'b) t -> 'c -> 'c
(** [fold f m a] computes [(f kN dN ... (f k1 d1 a)...)],
    where [k1 ... kN] are the keys of all bindings in [m],
    and [d1 ... dN] are the associated data.
    The order in which the bindings are presented to [f] is
    unspecified. *)

val foldi : ('a -> 'b BatPSet.t -> 'c -> 'c) -> ('a , 'b) t -> 'c -> 'c
(** Same as [fold], but the function receives as arguments both the
    key and the associated value for each binding of the map. *)

val enum : ('a, 'b) t -> ('a * 'b) BatEnum.t
(** creates an enumeration for this map. *)

val of_enum : ?keys:('a -> 'a -> int) -> ?data:('b -> 'b -> int) -> ('a * 'b) BatEnum.t -> ('a, 'b) t
(** creates a map from an enumeration, using the specified function
  for key comparison or [compare] by default. *)

(** {6 Boilerplate code}*)

(** {7 Printing}*)
  
val print : ?first:string -> ?last:string -> ?sep:string -> ('a BatInnerIO.output -> 'b -> unit) -> 
                                                            ('a BatInnerIO.output -> 'c -> unit) -> 
 'a BatInnerIO.output -> ('b, 'c) t -> unit
