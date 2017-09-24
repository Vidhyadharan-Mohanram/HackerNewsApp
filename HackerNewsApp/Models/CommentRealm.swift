//
//	CommentRealm.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Realm
import RealmSwift

class CommentRealm: Object {

	@objc dynamic var by: String!
	@objc dynamic var id: Int = 0
	@objc dynamic var parent: Int = 0
	@objc dynamic var text: String!
	@objc dynamic var time: Int = 0
	@objc dynamic var type: String!


    override static func primaryKey() -> String? {
        return "id"
    }

    func cascadeDelete(realm: Realm) {
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any], realm: Realm) -> CommentRealm	{
		let this = CommentRealm()
        this.update(fromDictionary: dictionary, realm: realm)
		return this
	}

    func update(fromDictionary dictionary: [String: Any], realm: Realm) {
        if let byValue = dictionary["by"] as? String{
            by = byValue
        }
        if let idValue = dictionary["id"] as? Int, id == 0 {
            id = idValue
        }
        if let parentValue = dictionary["parent"] as? Int{
            parent = parentValue
        }
        if let textValue = dictionary["text"] as? String{
            text = textValue
        }
        if let timeValue = dictionary["time"] as? Int{
            time = timeValue
        }
        if let typeValue = dictionary["type"] as? String{
            type = typeValue
        }
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

}
