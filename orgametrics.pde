import controlP5.*;
import themidibus.*;
import java.util.*;
import java.text.*;

ControlP5 cp5;
JSONArray json;
MidiBus myBus;
Family familyRoot;

int[] midi = {5,50,10,10,10,10,10,10};
HashMap<String,Person> persons = new HashMap();
HashMap<String,Family> families = new HashMap();

void setup() {
  size(800, 800, P3D);
  myBus = new MidiBus(this, 0, 0);
  json = loadJSONArray("sample.json");
  for(int i = 0;i<json.size();i++){
    JSONObject dataJson = json.getJSONObject(i); //Alle Objekte aus dem Array ziehen
    
    if (dataJson.getString("tag").equals("INDI")) { 
      Person person = new Person(dataJson);
      persons.put(person.getId(),person);
    }
  }

  for(int i = 0;i<json.size();i++){
    JSONObject dataJson = json.getJSONObject(i); 
    if(dataJson.getString("tag").equals("FAM")) {
      Family family = new Family();
      family.parse(dataJson,persons);
      families.put(family.getId(),family);
    }
  }

  List<Family> familiesList = new ArrayList(families.values());
  Collections.sort(familiesList,new Comparator<Family>() {
    public int compare(Family familyOne, Family familyTwo) {
      return (int)familyOne.husband.getBirth() - (int)familyTwo.husband.getBirth();
    }
  });

  familyRoot = familiesList.get(0);
}

void draw() {
  background(51,77,92);
  lights();
  noStroke();
  // noLoop();
  hint(ENABLE_DEPTH_TEST);

  //MAUS-ROTATION
  translate(width/2, height/2, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  //  rotateZ(frameCount*PI/1000);
  rotateX(mouseY*1.0f/height*TWO_PI);


  traverseFamily(familyRoot,0);

  /*Set<String> personIds = persons.keySet();
  Float count = 0.0;
  for(String personId: personIds) {
    Person person = persons.get(personId);

    //PosX
    Float posX = person.getAge() * midi[0];
    person.setPosX(posX);

    //PosY
    Float posY;
    if(person.getSex().equals("M")) {
      posY = -1.0 * midi[1]*count;
    } else {
      posY = 1.0 * midi[1]*count;
    }
    person.setPosY(posY);

    //PosZ
    Float posZ = person.getBirth()-1800*midi[2]/100;
    person.setPosZ(posZ);

    //Draw Spheres
    fill(255);
    pushMatrix();
      translate(person.getPosX(), person.getPosY(), person.getPosZ());
      sphere(midi[3]);
     popMatrix();

     count++;
  }*/

  /*Set<String> familyIds = families.keySet();
  for(String familyId: familyIds) {
    Family family = families.get(familyId);
    stroke(255);
    noFill();
    beginShape();
    vertex(family.husband.getPosX(),family.husband.getPosY(),family.husband.getPosZ());
    vertex(family.wife.getPosX(),family.wife.getPosY(),family.wife.getPosZ());
    Set<String> childrenIds = family.children.keySet();
    for(String childId: childrenIds) {
      Person child = family.children.get(childId);
      vertex(child.getPosX(),child.getPosY(),child.getPosZ());
    }
    endShape();
  }*/
     
  stroke(255,0,0);
  beginShape(LINES);
    vertex(-1000,0,0);
    vertex(1000, 0, 0);
  endShape();
  text("X", 50, 0, 0);

  stroke(0,255,0);
  beginShape(LINES);
    vertex(0,-1000,0);
    vertex(0, 1000, 0);
  endShape();
  text("Y", 0, 50, 0);

  stroke(0,0,255);
  beginShape(LINES);
    vertex(0,0,-1000);
    vertex(0, 0, 1000);
  endShape();
  text("Z", 0, 0, 50);
  
    
  hint(ENABLE_DEPTH_TEST);
}

void controllerChange(ControlChange change) {
  midi[change.number()] = change.value;
  // println(midi);
}

public void traverseFamily(Family family,int generation) {
  //ALLE MEMBER DER FAMILY GETTEN
  Set<String> familyMembersIds = family.getFamilyMembers().keySet();
  for (String familyMemberId: familyMembersIds) {
    Person person = family.getFamilyMembers().get(familyMemberId);
    drawPerson(person,generation);
  }
  
  //REKURSION
  generation++;
  for(Person child:family.children.values()) {
    if(child.families.values().iterator().hasNext()) {
      traverseFamily(child.families.values().iterator().next(),generation);
    }
  }
}

public void drawPerson(Person person,int generation) {
  //PosX
  Float posX = ((float)generation * midi[0]*10) + (person.getBirth()-1800);
  person.setPosX(posX);

  //PosY
  Float posY;
  if(person.getSex().equals("M")) {
    posY = -1.0 * midi[1];
  } else {
    posY = 1.0 * midi[1];
  }
  person.setPosY(posY);

    //PosZ
    Float posZ = 0.0;
    person.setPosZ(posZ);

    //Draw Spheres
    fill(255);
    pushMatrix();
      translate(person.getPosX(), person.getPosY(), person.getPosZ());
      sphere((person.getAge()+10)*midi[3]/100);
     popMatrix();

   /*  pushMatrix();
       translate(person.getPosX(), person.getPosY(), person.getPosZ());
       rotateY(mouseX*1.0f/width*TWO_PI);
       rotateZ(0);
      rotateX(mouseY*1.0f/height*TWO_PI);
       text(person.getName(), -20, 0, 20);
     popMatrix();*/
}
