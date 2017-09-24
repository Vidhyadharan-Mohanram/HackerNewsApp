//
//	CommentRealm.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import RealmSwift

class CommentRealm: Object, NSCoding {

	@objc dynamic var by: String!
	@objc dynamic var id: Int
    @objc dynamic var kids: List<CommentRealm>!
	@objc dynamic var parent: Int
	@objc dynamic var text: String!
	@objc dynamic var time: Int
	@objc dynamic var type: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> CommentRealm	{
		let this = CommentRealm()
		if let byValue = dictionary["by"] as? String{
			this.by = byValue
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
		if let parentValue = dictionary["parent"] as? Int{
			this.parent = parentValue
		}
		if let textValue = dictionary["text"] as? String{
			this.text = textValue
		}
		if let timeValue = dictionary["time"] as? Int{
			this.time = timeValue
		}
		if let typeValue = dictionary["type"] as? String{
			this.type = typeValue
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
		dictionary["parent"] = parent
		if text != nil{
			dictionary["text"] = text
		}
		dictionary["time"] = time
		if type != nil{
			dictionary["type"] = type
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
         id = aDecoder.decodeObject(forKey: "id") as? Int
         kids = aDecoder.decodeObject(forKey: "kids") as? List
         parent = aDecoder.decodeObject(forKey: "parent") as? Int
         text = aDecoder.decodeObject(forKey: "text") as? String
         time = aDecoder.decodeObject(forKey: "time") as? Int
         type = aDecoder.decodeObject(forKey: "type") as? String

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
         id = aDecoder.decodeObject(forKey: "id") as? Int
		if kids != nil{
			aCoder.encode(kids, forKey: "kids")
		}
         parent = aDecoder.decodeObject(forKey: "parent") as? Int
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}
         time = aDecoder.decodeObject(forKey: "time") as? Int
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}
