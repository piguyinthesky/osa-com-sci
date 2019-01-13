// Stores all the images and Assets, etc. loaded from the data folder
public class Assets {

  // When adding a new obstacle, here is a list of things to do:
  // Add the name of its image file to the array of the lane's obstacles below
  // Check its interactions 
  public PFont arcadeFont;
  public final String[] laneTypes = { "safety", "road", "river", "destination" };
  public final String[] safetyObstacles = { "snake" };
  public final String[] roadObstacles = { "car", "truck", "racecar1", "racecar2", "racecar3" };
  public final String[] riverObstacles = { "log", "longlog", "turtle", "alligator" };
  public final String[] destinationObstacles = { "home", "homealligator", "reached", "ladybug" };

  public final String[] animatedSprites = { "snake", "turtle", "reached", "frog", "death" }; // This array tells us which images have an animation

  private HashMap<String, String[]> laneToObstacles = new HashMap<String, String[]>();
  private HashMap<String, Integer> laneColors = new HashMap<String, Integer>();

  private String[] spritesList;
  private HashMap<String, PImage> sprites = new HashMap<String, PImage>();
  private HashMap<String, PImage[]> spritesheets = new HashMap<String, PImage[]>();

  // ===== LOADING OUTSIDE RESOURCES =====
  
  // In the constructor, we load up all the variables above with images from the data folder
  public Assets() {
    arcadeFont = createFont("arcade.ttf", height / 8); // We load in the arcade font, in the data folder

    laneToObstacles.put("safety", safetyObstacles);
    laneToObstacles.put("road", roadObstacles);
    laneToObstacles.put("river", riverObstacles);
    laneToObstacles.put("destination", destinationObstacles);

    // Set the colors for the different lanes
    laneColors.put("safety", color(64, 255, 32));
    laneColors.put("road", color(0));
    laneColors.put("river", color(0, 0, 255));
    laneColors.put("destination", color(0, 255, 0));

    // We populate the spritesList array
    int numSprites = 0;
    for (String[] list : laneToObstacles.values())
      numSprites += list.length; // We tally up the number of sprites
    spritesList = new String[numSprites + 2]; // Plus the sprites that aren't obstacles: frog and death

    int counter = 0;
    for (String[] list : laneToObstacles.values()) { // The array isn't guaranteed to be ordered, but they don't need to be since we're loading them into another HashMap
      for (String obstacleName : list) {
        spritesList[counter] = obstacleName;
        counter++;
      }
    }
    spritesList[counter] = "frog";
    spritesList[counter + 1] = "death";

    // We loop through all the files in the sprites folder
    for (String name : spritesList)
      if (!isSpritesheet(name)) // As long as it doesn't require a spritesheet
        sprites.put(name, loadImage("sprites/" + name + ".png")); // We load it into sprites
    
    // We load the spritesheets
    spritesheets.put("snake", loadSpritesheet("snake", 30, 11));
    spritesheets.put("turtle", loadSpritesheet("turtle", 15, 11));
    spritesheets.put("reached", loadSpritesheet("reached", 16, 16));
    spritesheets.put("frog", loadSpritesheet("frog", 12, 14));
    spritesheets.put("death", loadSpritesheet("death", 16, 16));
  }

  private Lane[] loadLanes(String path) {
    Table data = loadTable(path, "header"); // We load the data from the table
    if (data == null) return new Lane[0];

    Lane[] lanes = new Lane[data.getRowCount()]; // We initialize an array of lanes. Each row in the table corresponds to a lane
    
    for (int i = 0; i < data.getRowCount(); i++) // For each of the rows
      // We add the lane specified by the data to the lanes array
      lanes[i] = new Lane(i, data.getRow(i));
      
    return lanes;
  }

  private PImage[] loadSpritesheet(String path, int w, int h) {
    PImage img = loadImage("spritesheets/" + path + ".png");
    int numFrames = img.width / w;
    PImage[] ret = new PImage[numFrames]; // Initialize the array to be returned as the result
    for (int i = 0; i < numFrames; i++) // For each of the frames,
      ret[i] = img.get(i * w, 0, w, h); // we crop the corresponding w * h image from the spritesheet
    return ret;
  }

  public String[] listLevelNames() { // Lists the levels located under data/levels
    String[] files = new File(sketchPath() + "/data/levels").list(); // by listing the files in the directory,
    ArrayList<String> ret = new ArrayList<String>(files.length); // (arraylist for dynamic size)

    for (String file : files) {
      String[] nameAndExt = split(file, "."); // (We get the name and extension by separating the file by the dot)
      if (nameAndExt[1].equals("csv")) ret.add(nameAndExt[0]); // and checking if it is a csv file
    }

    return ret.toArray(new String[ret.size()]); // return the file names
  }
  
  // ===== UTILITY FUNCTIONS ===== 

  public void defaultFont(float size) {
    textFont(arcadeFont, size);
    textAlign(CENTER, CENTER);
    fill(255);
  }

  public void drawCenteredText(String text) { // For titles and things
    new TextBox(0, 0, width, height, text).show(); // We simply use the text font-checking already implemented in TextBox
  }

  // gets the index of a string in an array of them
  public int indexOf(String search, String[] arr) {
    for (int i = 0; i < arr.length; i++)
      if (arr[i].equals(search))
        return i;
    return -1;
  }

  // ===== GETTERS =====
  
  // Sees if a particular obstacle type has an associated animation
  public boolean isSpritesheet(String name) {
    return indexOf(name, animatedSprites) > -1;
  }
  public String[] getObstaclesOfLane(String laneType) {
    return laneToObstacles.get(laneType);
  }
  public int getNumLanes() { return laneColors.size(); }
  public color getLaneColor(String laneType) { return laneColors.get(laneType); }
  public PImage getSprite(String name) { return sprites.get(name); }
  public PImage[] getSpritesheet(String name) { return spritesheets.get(name); }

}
