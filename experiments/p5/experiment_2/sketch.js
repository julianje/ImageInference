// Initialize the path to the stimuli.
var stimuli_path = "../../../stimuli/experiment_2/";

// Declare a variable for storing the stimuli.
var stimuli;

// Declare variables for storing the door, wall, and crumb locations.
var door_locations;
var wall_locations;
var crumb_locations;

// Declare a variable for displaying our error messages.
var error_message;

// Declare a variable for storing the participant data.
var table;

// Initialize variables for storing and iterating through the trials.
var trials = [];
var current_trial = 0;

// Initialize a variable for storing the path coordinates.
var coordinates = [];

// Initialize flags for detecting if the path contains the cookie crumbs and 
// if the path contains a goal.
var cookie_flag = 0;
var goal_flag = 0;

// Initialize the maximum width and height of the stimuli.
var map_size = 7;

function preload() {
  // Pre-load the stimuli images.  
  stimuli = {
    "DX_DX_0": loadImage(stimuli_path + "DX_DX_0.png"),
    "DX_NX_0": loadImage(stimuli_path + "DX_NX_0.png"),
    "DX_PX_0": loadImage(stimuli_path + "DX_PX_0.png"),
    "DX_UN_0": loadImage(stimuli_path + "DX_UN_0.png"),
    "ND_DX_0": loadImage(stimuli_path + "ND_DX_0.png"),
    "ND_DX_1": loadImage(stimuli_path + "ND_DX_1.png"),
    "ND_NX_0": loadImage(stimuli_path + "ND_NX_0.png"),
    "ND_NX_1": loadImage(stimuli_path + "ND_NX_1.png"),
    "ND_PX_0": loadImage(stimuli_path + "ND_PX_0.png"),
    "ND_PX_1": loadImage(stimuli_path + "ND_PX_1.png"),
    "ND_UN_0": loadImage(stimuli_path + "ND_UN_0.png"),
    "NX_DX_0": loadImage(stimuli_path + "NX_DX_0.png"),
    "NX_NX_0": loadImage(stimuli_path + "NX_NX_0.png"),
    "NX_PX_0": loadImage(stimuli_path + "NX_PX_0.png"),
    "NX_UN_0": loadImage(stimuli_path + "NX_UN_0.png"),
    "PX_DX_0": loadImage(stimuli_path + "PX_DX_0.png"),
    "PX_NX_0": loadImage(stimuli_path + "PX_NX_0.png"),
    "PX_PX_0": loadImage(stimuli_path + "PX_PX_0.png"),
    "PX_UN_0": loadImage(stimuli_path + "PX_UN_0.png"),
    "UN_DX_0": loadImage(stimuli_path + "UN_DX_0.png"),
    "UN_NX_0": loadImage(stimuli_path + "UN_NX_0.png"),
    "UN_PX_0": loadImage(stimuli_path + "UN_PX_0.png"),
    "UN_UN_0": loadImage(stimuli_path + "UN_UN_0.png")
  };
}

