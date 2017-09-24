//
//	StoryRealm.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Realm
import RealmSwift

class StoryRealm: Object {

	@objc dynamic var by: String!
	@objc dynamic var descendants: Int = 0
	@objc dynamic var id: Int = 0
    var kids = List<CommentRealm>()
	@objc dynamic var score: Int = 0
	@objc dynamic var time: Int = 0
	@objc dynamic var title: String!
	@objc dynamic var type: String!
	@objc dynamic var url: String!


    override static func primaryKey() -> String? {
        return "id"
    }

    func cascadeDelete(realm: Realm) {
        for comment in kids {
            comment.cascadeDelete(realm: realm)
        }
        realm.delete(kids)
    }

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    class func fromDictionary(dictionary: [String:Any], realm: Realm) -> StoryRealm {
        let this = StoryRealm()
        this.update(fromDictionary: dictionary, realm: realm)
        return this
    }

    func update(fromDictionary dictionary: [String: Any], realm: Realm) {

        if kids.count > 0 {
            cascadeDelete(realm: realm)
        }

        if let byValue = dictionary["by"] as? String{
            by = byValue
        }
        if let descendantsValue = dictionary["descendants"] as? Int{
            descendants = descendantsValue
        }
        if let idValue = dictionary["id"] as? Int, id == 0 {
            id = idValue
        }
        if let kidsArray = dictionary["kids"] as? [Int]{
            for idVal in kidsArray {
                let comment = CommentRealm.fromDictionary(dictionary: ["id" : idVal], realm: realm)
                kids.append(comment)
            }
        }
        if let scoreValue = dictionary["score"] as? Int{
            score = scoreValue
        }
        if let timeValue = dictionary["time"] as? Int{
            time = timeValue
        }
        if let titleValue = dictionary["title"] as? String{
            title = titleValue
        }
        if let typeValue = dictionary["type"] as? String{
            type = typeValue
        }
        if let urlValue = dictionary["url"] as? String{
            url = urlValue
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
		dictionary["descendants"] = descendants
		dictionary["id"] = id
		if kids.count > 0 {
			var arrayElements = [Int]()
			for i in 0 ..< kids.count {
                let kidsElement = kids[i]
                arrayElements.append(kidsElement.id)
			}
			dictionary["kids"] = arrayElements
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
}
