module TowerPositions = Map.Make(Char)
module Coordinates = Set.Make(struct
  type t = int * int
  let compare = compare  (* Comparison function for (int * int) pairs *)
end)

let process_line line y_pos towers =
  let pos = ref towers in
  let checkChar tower_pos i c =
    if c <> '.' then
      let positions = TowerPositions.find_opt c tower_pos |> Option.value ~default:[] in
      TowerPositions.add c ((y_pos, i) :: positions) tower_pos
    else
      tower_pos
  in
  String.iteri (fun i c ->
    pos := checkChar !pos i c
  ) line;
  !pos

  let process_file filename =
    let ic = open_in filename in
    let rec loop y_pos towers x_size y_size=
      match input_line ic with
      | line ->
          let updated_towers = process_line line y_pos towers in
          let new_y_size = y_size + 1 in
          let new_x_size = max x_size (String.length line) in
          loop (y_pos + 1) updated_towers new_x_size new_y_size
      | exception End_of_file ->
          close_in ic;
          (towers, x_size, y_size)
    in
    loop 0 TowerPositions.empty 0 0

let get_antinodes (x1, y1) (x2, y2) max_x max_y =
    let dx = x1 - x2 in
    let dy = y1 - y2 in

    let rec generate_antinodes (x, y) dx dy acc =
        if x >= 0 && y >= 0 && x < max_x && y < max_y then
            generate_antinodes (x + dx, y + dy) dx dy ((x, y) :: acc)
        else
            acc
    in

    let first_antinodes = generate_antinodes (x1, y1) dx dy [] in
    let second_antinodes = generate_antinodes (x1, y1) (-dx) (-dy) [] in
    first_antinodes @ second_antinodes  (* Combine both results *)
    

let calculate_antinodes_for_frequency antenna max_x max_y = 
    let rec loop lst locations =
        match lst with 
        | [] -> locations
        | p1 :: rest ->
            let updated_locations = List.fold_left (fun locations p2 ->
                let nodes = get_antinodes p1 p2 max_x max_y in
                List.rev_append nodes locations
            ) locations rest in
            loop rest updated_locations
    in loop antenna []
    

let filter_valid_coordinates max_x max_y locations =
    List.filter (fun (x, y) ->
        x >= 0 && y >= 0 && x < max_x && y < max_y
    ) locations
      

let remove_duplicates antinode_locations =
    let set_of_locations = List.fold_left (fun set loc -> Coordinates.add loc set) Coordinates.empty antinode_locations in
    Coordinates.elements set_of_locations
      

let () =
    let filename = "input" in
    let tower_positions, max_x, max_y = process_file filename in
    Printf.printf "Map size is (%d / %d)\n" max_y max_x;
    let total_antinode_locations = ref [] in
    TowerPositions.iter (fun _ positions ->
      total_antinode_locations := List.rev_append (calculate_antinodes_for_frequency positions max_x max_y) !total_antinode_locations
    ) tower_positions;
    let valid_antinode_locations = 
        filter_valid_coordinates max_x max_y !total_antinode_locations in
    let unique_antinode_locations = remove_duplicates valid_antinode_locations in
    let num_unique_locations = List.length unique_antinode_locations in
        Printf.printf "\nNumber of unique valid locations: %d\n" num_unique_locations        
