import java.util.Map;
import java.util.Arrays;
import static javax.swing.JOptionPane.*;
Table table; //For storing participant data

PImage img; //Declare a variable of the type PImage 
StringList maps; //Our list of strings (names of all stim maps)
int map_size; //23 for this experiment
int current_map = 0; //counter for going through list of maps
int cols = 7; //7 cols in our gridworld
int rows = 7; //7 rows in our gridworld
int participant; //participant num_value for data storage
int cookieflag = 0; //flag. used to make sure the path drawn goes over the cookie crumb at some point before finishing
int finishedflag = 0; //flag to disable possibility of going to one goal corner, and moving to another

ArrayList<ArrayList<Integer>> coordinates = new ArrayList<ArrayList<Integer>>(); //set up array 
HashMap<String, ArrayList<Integer>> door_locations = new HashMap<String, ArrayList<Integer>>(); //map door information
HashMap<String, ArrayList<Integer>> wall_locations = new HashMap<String, ArrayList<Integer>>(); //map wall information
HashMap<String, ArrayList<Integer>> crumb_locations = new HashMap<String, ArrayList<Integer>>(); //map crumb information 

// Set up the absolute path to the stimuli.
String stimuli_path = "D:/Research/ImageInference/stimuli/experiment_2/";

// Set up the absolute path to the data.
String data_path = "D:/Research/ImageInference/data/experiment_2/human/";

