let current_image;
let table; //for storing participant data
var maps; //list of all stim maps (strings.
var map_size; //number of trials. 23 in this experiment
var current_map = 0; //counter for iterating through list of maps
var cols = 7; //grid world info
var rows = 7;
var participant; //participant number for data storage
var cookieflag = 0; //flag used to make sure path drawn goes over the cookie crumb
var finishedflag = 0; //flag used to make sure once you go to one goal, you cannot move

var coordinates = []; //where we will store coordinates of path
var door_locations = {}; //where map's door coordinates will go
var wall_locations = {}; //where map's wall coordinates will go
var crumb_locations = {}; //where map's crumb coordinate will go


//set path to file with stimuli and path to file with data
let stimuli_path = "../stims/";
let data_path = "../data/";

let images = [];
let DXDX0;
let DXNX0;
let DXPX0;
let DXUN0;
let NDDX0;
let NDDX1;
let NDNX0;
let NDNX1;
let NDPX0;
let NDPX1;
let NDUN0;
let NXDX0;
let NXNX0;
let NXPX0;
let NXUN0;
let PXDX0;
let PXNX0;
let PXPX0;
let PXUN0;
let UNDX0;
let UNNX0;
let UNPX0;
let UNUN0;


//preload map images
function preload() {

  DXDX0 = loadImage(stimuli_path + "DX_DX_0.png");
  DXNX0 = loadImage(stimuli_path + "DX_NX_0.png");
  DXPX0 = loadImage(stimuli_path + "DX_PX_0.png");
  DXUN0 = loadImage(stimuli_path + "DX_UN_0.png");
  NDDX0 = loadImage(stimuli_path + "ND_DX_0.png");
  NDDX1 = loadImage(stimuli_path + "ND_DX_1.png");
  NDNX0 = loadImage(stimuli_path + "ND_NX_0.png");
  NDNX1 = loadImage(stimuli_path + "ND_NX_1.png");
  NDPX0 = loadImage(stimuli_path + "ND_PX_0.png");
  NDPX1 = loadImage(stimuli_path + "ND_PX_1.png");
  NDUN0 = loadImage(stimuli_path + "ND_UN_0.png");
  NXDX0 = loadImage(stimuli_path + "NX_DX_0.png");
  NXNX0 = loadImage(stimuli_path + "NX_NX_0.png");
  NXPX0 = loadImage(stimuli_path + "NX_PX_0.png");
  NXUN0 = loadImage(stimuli_path + "NX_UN_0.png");
  PXDX0 = loadImage(stimuli_path + "PX_DX_0.png");
  PXNX0 = loadImage(stimuli_path + "PX_NX_0.png");
  PXPX0 = loadImage(stimuli_path + "PX_PX_0.png");
  PXUN0 = loadImage(stimuli_path + "PX_UN_0.png");
  UNDX0 = loadImage(stimuli_path + "UN_DX_0.png");
  UNNX0 = loadImage(stimuli_path + "UN_NX_0.png");
  UNPX0 = loadImage(stimuli_path + "UN_PX_0.png");
  UNUN0 = loadImage(stimuli_path + "UN_UN_0.png");
  end_slide = loadImage(stimuli_path + "finish.png");
}


function setup() {
  //resolution of the screen
  createCanvas(345, 400);

  //set up table to record data to be stored in csv file
  table = new p5.Table();
  table.addColumn("participant");
  table.addColumn("map");
  table.addColumn("coords");

  //can't access directory to read file names and see what participant ID should be.. 
  //so for now, just setting participant ID# to 0:
  participant = 0;

  images = {
    "DX_DX_0": DXDX0,
    "DX_NX_0": DXNX0,
    "DX_PX_0": DXPX0,
    "DX_UN_0": DXUN0,
    "ND_DX_0": NDDX0,
    "ND_DX_1": NDDX1,
    "ND_NX_0": NDNX0,
    "ND_NX_1": NDNX1,
    "ND_PX_0": NDPX0,
    "ND_PX_1": NDPX1,
    "ND_UN_0": NDUN0,
    "NX_DX_0": NXDX0,
    "NX_NX_0": NXNX0,
    "NX_PX_0": NXPX0,
    "NX_UN_0": NXUN0,
    "PX_DX_0": PXDX0,
    "PX_NX_0": PXNX0,
    "PX_PX_0": PXPX0,
    "PX_UN_0": PXUN0,
    "UN_DX_0": UNDX0,
    "UN_NX_0": UNNX0,
    "UN_PX_0": UNPX0,
    "UN_UN_0": UNUN0
  }

  //list of all stimuli images
  maps = ["DX_DX_0", "DX_NX_0", "DX_PX_0", "DX_UN_0", "ND_DX_0", "ND_DX_1", "ND_NX_0", "ND_NX_1",
    "ND_PX_0", "ND_PX_1", "ND_UN_0", "NX_DX_0", "NX_NX_0", "NX_PX_0", "NX_UN_0", "PX_DX_0",
    "PX_NX_0", "PX_PX_0", "PX_UN_0", "UN_DX_0", "UN_NX_0", "UN_PX_0", "UN_UN_0"
  ];  
  //randomize order of the map/stimuli presentation
  shuffle(maps, true); 
  map_size = maps.length; //number of stimuli in list

  //set up the door, wall, and crumb coordinates for the maps:
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
  }

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
  }


  drawImage();
}