function setup() {
  // Set the width and height of the canvas, respectively.
  createCanvas(345, 350);

  // Reserve some space below the canvas for our error messages.
  error_message = createDiv("").size(345);

  // Set up a table to record the path data.
  table = new p5.Table();
  table.addColumn("map");
  table.addColumn("coords");

  // Generate a sequence of numbers and shuffle it.
  var sequence = [];
  for (var i = 0; i < Object.keys(stimuli).length; i++) {
    sequence.push(i);
  }
  shuffle(sequence, true);

  // Generate the trial sequence.
  trials = [];
  for (var i = 0; i < Object.keys(stimuli).length; i++) {
    trials.push(Object.keys(stimuli)[sequence[i]]);
  }

  // Set up the door, wall, and crumb coordinates for the stimuli.
  door_locations = {
    "DX_DX_0": [3, 0, 0, 3],
    "DX_NX_0": [3, 0, 3, 6],
    "DX_PX_0": [2, 0, 6, 5],
    "DX_UN_0": [0, 1, 3, 6],
    "ND_DX_0": [6, 3],
    "ND_DX_1": [6, 1],
    "ND_NX_0": [6, 3],
    "ND_NX_1": [6, 1],
    "ND_PX_0": [6, 1],
    "ND_PX_1": [6, 2],
    "ND_UN_0": [6, 5],
    "NX_DX_0": [0, 3, 5, 6, 6, 3],
    "NX_NX_0": [1, 0, 4, 6, 6, 2],
    "NX_PX_0": [0, 1, 4, 6, 6, 4],
    "NX_UN_0": [0, 3, 5, 6, 6, 3],
    "PX_DX_0": [0, 2, 3, 0, 5, 6],
    "PX_NX_0": [0, 4, 6, 3, 5, 6],
    "PX_PX_0": [0, 1, 4, 0, 4, 6],
    "PX_UN_0": [0, 3, 6, 2, 6, 6],
    "UN_DX_0": [0, 3, 3, 0],
    "UN_NX_0": [0, 5, 5, 0],
    "UN_PX_0": [4, 6, 6, 4],
    "UN_UN_0": [3, 6, 6, 3]
  };

  wall_locations = {
    "DX_DX_0": [-1],
    "DX_NX_0": [1, 0, 1, 1, 1, 2, 1, 3],
    "DX_PX_0": [5, 3, 1, 4, 2, 4, 3, 4, 5, 4, 6, 4],
    "DX_UN_0": [2, 2, 4, 2, 5, 2, 6, 2, 2, 4, 2, 5, 2, 6],
    "ND_DX_0": [-1],
    "ND_DX_1": [-1],
    "ND_NX_0": [-1],
    "ND_NX_1": [-1],
    "ND_PX_0": [-1],
    "ND_PX_1": [3, 1, 4, 1, 5, 1, 6, 1],
    "ND_UN_0": [3, 6, 4, 4, 5, 4, 6, 4],
    "NX_DX_0": [4, 4, 4, 5, 4, 6, 3, 6, 2, 6],
    "NX_NX_0": [-1],
    "NX_PX_0": [2, 4, 2, 5, 2, 6, 3, 2, 4, 2, 5, 2],
    "NX_UN_0": [6, 1, 4, 2, 4, 3, 4, 4, 4, 5, 3, 5, 2, 5, 1, 5, 1, 6],
    "PX_DX_0": [1, 3, 1, 4, 3, 5, 3, 6, 4, 6],
    "PX_NX_0": [0, 1, 1, 1, 2, 1, 4, 1, 5, 1, 6, 1, 4, 3, 4, 4, 4, 5],
    "PX_PX_0": [3, 3, 3, 4, 3, 5, 3, 6],
    "PX_UN_0": [1, 5, 1, 6, 5, 1, 5, 2, 5, 3, 6, 1],
    "UN_DX_0": [0, 4, 1, 4, 2, 4, 4, 1, 4, 2, 5, 2, 6, 2],
    "UN_NX_0": [2, 2, 2, 3, 2, 4, 3, 2, 3, 3, 3, 4, 4, 2, 4, 3, 4, 4],
    "UN_PX_0": [2, 2, 3, 0, 3, 1, 3, 2, 5, 2, 6, 2, 3, 4, 3, 5, 3, 6],
    "UN_UN_0": [2, 2, 2, 4, 2, 5, 2, 6, 4, 2, 5, 2, 6, 2]
  };

  crumb_locations = {
    "DX_DX_0": [2, 4],
    "DX_NX_0": [2, 3],
    "DX_PX_0": [4, 2],
    "DX_UN_0": [3, 3],
    "ND_DX_0": [2, 2],
    "ND_DX_1": [4, 0],
    "ND_NX_0": [2, 3],
    "ND_NX_1": [5, 1],
    "ND_PX_0": [3, 1],
    "ND_PX_1": [2, 0],
    "ND_UN_0": [4, 5],
    "NX_DX_0": [3, 4],
    "NX_NX_0": [3, 3],
    "NX_PX_0": [1, 3],
    "NX_UN_0": [5, 2],
    "PX_DX_0": [0, 4],
    "PX_NX_0": [5, 2],
    "PX_PX_0": [2, 2],
    "PX_UN_0": [5, 4],
    "UN_DX_0": [3, 4],
    "UN_NX_0": [5, 5],
    "UN_PX_0": [1, 3],
    "UN_UN_0": [3, 3]
  };

  // Draw the first trial.
  drawImage();
}

// This function is necessary for registering mouseclicks.
function draw() { 
}