void setup(){
  //resolution of the screen
  size(345, 350);
  
  table = new Table();
  
  table.addColumn("participant");
  table.addColumn("map");
  table.addColumn("coords");
  
  //writing participant data into csv file. will add row by row. Each row contains coordinates of the path for one map
  File dir = new File(data_path); //This is the line that finds the directory containing participant data.
  String files[] = dir.list();
  participant = -1;
  for (String file : files) { //iterate to get the new participant numbers. Checks by looking at the participant data file name (which contains the participant ID)
    try {
      if (Integer.parseInt(file.substring(5, file.length() - 4)) > participant) {
        participant = Integer.parseInt(file.substring(5, file.length() - 4));
      }
    }
    catch(Exception e) {
    }
  }
  participant++;
  
  //create list of our stimuli images
  maps = new StringList();
  maps.append("DX_DX_0");
  maps.append("DX_NX_0");
  maps.append("DX_PX_0");
  maps.append("DX_UN_0");
  maps.append("ND_DX_0");
  maps.append("ND_DX_1");
  maps.append("ND_NX_0");
  maps.append("ND_NX_1");
  maps.append("ND_PX_0");
  maps.append("ND_PX_1");
  maps.append("ND_UN_0");
  maps.append("NX_DX_0");
  maps.append("NX_NX_0");
  maps.append("NX_PX_0");
  maps.append("NX_UN_0");
  maps.append("PX_DX_0");
  maps.append("PX_NX_0");
  maps.append("PX_PX_0");
  maps.append("PX_UN_0");
  maps.append("UN_DX_0");
  maps.append("UN_NX_0");
  maps.append("UN_PX_0");
  maps.append("UN_UN_0");
  //randomize order of the list
  maps.shuffle();
  //# of stims/elements in list
  map_size = maps.size();
  //Make new instance of the PImage class by loading the first image file
  //img = loadImage(stimuli_path.concat(maps.get(0).concat(".png")));
  img = loadImage(stimuli_path + maps.get(0) + ".png");
  
  //setting up the door, wall, and crumb locations of the maps
  door_locations.put("DX_DX_0", new ArrayList<Integer>());
  door_locations.get("DX_DX_0").add(3);
  door_locations.get("DX_DX_0").add(0);
  door_locations.get("DX_DX_0").add(0);
  door_locations.get("DX_DX_0").add(3);
  
  wall_locations.put("DX_DX_0", new ArrayList<Integer>());
  wall_locations.get("DX_DX_0").add(-1);
  
  crumb_locations.put("DX_DX_0", new ArrayList<Integer>());
  crumb_locations.get("DX_DX_0").add(2);
  crumb_locations.get("DX_DX_0").add(4);
  
  door_locations.put("DX_NX_0", new ArrayList<Integer>());
  door_locations.get("DX_NX_0").add(3);
  door_locations.get("DX_NX_0").add(0);
  door_locations.get("DX_NX_0").add(3);
  door_locations.get("DX_NX_0").add(6);
  
  wall_locations.put("DX_NX_0", new ArrayList<Integer>());
  wall_locations.get("DX_NX_0").add(1);
  wall_locations.get("DX_NX_0").add(0);
  wall_locations.get("DX_NX_0").add(1);
  wall_locations.get("DX_NX_0").add(1);
  wall_locations.get("DX_NX_0").add(1);
  wall_locations.get("DX_NX_0").add(2);
  wall_locations.get("DX_NX_0").add(1);
  wall_locations.get("DX_NX_0").add(3);
  
  crumb_locations.put("DX_NX_0", new ArrayList<Integer>());
  crumb_locations.get("DX_NX_0").add(2);
  crumb_locations.get("DX_NX_0").add(3);
  
  door_locations.put("DX_PX_0", new ArrayList<Integer>());
  door_locations.get("DX_PX_0").add(2);
  door_locations.get("DX_PX_0").add(0);
  door_locations.get("DX_PX_0").add(6);
  door_locations.get("DX_PX_0").add(5);
  
  wall_locations.put("DX_PX_0", new ArrayList<Integer>());
  wall_locations.get("DX_PX_0").add(5);
  wall_locations.get("DX_PX_0").add(3);
  wall_locations.get("DX_PX_0").add(1);
  wall_locations.get("DX_PX_0").add(4);
  wall_locations.get("DX_PX_0").add(2);
  wall_locations.get("DX_PX_0").add(4);
  wall_locations.get("DX_PX_0").add(3);
  wall_locations.get("DX_PX_0").add(4);
  wall_locations.get("DX_PX_0").add(5);
  wall_locations.get("DX_PX_0").add(4);
  wall_locations.get("DX_PX_0").add(6);
  wall_locations.get("DX_PX_0").add(4);
  
  crumb_locations.put("DX_PX_0", new ArrayList<Integer>());
  crumb_locations.get("DX_PX_0").add(4);
  crumb_locations.get("DX_PX_0").add(2);
  
  door_locations.put("DX_UN_0", new ArrayList<Integer>());
  door_locations.get("DX_UN_0").add(0);
  door_locations.get("DX_UN_0").add(1);
  door_locations.get("DX_UN_0").add(3);
  door_locations.get("DX_UN_0").add(6);
  
  wall_locations.put("DX_UN_0", new ArrayList<Integer>());
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(4);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(5);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(6);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(4);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(5);
  wall_locations.get("DX_UN_0").add(2);
  wall_locations.get("DX_UN_0").add(6);
  
  crumb_locations.put("DX_UN_0", new ArrayList<Integer>());
  crumb_locations.get("DX_UN_0").add(3);
  crumb_locations.get("DX_UN_0").add(3);
  
  door_locations.put("ND_DX_0", new ArrayList<Integer>());
  door_locations.get("ND_DX_0").add(6);
  door_locations.get("ND_DX_0").add(3);
  
  wall_locations.put("ND_DX_0", new ArrayList<Integer>());
  wall_locations.get("ND_DX_0").add(-1);
  
  crumb_locations.put("ND_DX_0", new ArrayList<Integer>());
  crumb_locations.get("ND_DX_0").add(2);
  crumb_locations.get("ND_DX_0").add(2);
  
  door_locations.put("ND_DX_1", new ArrayList<Integer>());
  door_locations.get("ND_DX_1").add(6);
  door_locations.get("ND_DX_1").add(1);

  wall_locations.put("ND_DX_1", new ArrayList<Integer>());
  wall_locations.get("ND_DX_1").add(-1);
  
  crumb_locations.put("ND_DX_1", new ArrayList<Integer>());
  crumb_locations.get("ND_DX_1").add(4);
  crumb_locations.get("ND_DX_1").add(0);

  door_locations.put("ND_NX_0", new ArrayList<Integer>());
  door_locations.get("ND_NX_0").add(6);
  door_locations.get("ND_NX_0").add(3);
  
  wall_locations.put("ND_NX_0", new ArrayList<Integer>());
  wall_locations.get("ND_NX_0").add(-1);
  
  crumb_locations.put("ND_NX_0", new ArrayList<Integer>());
  crumb_locations.get("ND_NX_0").add(2);
  crumb_locations.get("ND_NX_0").add(3);

  door_locations.put("ND_NX_1", new ArrayList<Integer>());
  door_locations.get("ND_NX_1").add(6);
  door_locations.get("ND_NX_1").add(1); 
  
  wall_locations.put("ND_NX_1", new ArrayList<Integer>());
  wall_locations.get("ND_NX_1").add(-1);
  
  crumb_locations.put("ND_NX_1", new ArrayList<Integer>());
  crumb_locations.get("ND_NX_1").add(5);
  crumb_locations.get("ND_NX_1").add(1);
  
  door_locations.put("ND_PX_0", new ArrayList<Integer>());
  door_locations.get("ND_PX_0").add(6);
  door_locations.get("ND_PX_0").add(1);
  
  wall_locations.put("ND_PX_0", new ArrayList<Integer>());
  wall_locations.get("ND_PX_0").add(-1);
  
  crumb_locations.put("ND_PX_0", new ArrayList<Integer>());
  crumb_locations.get("ND_PX_0").add(3);
  crumb_locations.get("ND_PX_0").add(1);
  
  door_locations.put("ND_PX_1", new ArrayList<Integer>());
  door_locations.get("ND_PX_1").add(6);
  door_locations.get("ND_PX_1").add(2);

  wall_locations.put("ND_PX_1", new ArrayList<Integer>());
  wall_locations.get("ND_PX_1").add(3);
  wall_locations.get("ND_PX_1").add(1);
  wall_locations.get("ND_PX_1").add(4);
  wall_locations.get("ND_PX_1").add(1);
  wall_locations.get("ND_PX_1").add(5);
  wall_locations.get("ND_PX_1").add(1);
  wall_locations.get("ND_PX_1").add(6);
  wall_locations.get("ND_PX_1").add(1);
  
  crumb_locations.put("ND_PX_1", new ArrayList<Integer>());
  crumb_locations.get("ND_PX_1").add(2);
  crumb_locations.get("ND_PX_1").add(0);
  
  door_locations.put("ND_UN_0", new ArrayList<Integer>());
  door_locations.get("ND_UN_0").add(6);
  door_locations.get("ND_UN_0").add(5);
  
  wall_locations.put("ND_UN_0", new ArrayList<Integer>());
  wall_locations.get("ND_UN_0").add(3);
  wall_locations.get("ND_UN_0").add(6);
  wall_locations.get("ND_UN_0").add(4);
  wall_locations.get("ND_UN_0").add(4);
  wall_locations.get("ND_UN_0").add(5);
  wall_locations.get("ND_UN_0").add(4);
  wall_locations.get("ND_UN_0").add(6);
  wall_locations.get("ND_UN_0").add(4);
  
  crumb_locations.put("ND_UN_0", new ArrayList<Integer>());
  crumb_locations.get("ND_UN_0").add(4);
  crumb_locations.get("ND_UN_0").add(5);
  
  door_locations.put("NX_DX_0", new ArrayList<Integer>());
  door_locations.get("NX_DX_0").add(0);
  door_locations.get("NX_DX_0").add(3);
  door_locations.get("NX_DX_0").add(5);
  door_locations.get("NX_DX_0").add(6);
  door_locations.get("NX_DX_0").add(6);
  door_locations.get("NX_DX_0").add(3);
  
  wall_locations.put("NX_DX_0", new ArrayList<Integer>());
  wall_locations.get("NX_DX_0").add(4);
  wall_locations.get("NX_DX_0").add(4);
  wall_locations.get("NX_DX_0").add(4);
  wall_locations.get("NX_DX_0").add(5);
  wall_locations.get("NX_DX_0").add(4);
  wall_locations.get("NX_DX_0").add(6);
  wall_locations.get("NX_DX_0").add(3);
  wall_locations.get("NX_DX_0").add(6);
  wall_locations.get("NX_DX_0").add(2);
  wall_locations.get("NX_DX_0").add(6);
  
  crumb_locations.put("NX_DX_0", new ArrayList<Integer>());
  crumb_locations.get("NX_DX_0").add(3);
  crumb_locations.get("NX_DX_0").add(4);

  door_locations.put("NX_NX_0", new ArrayList<Integer>());
  door_locations.get("NX_NX_0").add(1);
  door_locations.get("NX_NX_0").add(0);
  door_locations.get("NX_NX_0").add(4);
  door_locations.get("NX_NX_0").add(6);
  door_locations.get("NX_NX_0").add(6);
  door_locations.get("NX_NX_0").add(2);
  
  wall_locations.put("NX_NX_0", new ArrayList<Integer>());
  wall_locations.get("NX_NX_0").add(-1);
  
  crumb_locations.put("NX_NX_0", new ArrayList<Integer>());
  crumb_locations.get("NX_NX_0").add(3);
  crumb_locations.get("NX_NX_0").add(3);
  
  door_locations.put("NX_PX_0", new ArrayList<Integer>());
  door_locations.get("NX_PX_0").add(0);
  door_locations.get("NX_PX_0").add(1);
  door_locations.get("NX_PX_0").add(4);
  door_locations.get("NX_PX_0").add(6);
  door_locations.get("NX_PX_0").add(6);
  door_locations.get("NX_PX_0").add(4);
  
  wall_locations.put("NX_PX_0", new ArrayList<Integer>());
  wall_locations.get("NX_PX_0").add(2);
  wall_locations.get("NX_PX_0").add(4);
  wall_locations.get("NX_PX_0").add(2);
  wall_locations.get("NX_PX_0").add(5);
  wall_locations.get("NX_PX_0").add(2);
  wall_locations.get("NX_PX_0").add(6);
  wall_locations.get("NX_PX_0").add(3);
  wall_locations.get("NX_PX_0").add(2);
  wall_locations.get("NX_PX_0").add(4);
  wall_locations.get("NX_PX_0").add(2);
  wall_locations.get("NX_PX_0").add(5);
  wall_locations.get("NX_PX_0").add(2);
  
  crumb_locations.put("NX_PX_0", new ArrayList<Integer>());
  crumb_locations.get("NX_PX_0").add(1);
  crumb_locations.get("NX_PX_0").add(3);
  
  door_locations.put("NX_UN_0", new ArrayList<Integer>());
  door_locations.get("NX_UN_0").add(0);
  door_locations.get("NX_UN_0").add(3);
  door_locations.get("NX_UN_0").add(5);
  door_locations.get("NX_UN_0").add(6);
  door_locations.get("NX_UN_0").add(6);
  door_locations.get("NX_UN_0").add(3);
  
  wall_locations.put("NX_UN_0", new ArrayList<Integer>());
  wall_locations.get("NX_UN_0").add(6);
  wall_locations.get("NX_UN_0").add(1);
  wall_locations.get("NX_UN_0").add(4);
  wall_locations.get("NX_UN_0").add(2);
  wall_locations.get("NX_UN_0").add(4);
  wall_locations.get("NX_UN_0").add(3);
  wall_locations.get("NX_UN_0").add(4);
  wall_locations.get("NX_UN_0").add(4);
  wall_locations.get("NX_UN_0").add(4);
  wall_locations.get("NX_UN_0").add(5);
  wall_locations.get("NX_UN_0").add(3);
  wall_locations.get("NX_UN_0").add(5);
  wall_locations.get("NX_UN_0").add(2);
  wall_locations.get("NX_UN_0").add(5);
  wall_locations.get("NX_UN_0").add(1);
  wall_locations.get("NX_UN_0").add(5);
  wall_locations.get("NX_UN_0").add(1);
  wall_locations.get("NX_UN_0").add(6);
  
  crumb_locations.put("NX_UN_0", new ArrayList<Integer>());
  crumb_locations.get("NX_UN_0").add(5);
  crumb_locations.get("NX_UN_0").add(2);
  
  door_locations.put("PX_DX_0", new ArrayList<Integer>());
  door_locations.get("PX_DX_0").add(0);
  door_locations.get("PX_DX_0").add(2);
  door_locations.get("PX_DX_0").add(3);
  door_locations.get("PX_DX_0").add(0);
  door_locations.get("PX_DX_0").add(5);
  door_locations.get("PX_DX_0").add(6);
  
  wall_locations.put("PX_DX_0", new ArrayList<Integer>());
  wall_locations.get("PX_DX_0").add(1);
  wall_locations.get("PX_DX_0").add(3);
  wall_locations.get("PX_DX_0").add(1);
  wall_locations.get("PX_DX_0").add(4);
  wall_locations.get("PX_DX_0").add(3);
  wall_locations.get("PX_DX_0").add(5);
  wall_locations.get("PX_DX_0").add(3);
  wall_locations.get("PX_DX_0").add(6);
  wall_locations.get("PX_DX_0").add(4);
  wall_locations.get("PX_DX_0").add(6);
  
  crumb_locations.put("PX_DX_0", new ArrayList<Integer>());
  crumb_locations.get("PX_DX_0").add(0);
  crumb_locations.get("PX_DX_0").add(4);
  
  door_locations.put("PX_NX_0", new ArrayList<Integer>());
  door_locations.get("PX_NX_0").add(0);
  door_locations.get("PX_NX_0").add(4);
  door_locations.get("PX_NX_0").add(6);
  door_locations.get("PX_NX_0").add(3);
  door_locations.get("PX_NX_0").add(5);
  door_locations.get("PX_NX_0").add(6);
  
  wall_locations.put("PX_NX_0", new ArrayList<Integer>());
  wall_locations.get("PX_NX_0").add(0);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(2);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(4);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(5);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(6);
  wall_locations.get("PX_NX_0").add(1);
  wall_locations.get("PX_NX_0").add(4);
  wall_locations.get("PX_NX_0").add(3);
  wall_locations.get("PX_NX_0").add(4);
  wall_locations.get("PX_NX_0").add(4);
  wall_locations.get("PX_NX_0").add(4);
  wall_locations.get("PX_NX_0").add(5);
  
  crumb_locations.put("PX_NX_0", new ArrayList<Integer>());
  crumb_locations.get("PX_NX_0").add(5);
  crumb_locations.get("PX_NX_0").add(2);
  
  door_locations.put("PX_PX_0", new ArrayList<Integer>());
  door_locations.get("PX_PX_0").add(0);
  door_locations.get("PX_PX_0").add(1);
  door_locations.get("PX_PX_0").add(4);
  door_locations.get("PX_PX_0").add(0);
  door_locations.get("PX_PX_0").add(4);
  door_locations.get("PX_PX_0").add(6);
  
  wall_locations.put("PX_PX_0", new ArrayList<Integer>());
  wall_locations.get("PX_PX_0").add(3);
  wall_locations.get("PX_PX_0").add(3);
  wall_locations.get("PX_PX_0").add(3);
  wall_locations.get("PX_PX_0").add(4);
  wall_locations.get("PX_PX_0").add(3);
  wall_locations.get("PX_PX_0").add(5);
  wall_locations.get("PX_PX_0").add(3);
  wall_locations.get("PX_PX_0").add(6);
  
  crumb_locations.put("PX_PX_0", new ArrayList<Integer>());
  crumb_locations.get("PX_PX_0").add(2);
  crumb_locations.get("PX_PX_0").add(2);
  
  door_locations.put("PX_UN_0", new ArrayList<Integer>());
  door_locations.get("PX_UN_0").add(0);
  door_locations.get("PX_UN_0").add(3);
  door_locations.get("PX_UN_0").add(6);
  door_locations.get("PX_UN_0").add(2);
  door_locations.get("PX_UN_0").add(6);
  door_locations.get("PX_UN_0").add(6);
  
  wall_locations.put("PX_UN_0", new ArrayList<Integer>());
  wall_locations.get("PX_UN_0").add(1);
  wall_locations.get("PX_UN_0").add(5);
  wall_locations.get("PX_UN_0").add(1);
  wall_locations.get("PX_UN_0").add(6);
  wall_locations.get("PX_UN_0").add(5);
  wall_locations.get("PX_UN_0").add(1);
  wall_locations.get("PX_UN_0").add(5);
  wall_locations.get("PX_UN_0").add(2);
  wall_locations.get("PX_UN_0").add(5);
  wall_locations.get("PX_UN_0").add(3);
  wall_locations.get("PX_UN_0").add(6);
  wall_locations.get("PX_UN_0").add(1);
  
  crumb_locations.put("PX_UN_0", new ArrayList<Integer>());
  crumb_locations.get("PX_UN_0").add(5);
  crumb_locations.get("PX_UN_0").add(4);
  
  door_locations.put("UN_DX_0", new ArrayList<Integer>());
  door_locations.get("UN_DX_0").add(0);
  door_locations.get("UN_DX_0").add(3);
  door_locations.get("UN_DX_0").add(3);
  door_locations.get("UN_DX_0").add(0);
  
  wall_locations.put("UN_DX_0", new ArrayList<Integer>());
  wall_locations.get("UN_DX_0").add(0);
  wall_locations.get("UN_DX_0").add(4);
  wall_locations.get("UN_DX_0").add(1);
  wall_locations.get("UN_DX_0").add(4);
  wall_locations.get("UN_DX_0").add(2);
  wall_locations.get("UN_DX_0").add(4);
  wall_locations.get("UN_DX_0").add(4);
  wall_locations.get("UN_DX_0").add(1);
  wall_locations.get("UN_DX_0").add(4);
  wall_locations.get("UN_DX_0").add(2);
  wall_locations.get("UN_DX_0").add(5);
  wall_locations.get("UN_DX_0").add(2);
  wall_locations.get("UN_DX_0").add(6);
  wall_locations.get("UN_DX_0").add(2);
  
  crumb_locations.put("UN_DX_0", new ArrayList<Integer>());
  crumb_locations.get("UN_DX_0").add(3);
  crumb_locations.get("UN_DX_0").add(4);
  
  door_locations.put("UN_NX_0", new ArrayList<Integer>());
  door_locations.get("UN_NX_0").add(0);
  door_locations.get("UN_NX_0").add(5);
  door_locations.get("UN_NX_0").add(5);
  door_locations.get("UN_NX_0").add(0);
  
  wall_locations.put("UN_NX_0", new ArrayList<Integer>());
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(4);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(4);
  wall_locations.get("UN_NX_0").add(4);
  wall_locations.get("UN_NX_0").add(2);
  wall_locations.get("UN_NX_0").add(4);
  wall_locations.get("UN_NX_0").add(3);
  wall_locations.get("UN_NX_0").add(4);
  wall_locations.get("UN_NX_0").add(4);
  
  crumb_locations.put("UN_NX_0", new ArrayList<Integer>());
  crumb_locations.get("UN_NX_0").add(5);
  crumb_locations.get("UN_NX_0").add(5);
  
  door_locations.put("UN_PX_0", new ArrayList<Integer>());
  door_locations.get("UN_PX_0").add(4);
  door_locations.get("UN_PX_0").add(6);
  door_locations.get("UN_PX_0").add(6);
  door_locations.get("UN_PX_0").add(4);

  wall_locations.put("UN_PX_0", new ArrayList<Integer>());
  wall_locations.get("UN_PX_0").add(2);
  wall_locations.get("UN_PX_0").add(2);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(0);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(1);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(2);
  wall_locations.get("UN_PX_0").add(5);
  wall_locations.get("UN_PX_0").add(2);
  wall_locations.get("UN_PX_0").add(6);
  wall_locations.get("UN_PX_0").add(2);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(4);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(5);
  wall_locations.get("UN_PX_0").add(3);
  wall_locations.get("UN_PX_0").add(6);
  
  crumb_locations.put("UN_PX_0", new ArrayList<Integer>());
  crumb_locations.get("UN_PX_0").add(1);
  crumb_locations.get("UN_PX_0").add(3);
  
  door_locations.put("UN_UN_0", new ArrayList<Integer>());
  door_locations.get("UN_UN_0").add(3);
  door_locations.get("UN_UN_0").add(6);
  door_locations.get("UN_UN_0").add(6);
  door_locations.get("UN_UN_0").add(3);
  
  wall_locations.put("UN_UN_0", new ArrayList<Integer>());
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(4);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(5);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(6);
  wall_locations.get("UN_UN_0").add(4);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(5);
  wall_locations.get("UN_UN_0").add(2);
  wall_locations.get("UN_UN_0").add(6);
  wall_locations.get("UN_UN_0").add(2);
  
  crumb_locations.put("UN_UN_0", new ArrayList<Integer>());
  crumb_locations.get("UN_UN_0").add(3);
  crumb_locations.get("UN_UN_0").add(3);
  
  drawImage();
}