function draw() { //need to have draw. otherwise won't register mouseclicks 
}

function drawImage() {
  background(255);
  current_image = images[maps[current_map]];
  //Draw the image to the screen at coordinate (0,0)
  image(current_image, 0, 0);
}

function endImage() {
  background(255);
  final_image = end_slide;
  image(final_image, 0, 0);
}

function getOccurrence(array, xcoord, ycoord) {
  var num_occurence = 0;
  for (var i = 0; i < array.length; i++){
    if ((array[i][0] == xcoord) && (array[i][1] == ycoord)){
      num_occurence++;
    }
  }

  return num_occurence;
}

//save coordinates from the valid clicks into table
function saveCoords() {
  let newRow = table.addRow();
  newRow.setNum('participant', participant);
  newRow.setString('map', maps[current_map]);
  var coords = "\"";
  for (var coord = 0; coord < coordinates.length; coord++) {
    coords = coords.concat(str(coordinates[coord][0] + 2), ",", str(coordinates[coord][1] + 2), ",");
  }
  newRow.setString('coords', coords.substring(0, coords.length - 1).concat("\""));
}

function mousePressed() {
  stroke(51);
  fill(225); //225, 160, 80, 0 
  rectMode(CENTER); //draw small grey square where clicked

  //if (finishedflag == 0) {
    //logic for checking click and recording data
    for (var row = 0; row < 7; row++) {
      if ((mouseX > (row * (345 / 7))) && (mouseX <= ((row + 1) * (345 / 7)))) {
        for (var col = 0; col < 7; col++) {
          if ((mouseY > (col * (350 / 7))) && (mouseY <= ((col + 1) * (350 / 7)))) {

            //if it's the first coordinate, check if it's at a door coordinate
            if (coordinates.length == 0) {
              drawImage();
              let pathstartflag = 0;
              //iterate to check if the first click is at a valid coordinate
              for (var i = 0; i < door_locations[maps[current_map]].length; i += 2) {
                if (row == door_locations[maps[current_map]][i] &&
                  col == door_locations[maps[current_map]][i + 1]) {
                  pathstartflag = 1;
                  //draw rectangle, valid.
                  //see how many times the coordinate has been recorded. changes the shade
                  if (getOccurrence(coordinates, row, col) == 1){
                      fill(160);
                    }
                    else if (getOccurrence(coordinates, row, col) == 2){
                      fill(80);
                    }
                    else if (getOccurrence(coordinates, row, col) >= 3){
                      fill(0);
                    }

                    rect(((row * 345 / 7) + ((row + 1) * (345 / 7))) / 2, ((col * 345 / 7) + ((col + 1) * (345 / 7))) / 2, 20, 20);
                    //store data
                    coordinates.push([row, col]);
                  }
              }

              if (pathstartflag == 0){
                let s = 'Error: path must start at a door';
                fill(0);
                text(s, 5, 375);
              }
            }

            //not the first coordinate
            else {
              //is it adjacent to the previous box/click?
              if (
                (row == coordinates[coordinates.length - 1][0] + 1 && col == coordinates[coordinates.length - 1][1]) ||
                (row == coordinates[coordinates.length - 1][0] - 1 && col == coordinates[coordinates.length - 1][1]) ||
                (row == coordinates[coordinates.length - 1][0] && col == coordinates[coordinates.length - 1][1] + 1) ||
                (row == coordinates[coordinates.length - 1][0] && col == coordinates[coordinates.length - 1][1] - 1)) {
                //Is it not a wall? 
                var flag = 0;
                for (var i = 0; i < wall_locations[maps[current_map]].length; i += 2) {
                  //if the first value is -1, it means there are no walls in the map
                  if (wall_locations[maps[current_map]][0] == -1) {
                    break;
                  } else if (row == wall_locations[maps[current_map]][i] &&
                    col == wall_locations[maps[current_map]][i + 1]) {
                    //error it's a wall
                    flag = 1;
                  }
                }

                //is it a cookie crumb location?
                for (var i = 0; i < crumb_locations[maps[current_map]].length; i += 2) {
                  if (row == crumb_locations[maps[current_map]][i] &&
                    col == crumb_locations[maps[current_map]][i + 1]) {
                    //it's the cookie crumb
                    cookieflag = 1;
                  }
                }

                if (flag == 0) {
                  //is it a finishing coordinate? If so, end array, save data, clear array
                  if ((row == 0 && col == 0) || (row == 0 && col == 6) || (row == 6 && col == 0)) {
                    //draw the rectangle
                    //see how many times the coordinate has been recorded. changes the shade
                    if (getOccurrence(coordinates, row, col) == 1){
                      fill(160);
                    }
                    else if (getOccurrence(coordinates, row, col) == 2){
                      fill(80);
                    }
                    else if (getOccurrence(coordinates, row, col) >= 3){
                      fill(0);
                    }
                    rect(((row * 345 / 7) + ((row + 1) * (345 / 7))) / 2, ((col * 345 / 7) + ((col + 1) * (345 / 7))) / 2, 20, 20);
                    //store the data
                    coordinates.push([row, col]);
                    finishedflag += 1;
                  }

                  //else, add to the array and increment array counter
                  else {
                    //draw shape
                    //see how many times the coordinate has been recorded. changes the shade
                    if (getOccurrence(coordinates, row, col) == 1){
                      fill(160);
                    }
                    else if (getOccurrence(coordinates, row, col) == 2){
                      fill(80);
                    }
                    else if (getOccurrence(coordinates, row, col) >= 3){
                      fill(0);
                    }
                    rect(((row * 345 / 7) + ((row + 1) * (345 / 7))) / 2, ((col * 345 / 7) + ((col + 1) * (345 / 7))) / 2, 20, 20);
                    //store data
                    coordinates.push([row, col]);
                  }
                } else {
                  //else wall condition. nothing happens
                }
              } else {
                //not one block away. nothing happens
              }
            }
          }
        }
      }
    }
}

