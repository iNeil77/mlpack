open Util
module D = Dlist

type 'a l = 'a list
type 'a series = int -> 'a l

let pure x   = fun n -> if n<=0 then [] else [x]
let (++) a b = fun n -> a n @ b n
let (%%) f a = fun n ->
  foreach (f n) $ fun f' ->
    foreach (a $ n-1) $ fun a' ->
      [f' a']

(* let pure x = fun n -> if n<=0 then D.empty else D.singleton x  *)
(* let (++) a b = fun n -> D.append (a n) (b n) *)
(* let (%%) f a = fun n -> D.empty  *)

(* series generators for common types *)
let units       = pure () 
let bools       = pure false ++ pure true
let pairs a b   = pure pair %% a %% b
let options a   = pure None ++ pure some %% a 
let ints        = fun n -> enumFromTo (-n) n
let floats      = fun n -> List.map float_of_int (ints n) 
let rec lists a = fun n -> (pure [] ++ pure cons %% a %% lists a) n

(* printing *)
let show_unit x = "()"
let show_bool x = if x then "true" else "false"
let show_pair a b (x,y) = "(" ^ a x ^ "," ^ b y ^ ")"
let show_option a x = match x with Some y -> "(Some " ^ a y ^")" | None -> "None" 
let show_int x = string_of_int x
let show_float x = string_of_float x
let show_list a xs = "[" ^ String.concat "," (List.map a xs) ^ "]" 

(* evaluate the proposition up to the specifies depth parameter *)
let evaluate n prop = prop n

(* given a series, a property, and a depth parameter, attempts to find a counterexample *) 
let forAll a p = fun n -> try Some (List.find (not % p) (a n)) with Not_found -> None 