void draw() {
}

void drawImage(){
  background(0);

  //Draw the image to the screen at coordinate (0,0)
  image(img, 0, 0);
}

//save coordinates from the keypresses 
void saveCoords(){
  TableRow newRow = table.addRow();
  newRow.setInt("participant", participant);
  newRow.setString("map", maps.get(current_map));
  String coords = "";
  for (ArrayList coord : coordinates) {
    coords += ((int)coord.get(0) + 2) + "," + ((int)coord.get(1) + 2) + ",";
  }
  newRow.setString("coords", coords.substring(0, coords.length()-1));
  saveTable(table, data_path + participant + ".csv");
}

void mousePressed(){
  //object parameters
  stroke(0);
  fill(175);
  rectMode(CENTER); //drawing in a small grey square to indicate grid-space clicked.
  
  
  if (finishedflag == 0){
  //logic for checking press and recording data
  for (int row = 0; row < 7; row++){
    if ((mouseX > (row * (345/7))) && (mouseX <= ((row + 1) * (345/7)))){
      for (int col = 0; col < 7; col++){
        if ((mouseY > (col * (350/7))) && (mouseY <= ((col + 1) * (350/7)))){       
          //If it's the first coordinate, is it at a starting/door coordinate? 
          if (coordinates.isEmpty()){
            //iterating to check if the first click is at a valid starting/door coordinate
            for (int i = 0; i < door_locations.get(maps.get(current_map)).size(); i+=2){
              if (row == door_locations.get(maps.get(current_map)).get(i) && col == door_locations.get(maps.get(current_map)).get(i+1)){
                //draw shape
                rect(((row * 345/7)+((row+1) * (345/7)))/2, ((col * 345/7)+((col+1) * (345/7)))/2, 20, 20);
                //store data
                coordinates.add(new ArrayList<Integer>());
                coordinates.get(coordinates.size()-1).add(row);
                coordinates.get(coordinates.size()-1).add(col);
              }
            }
          }
          
          //not first coordinate
          else{
            //Is it adjacent to previous click?
            if (
            (row == coordinates.get(coordinates.size()-1).get(0) + 1 && col == coordinates.get(coordinates.size()-1).get(1)) ||
            (row == coordinates.get(coordinates.size()-1).get(0) - 1 && col == coordinates.get(coordinates.size()-1).get(1)) ||
            (row == coordinates.get(coordinates.size()-1).get(0) && col == coordinates.get(coordinates.size()-1).get(1) + 1) ||
            (row == coordinates.get(coordinates.size()-1).get(0) && col == coordinates.get(coordinates.size()-1).get(1) - 1)){
              //Is it not a wall? 
              int flag = 0;
              for (int i = 0; i < wall_locations.get(maps.get(current_map)).size(); i+=2){
                if (wall_locations.get(maps.get(current_map)).get(0) == -1){
                  break;
                }
                else if (row == wall_locations.get(maps.get(current_map)).get(i) && col == wall_locations.get(maps.get(current_map)).get(i+1)){
                  //error
                  flag = 1;
                }
              }
              
              //is it a cookie crumb location?
              for (int i = 0; i < crumb_locations.get(maps.get(current_map)).size(); i+=2){
                if (row == crumb_locations.get(maps.get(current_map)).get(i) && col == crumb_locations.get(maps.get(current_map)).get(i+1)){
                  //it's the cookie crumb 
                  cookieflag = 1;
                }
              }
              
              
              if (flag == 0){
                //is it a finishing coordinate? If so, end array, save data, clear array
                if ((row == 0 && col == 0) || (row == 0 && col == 6) || (row == 6 && col == 0)){
                  //draw shape
                  rect(((row * 345/7)+((row+1) * (345/7)))/2, ((col * 345/7)+((col+1) * (345/7)))/2, 20, 20);
                  //store data
                  coordinates.add(new ArrayList<Integer>());
                  coordinates.get(coordinates.size()-1).add(row);
                  coordinates.get(coordinates.size()-1).add(col);
                  //check the coords to see if cookie crumb is one of them                  
                  //save data if cookie flag is true
                  if (cookieflag == 1){
                    finishedflag = 1;
                    saveCoords();
                  }
                  if (cookieflag == 0){
                    finishedflag = 1;
                    //error message
                    showMessageDialog(null, "Your path must include the cookie crumbs! Please try again.", "Warning", ERROR_MESSAGE);
                    //reset the coordinates array 
                    coordinates = new ArrayList<ArrayList<Integer>>();
                    //set cookieflag back
                    cookieflag = 0;
                    finishedflag = 0;
                    //reset image, clean slate.
                    drawImage();
                  }
                    
                    
                  //clear data
                  //coordinates = new ArrayList<ArrayList<Integer>>();
                  //popup message saying completed, press right arrow key
                }
                
                //else, add to the array and increment the array counter
                else{
                  //draw shape
                  rect(((row * 345/7)+((row+1) * (345/7)))/2, ((col * 345/7)+((col+1) * (345/7)))/2, 20, 20);
                  //store data
                  coordinates.add(new ArrayList<Integer>());
                  coordinates.get(coordinates.size()-1).add(row);
                  coordinates.get(coordinates.size()-1).add(col);
                }
              }
              
              else{
                //else wall condition
                //output error
              }
            }
            
            else{
              //not one block away
              //error
            }
          }
        }
      }
    }
  }
  }
}

