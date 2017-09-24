//
//	StoryRealm.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import RealmSwift

class StoryRealm: Object, NSCoding {

	@objc dynamic var by: String!
	@objc dynamic var descendants: Int
	@objc dynamic var id: Int
    @objc dynamic var kids: List<CommentRealm>!
	@objc dynamic var score: Int
	@objc dynamic var time: Int
	@objc dynamic var title: String!
	@objc dynamic var type: String!
	@objc dynamic var url: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> StoryRealm	{
		let this = StoryRealm()
		if let byValue = dictionary["by"] as? String{
			this.by = byValue
		}
		if let descendantsValue = dictionary["descendants"] as? Int{
			this.descendants = descendantsValue
		}
		if let idValue = dictionary["id"] as? Int{
			this.id = idValue
		}
		if let kidsArray = dictionary["kids"] as? [[String:Any]]{
			var kidsItems = List<CommentRealm>()
			for dic in kidsArray{
				let value = Int.fromDictionary(dic)
				kidsItems.addObject(value)
			}
			kids = kidsItems
		}
		if let scoreValue = dictionary["score"] as? Int{
			this.score = scoreValue
		}
		if let timeValue = dictionary["time"] as? Int{
			this.time = timeValue
		}
		if let titleValue = dictionary["title"] as? String{
			this.title = titleValue
		}
		if let typeValue = dictionary["type"] as? String{
			this.type = typeValue
		}
		if let urlValue = dictionary["url"] as? String{
			this.url = urlValue
		}
		return this
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if by != nil{
			dictionary["by"] = by
		}
		dictionary["descendants"] = descendants
		dictionary["id"] = id
		if kids != nil{
			var dictionaryElements = [[String:Any]]()
			for i in 0 ..< kids.count {
				if let kidsElement = kids[i] as? Int{
					dictionaryElements.append(kidsElement.toDictionary())
				}
			}
			dictionary["kids"] = dictionaryElements
		}
		dictionary["score"] = score
		dictionary["time"] = time
		if title != nil{
			dictionary["title"] = title
		}
		if type != nil{
			dictionary["type"] = type
		}
		if url != nil{
			dictionary["url"] = url
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         by = aDecoder.decodeObject(forKey: "by") as? String
         descendants = aDecoder.decodeObject(forKey: "descendants") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         kids = aDecoder.decodeObject(forKey: "kids") as? List
         score = aDecoder.decodeObject(forKey: "score") as? Int
         time = aDecoder.decodeObject(forKey: "time") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if by != nil{
			aCoder.encode(by, forKey: "by")
		}
         descendants = aDecoder.decodeObject(forKey: "descendants") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
		if kids != nil{
			aCoder.encode(kids, forKey: "kids")
		}
         score = aDecoder.decodeObject(forKey: "score") as? Int
         time = aDecoder.decodeObject(forKey: "time") as? Int
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}

	}

}
