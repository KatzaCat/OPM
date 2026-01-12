package main

import "core:fmt"
import "core:encoding/json"
import "core:strings"
import "core:os"

import "utilities"
import "options"

creat_object_from_file_contents :: proc(file_contents: []byte) -> json.Value {
  // get the main object of the file
  object, error := json.parse(file_contents);
  if error != .None {
    fmt.eprintfln("Failed to parce main object with error code:\n\t%i", error);
    json.destroy_value(object);
    os.exit(-1);
  }
  // return object
  return object;
}

main :: proc() {
  //get the path to the Documents folder
  documents_path := utilities.get_directory_to("OneDrive\\Documents");

  OPM_path := strings.concatenate({documents_path, "\\OPM"});
  // check if the OPM folder extists
  if !os.is_dir(OPM_path) {
    // create the folder
    os.make_directory(OPM_path);
  }

  // TODO: whenever you first call this, it refuses to put in the right slash for the file
  config_file_path := strings.concatenate({ OPM_path, "\\config.json" });
  // check if the OPM config extists
  if !os.is_file(config_file_path){
    // create data
    json_data := strings.concatenate({"{\"project_types_path\": \"", OPM_path, "\\Project_Types\"}"});
    // create the file
    os.write_entire_file(config_file_path, transmute([]u8)(json_data));
  }

  // read in the config file as a string
  config_file := utilities.read_file_to_string(config_file_path);
  // getting the main object from config
  config_object := creat_object_from_file_contents(config_file);
  defer json.destroy_value(config_object);

  // get "project_types_path" from the main object
  project_types_path := config_object.(json.Object)["project_types_path"];
  utilities.global_data.path_to_project_types_file = project_types_path.(json.String);
  // give the path to the current project type to the golobal data
  if len(os.args) >= 3 
  {utilities.global_data.current_project_type_path = strings.concatenate({ utilities.global_data.path_to_project_types_file, "/", os.args[2] });}
  // get the entire path to the "project_types.json" and read is as a string
  project_types_file_path := strings.concatenate({project_types_path.(json.String), "/project_types.json"});
  project_types_file := utilities.read_file_to_string(project_types_file_path);
  // get the main object from "project_types.json"
  project_types_object := creat_object_from_file_contents(project_types_file);
  defer json.destroy_value(project_types_object);

  // get the array of the projects
  projects_array := project_types_object.(json.Object)["projects"];
  
  // check options
  options.check_option(projects_array);
}