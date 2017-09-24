//
//	CommentStruct.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CommentStruct{

	var by : String!
	var id : Int!
	var kids : [Int]!
	var parent : Int!
	var text : String!
	var time : Int!
	var type : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init?(fromDictionary dictionary: [String:Any]){
		by = dictionary["by"] as? String
		id = dictionary["id"] as? Int
		kids = dictionary["kids"] as? [Int]
		parent = dictionary["parent"] as? Int
		text = dictionary["text"] as? String
		time = dictionary["time"] as? Int
		type = dictionary["type"] as? String

        if by == nil || text == nil || id == nil || time == nil || parent == nil {
            return nil
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
		if id != nil{
			dictionary["id"] = id
		}
		if kids != nil{
			dictionary["kids"] = kids
		}
		if parent != nil{
			dictionary["parent"] = parent
		}
		if text != nil{
			dictionary["text"] = text
		}
		if time != nil{
			dictionary["time"] = time
		}
		if type != nil{
			dictionary["type"] = type
		}
		return dictionary
	}

}
