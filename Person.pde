class Person {
	String id;
	String name;
	String sex;
	String birth;
	String death;
	public HashMap<String,Family> families;
	float posX;
	float posY;
	float posZ;

	public Person(JSONObject personJson) {
		families = new HashMap<String,Family>();
		id = personJson.getString("id");
		
		JSONArray personProperties = personJson.getJSONArray("children"); // Array für Eigenschaften des Individuums erzeugen
		for(int i=0;i<personProperties.size();i++) {
			JSONObject property = personProperties.getJSONObject(i);
			
			//NAME
			if(property.getString("tag").equals("NAME")) {
				name = property.getString("value");
			}

			//SEX
			if(property.getString("tag").equals("SEX")) {
				sex = property.getString("value");
			}

			//BIRTH
			if(property.getString("tag").equals("BIRT")) {
				JSONArray birthDetailsArray = property.getJSONArray("children");
				for(int j = 0;j<birthDetailsArray.size();j++) {
					JSONObject birthDetailsObject = birthDetailsArray.getJSONObject(j);
					if(birthDetailsObject.getString("tag").equals("DATE")) {
						birth = birthDetailsObject.getString("value");
					}
				}
			}

			//DEATH
			if(property.getString("tag").equals("DEAT")) {
				JSONArray deathDetailsArray = property.getJSONArray("children");

				for(int j = 0;j<deathDetailsArray.size();j++) {
					JSONObject deathDetailsObject = deathDetailsArray.getJSONObject(j);
					if(deathDetailsObject.getString("tag").equals("DATE")) {
						death = deathDetailsObject.getString("value");
					}
				}
			}
		}
		//COORDINATES
		posX = 1;		
		posY = 1;		
		posZ = 1;		
	}

	public String getId() {
		return id;
	}

	public float getAge() {
		float age = 0;
		String birthYearString = birth.substring((birth.length()-4),birth.length());
		float birthYear = parseFloat(birthYearString);

		if(death != null && !death.isEmpty()) {
			String deathYearString = death.substring((death.length()-4),death.length());
			Float deathYear = parseFloat(deathYearString);
			age = deathYear-birthYear;
		} else {
			if(birthYear > 1900) {
				age = 2014-birthYear;
			}
		}
		return age;
	}

	public float getBirth() {
		return parseFloat(birth.substring((birth.length()-4),birth.length()));
	}

	public String getSex() {
		return sex;
	}

	public String getName() {
		return name;
	}

	//PosX
	public Float getPosX() {
		return posX;
	}
	void setPosX(Float posX) {
		this.posX = posX;
	}

	//posY
	public Float getPosY() {
		return posY;
	}
	void setPosY(Float posY) {
		this.posY = posY;
	}

	public Float getPosZ() {
		return posZ;
	}
	void setPosZ(Float posZ) {
		this.posZ = posZ;
	}
}