function drawImage() {
  // Set the background color to white.
  background(255);

  // Retrieve the current stimuli to display and draw it.
  var current_stimuli = stimuli[trials[current_trial]];
  image(current_stimuli, 0, 0);
}

function endImage() {
  // Resize the canvas such that it's no longer visible.
  resizeCanvas(0, 0);

  // Convert our table into JSON.
  var json_table = [];
  for (var i = 0; i < trials.length; i++) {
    json_table.push({
      "trial_num": i+1,
      "map": table.getColumn("map")[i],
      "coords": table.getColumn("coords")[i]
    });
  }

  // Prompt the participant to submit their responses.
  var prompt = createDiv(
    "Press the Submit button below to submit your results."
  ).size(345);

  // Set up the submit button.
  var submit = createDiv(
    "<span style=\"text-align:center\">" +
    "<form name=\"SendData\" method=\"post\" action=\"end.php\">" +
    "<input type=\"hidden\" name=\"ExperimentResult\" value=\'" +
    JSON.stringify({"trials": json_table}).replace(/\\\"/g, "") + "\' />" +
    "<button type=\"submit\">Submit</button>" +
    "</form>" +
    "</span>"
  ).size(345);
}

function saveCoords() {
  // Create a new row in our table.
  var new_row = table.addRow();

  // Add the current trial to the map column.
  new_row.setString("map", trials[current_trial]);

  // Add the participant's data to the coords column.
  var coords = "\"";
  for (var c = 0; c < coordinates.length; c++) {
    coords = coords.concat(str(coordinates[c][0]+2), ",", 
      str(coordinates[c][1]+2), ",");
  }
  new_row.setString("coords", 
    coords.substring(0, coords.length-1).concat("\""));
}

function getOccurrence(coordinates, row, col) {
  var num_occurences = 0;
  for (var i = 0; i < coordinates.length; i++) {
    if ((coordinates[i][0] == row) && (coordinates[i][1] == col)) {
      num_occurences++;
    }
  }

  return num_occurences;
}

function mousePressed() {
  // Clear existing error messages.
  error_message.html("");

  // Set up how the marker squares will be drawn after a mouse click.
  stroke(51);
  fill(225);
  rectMode(CENTER);

  // Check which square the mouse click was in and draw a marker square 
  // inside.
  for (var row = 0; row < map_size; row++) {
    // Set the bounds for this row and check if the mouse click was between
    // them.
    var row_lower_bound = row * (345/map_size)
    var row_upper_bound = (row+1) * (345/map_size)
    if ((mouseX > row_lower_bound) && (mouseX <= row_upper_bound)) {
      for (var col = 0; col < 7; col++) {
        // Set the bounds for this column and check if the mouse click was 
        // between them.
        var col_lower_bound = col * (350/map_size)
        var col_upper_bound = (col+1) * (350/map_size)
        if ((mouseY > col_lower_bound) && (mouseY <= col_upper_bound)) {
          // Execute if these are the first coordinates.
          if (coordinates.length == 0) {
          	drawImage();
          	var valid_door_flag = 0;
            // Check if these coordinates are on a door.
            for (var i = 0; i < door_locations[trials[current_trial]].length; 
                i += 2) {
              // If these coordinates are on a door, set the flag to 1, draw
              // the marker square, and store the coordinates.
              if (row == door_locations[trials[current_trial]][i] &&
                  col == door_locations[trials[current_trial]][i+1]) {
              	valid_door_flag = 1;

              	// Change the shade of the marker square depending on how many 
                // times this square has been selected.
              	if (getOccurrence(coordinates, row, col) == 1) {
                  fill(160);
                } else if (getOccurrence(coordinates, row, col) == 2) {
                  fill(80);
                } else if (getOccurrence(coordinates, row, col) >= 3) {
                  fill(0);
                }

                // Draw the marker square.
              	rect((row_lower_bound+row_upper_bound)/2, 
                  (col_lower_bound+col_upper_bound)/2, 20, 20);
              	
                // Store the coordinates.
              	coordinates.push([row, col]);
            	}
            }

            // If these coordinates are not on a door, throw an error message.
            if (valid_door_flag == 0){
              error_message.html("Error: Your path must start at a door.");
            }
          }

          // Execute if these are not the first coordinates.
          else {
            // Check if these coordinates are adjacent to the previous pair.
            if ((row == coordinates[coordinates.length-1][0]+1 &&
                col == coordinates[coordinates.length-1][1]) ||
                (row == coordinates[coordinates.length-1][0]-1 &&
                col == coordinates[coordinates.length-1][1]) ||
                (row == coordinates[coordinates.length-1][0] && 
                col == coordinates[coordinates.length-1][1]+1) ||
                (row == coordinates[coordinates.length-1][0] && 
                col == coordinates[coordinates.length-1][1]-1)) {
              // Check if these coordinates are at a wall.
              var wall_flag = 0;
              for (var i = 0; 
                  i < wall_locations[trials[current_trial]].length; i += 2) {
                // If the first value is -1, it means there are no walls in 
                // the map
                if (wall_locations[trials[current_trial]][0] == -1) {
                  break;
                } else if (row == wall_locations[trials[current_trial]][i] &&
                    col == wall_locations[trials[current_trial]][i+1]) {
                  wall_flag = 1;
                }
              }

              // Check if these coordinates are at the pile of cookie crumbs.
              for (var i = 0; 
                  i < crumb_locations[trials[current_trial]].length; i += 2) {
                if (row == crumb_locations[trials[current_trial]][i] &&
                    col == crumb_locations[trials[current_trial]][i+1]) {
                  cookie_flag = 1;
                }
              }

              // Execute if these coordinates are not at a wall.
              if (wall_flag == 0) {
                // Change the shade of the marker square depending on how 
                // many times this square has been selected.
                if (getOccurrence(coordinates, row, col) == 1) {
                  fill(160);
                } else if (getOccurrence(coordinates, row, col) == 2) {
                  fill(80);
                } else if (getOccurrence(coordinates, row, col) >= 3) {
                  fill(0);
                }

                // Draw the marker square.
                rect((row_lower_bound+row_upper_bound)/2, 
                  (col_lower_bound+col_upper_bound)/2, 20, 20);

                // Store the coordinates.
                coordinates.push([row, col]);

                // If these coordinates are at a goal, increment the goal flag.
                if ((row == 0 && col == 0) || (row == 0 && col == 6) || 
                    (row == 6 && col == 0)) {
                  goal_flag += 1;
                }
              }
            }
          }
        }
      }
    }
  }
}

function keyPressed() {
  // Clear existing error messages.
  error_message.html("");

	// Execute if the right arrow key is pressed.
	if (keyCode == RIGHT_ARROW) {
    // Execute if the most recent coordinates were at a goal.
		if (coordinates.length > 0 &&
        ((coordinates[coordinates.length-1][0] == 0 && 
        coordinates[coordinates.length-1][1] == 0) ||
        (coordinates[coordinates.length-1][0] == 0 && 
        coordinates[coordinates.length-1][1] == 6) ||
        (coordinates[coordinates.length-1][0] == 6 && 
        coordinates[coordinates.length-1][1] == 0))) {

      // If the path contains more than one goal, throw an error. If the path 
      // contains only one goal, but does not contain the pile of cookie 
      // crumbs, also throw an error. If the path only contains one goal and 
      // the pile of cookie  crumbs, then store the path and move to the next 
      // trial.
      if (goal_flag != 1) {
        error_message.html(
          "Error: Your path cannot contain a goal more than once. Press R " + 
          "to reset."
        );
    	} else if (goal_flag == 1 && cookie_flag == 0) {
        error_message.html(
          "Error: Your path must contain the cookie crumbs. Press R to reset."
        );
      } else if (goal_flag == 1 && cookie_flag == 1) {
  			saveCoords();
  			if (current_trial < trials.length-1) {
  				current_trial++;
      		drawImage();
      		coordinates = [];
      		cookie_flag = 0;
      		goal_flag = 0;
        } else {
      		endImage();
      	}
      }
    } else {
      error_message.html(
        "Error: Your path must finish at a goal. Continue your path or " + 
        "press R to reset."
      );
    }
  }
  
  // Execute if the R key is pressed.
  if (key == 'r') {
    // Clear existing error messages.
    error_message.html("");

    // Reset the list of coordinates.
    coordinates = [];

    // Reset the flags.
    cookie_flag = 0;
    goal_flag = 0;

    // Redraw the image.
    drawImage();
  }
}