(*
 * Copyright (c) 2018-2019 Romain Calascibetta <romain.calascibetta@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

type decoder
(** Type of decoder. *)

type decode =
  [ `Field of Field.field Location.with_location
  | `Await
  | `End of string
  | `Malformed of string ]

val decoder : ?p:Field.witness Field_name.Map.t -> Bigstringaf.t -> decoder
(** [decoder ?p buf] returns a decoder with a set of field-name binded
   with expected kind of value. When the decoder will decode value of
   a given field-name, it will try to extract expected value describe by
   the given {!Field.witness} or it returns a {!Unstructured.t}. *)

val decode : decoder -> decode
(** [decode decoder] is:
    {ul
    {- [`Field field] when extracted a field.}
    {- [`Await] when the decoder wants more input.}
    {- [`End trailer] when we reach end of the header. [trailer] is
       what the user gaves which is not the part of the header.}
    {- [`Malformed err] we we reach an error while decoding.}} *)

val src : decoder -> string -> int -> int -> (unit, [> Rresult.R.msg ]) result
(** [src decoder src off len] gives more input to [decoder]. The function
    can fail when given input is bigger than internal buffer of [decoder]
    (see {!decoder}). *)