function keyPressed() {
  //right arrow to go to the next map
  if (keyCode == RIGHT_ARROW) {
    if (coordinates.length > 0 &&
      ((coordinates[coordinates.length - 1][0] == 0 && coordinates[coordinates.length - 1][1] == 0) ||
          (coordinates[coordinates.length - 1][0] == 0 && coordinates[coordinates.length - 1][1] == 6) ||
          (coordinates[coordinates.length - 1][0] == 6 && coordinates[coordinates.length - 1][1] == 0))) {

          if (finishedflag != 1){
            let s = 'Error: the path cannot contain a goal more than once.';
            let r = 'Press R to reset';
            fill(0);
            text(s, 5, 365);
            text(r, 5, 380);
        }

        else if (finishedflag == 1 && cookieflag == 1) {
          saveCoords();
          if (current_map < map_size - 1) {
            current_map++;
                //img load
                drawImage();
                coordinates = [];
                cookieflag = 0;
                finishedflag = 0;
              } 

              else {
              saveTable(table, data_path.concat(participant, ".csv"));
                endImage();
              }
            }

            else if (finishedflag == 1 && cookieflag == 0){
              let s = 'Error: the path must contain the cookie crumb.';
              let r = 'Press R to reset';
              fill(0);
              text(s, 5, 365);
              text(r, 5, 380);
            }
        }

        else{
          let s = 'Error: the path must finish at a goal corner.';
          let r = 'You can press R to reset';
          fill(0);
          text(s, 5, 365);
          text(r, 5, 380);
        }
    }
  

  //R key is for reset
  if (key == 'r') {
    //reset coordinates array
    coordinates = [];
    //set flags back
    cookieflag = 0;
    finishedflag = 0;
    //reset image, clean slate.
    drawImage();
  }
}