void keyPressed(){
  //right arrow go to next slide 
  if (key == CODED){
    if (keyCode == RIGHT){
      if (
      coordinates.size() > 0 &&
      ((coordinates.get(coordinates.size()-1).get(0) == 0 && coordinates.get(coordinates.size()-1).get(1) == 0) ||
      (coordinates.get(coordinates.size()-1).get(0) == 0 && coordinates.get(coordinates.size()-1).get(1) == 6) ||
      (coordinates.get(coordinates.size()-1).get(0) == 6 && coordinates.get(coordinates.size()-1).get(1) == 0))
      ){
        if (cookieflag == 1){
          if (current_map < map_size-1){
            current_map++;
            //img = loadImage(maps.get(current_map));
            img = loadImage(stimuli_path.concat(maps.get(current_map).concat(".png")));
            drawImage();
            coordinates = new ArrayList<ArrayList<Integer>>();
            cookieflag = 0;
            finishedflag = 0;
          }
          else{
            print("Completed!");
          }
        }
      }
    }
  }
  
  // Want R button to be for reset not just any key 
  if (key == 'r'){
    //reset the coordinates array 
    coordinates = new ArrayList<ArrayList<Integer>>();
    //set cookieflag back
    cookieflag = 0;
    finishedflag = 0;
    //reset image, clean slate.
    drawImage();
  }
}  
  
//right click only if coordinates recorded at end point?
//test reset
