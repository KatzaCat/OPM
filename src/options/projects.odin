package options

import "core:encoding/json"
import "core:os"
import "core:fmt"
import "core:strings"

import "../utilities"

MINIMUM_SUB_DIR_SIZE :: 1

FOLDER_ITEM_TYPE :: "folder"
FILE_ITEM_TYPE :: "file"

@(private)
populate_new_project :: proc(directory_array: json.Array, prefix: string) {
  for item in directory_array {
    // get current item
    current_item := item.(json.Object);

    // find item name, and set the crrent full item path
    item_name := current_item["name"].(json.String);
    full_item_path := strings.concatenate({prefix, item_name})

    // get the item path
    item_type := current_item["type"].(json.String);
    if item_type == FOLDER_ITEM_TYPE {
      create_new_folder(full_item_path, item_name, prefix, current_item);
    } else if item_type == FILE_ITEM_TYPE {
      create_new_file(full_item_path, item_name, prefix);
    }
  }
}

@(private="file")
create_new_folder :: proc(full_item_path, item_name, prefix: string, item: json.Object) {
  os.make_directory(full_item_path);

  // get the "sub-directory" array of the current item
  item_sub_directory := item["sub-directory"].(json.Array)
  if len(item_sub_directory) >= MINIMUM_SUB_DIR_SIZE {
    // make new prefix then go over the sub directory the same way we did the current one
    new_prefix := strings.concatenate({prefix, "/", item_name, "/"})
    populate_new_project(item_sub_directory, new_prefix);
  }
}

@(private="file")
create_new_file :: proc(full_item_path, item_name, prefix: string) {
  // get the file path of the current file
  file_path := strings.concatenate({ utilities.global_data.current_project_type_path, "/", prefix, "/", item_name });

  // check if the file exists
  if os.is_file(file_path) {
    // get the contents of the file then write the file into a new file in the callers directory
    file_contents := utilities.read_file_to_string(file_path);
    os.write_entire_file(full_item_path, transmute([]u8)(file_contents));
  }
}

@(private)
list_projects :: proc(project_name: string) {
  // get the path of the project we are worrying about
  project_name_path := strings.concatenate({utilities.global_data.path_to_project_types_file, "/", project_name})

  // print the name
  fmt.printf("\t%10s - ", project_name);
  // check if file exists
  if os.exists(project_name_path) {
    fmt.println("detected");
  } else {
    fmt.println("undetected");
  }
}

@(private)
make_projects :: proc(project_name: string, current_project: json.Object) {
  if project_name == utilities.global_data.current_build_name {
    project_directory := current_project["directory"].(json.Array);

    populate_new_project(project_directory, "./");
  }
}