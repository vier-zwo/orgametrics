class Family {
	String id;
	Person husband;
	Person wife;
	HashMap<String,Person> children;

	public Family() {
		children = new HashMap();
	}

	public String getId() {
		return id;
	}

	public HashMap<String,Person> getFamilyMembers() {
		HashMap<String,Person> familyMembers = new HashMap();
		familyMembers.put(husband.getId(),husband);
		familyMembers.put(wife.getId(),wife);
		
		Set<String> childrenIds = children.keySet();
		for(String childId: childrenIds) {
			Person child = children.get(childId);
			familyMembers.put(child.getId(),child);
		}

		return familyMembers;
	}

	public void parse(JSONObject familyJson, HashMap<String,Person> persons) {
		id = familyJson.getString("id");

		JSONArray familyProperties = familyJson.getJSONArray("children");
		for (int i = 0;i<familyProperties.size();i++) {
			JSONObject familyProperty = familyProperties.getJSONObject(i);

			//HUSBAND
			if(familyProperty.getString("tag").equals("HUSB")) {
				String husbandId = familyProperty.getString("ref");
				husband = persons.get(husbandId);
				husband.families.put(id,this);
			}

			//WIFE
			if(familyProperty.getString("tag").equals("WIFE")) {
				String wifeId = familyProperty.getString("ref");
				wife = persons.get(wifeId);
				wife.families.put(id,this);
			}

			//WIFE
			if(familyProperty.getString("tag").equals("CHIL")) {
				String childId = familyProperty.getString("ref");
				children.put(childId,persons.get(childId));
			}
		}
	}
}