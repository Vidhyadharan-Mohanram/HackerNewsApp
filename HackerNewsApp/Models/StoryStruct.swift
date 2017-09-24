//
//	StoryStruct.swift
//
//	Create by Vidhyadharan Mohanram on 24/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct StoryStruct{

	var by : String!
	var descendants : Int!
	var id : Int!
	var kids : [Int]!
	var score : Int!
	var time : Int!
	var title : String!
	var type : String!
	var url : String?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		by = dictionary["by"] as? String
		descendants = dictionary["descendants"] as? Int
		id = dictionary["id"] as? Int
		kids = dictionary["kids"] as? [Int]
		score = dictionary["score"] as? Int
		time = dictionary["time"] as? Int
		title = dictionary["title"] as? String
		type = dictionary["type"] as? String
		url = dictionary["url"] as? String
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
		if descendants != nil{
			dictionary["descendants"] = descendants
		}
		if id != nil{
			dictionary["id"] = id
		}
		if kids != nil{
			dictionary["kids"] = kids
		}
		if score != nil{
			dictionary["score"] = score
		}
		if time != nil{
			dictionary["time"] = time
		}
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
