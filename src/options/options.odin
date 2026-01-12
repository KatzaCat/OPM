package options

import "core:os"
import "core:encoding/json"
import "core:fmt"

import "../utilities"

MINIMUM_OPTION_SIZE :: 2

OPTION_NONE :: 0;
OPTION_MAKE :: 1;
OPTION_LIST :: 2;

MAX_OPTIONS_SIZE :: 3;
Options := [MAX_OPTIONS_SIZE]string {
  "",
  "make",
  "list"
};

check_option :: proc(project_array: json.Value) {
  // no arg passed
  if len(os.args) < MINIMUM_OPTION_SIZE {
    fmt.eprint("No arguments passed, at least 1 argument is requiered!");
    return;
  }

  utilities.global_data.current_build_name = os.args[2];

  // makes the project of the specifyed type 
  if os.args[1] == Options[OPTION_MAKE] {
    if len(os.args) < 3 {
      fmt.eprintln("Argument \"make\" requiers the name of the project you wanna make!");
      fmt.eprintln("\tEX. : opm make normal");
      return;
    }
    process_option(project_array, .MAKE);
    return;
  }

  // lists the project types inside the "project_types.json" and if the program found them
  if os.args[1] == Options[OPTION_LIST] {
    process_option(project_array, .LIST);
    return;
  }

  // wrong arg passed
  fmt.eprintf("argument \"%s\" doesn't exist!", os.args[1]);
  return;
}

@(private)
OptionInteraction :: enum {
  LIST,
  MAKE
}

@(private)
process_option :: proc(project_array: json.Value, type: OptionInteraction) {
  for project in project_array.(json.Array) {
    // get project project
    current_project := project.(json.Object);

    // get the name and print it
    project_name := current_project["name"].(json.String);

    // either list them out, or build them
    switch type {
      case .LIST:
        list_projects(project_name);
      case .MAKE:
        make_projects(project_name, current_project);
    }
  }
}