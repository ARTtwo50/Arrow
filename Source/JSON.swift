//
//  JSON.swift
//  ArrowExample
//
//  Created by Sacha Durand Saint Omer on 14/04/16.
//  Copyright © 2016 Sacha Durand Saint Omer. All rights reserved.
//

public
final
class JSON: AnyObject, CustomDebugStringConvertible
{
    //=== Public properties
    
    public
    var jsonDateFormat: String?
    
    //=== Public read-ONLY properties
    
    private(set)
    public
    var data: AnyObject?
    
    //=== Initialization
    
    public
    init?(_ deserializedData: AnyObject?)
    {
        if deserializedData == nil
        {
            return nil
        }
        else
        {
            data = deserializedData
        }
    }
    
    //=== Access data
    
    public
    subscript(key: String) -> JSON?
    {
        get
        {
            let keys =  key.characters.split{$0 == "."}
            
            if keys.count > 1 // KeyPath parsing
            {
                let keysArray:[String] =  keys.map(String.init)
                
                if var intermediateValue = JSON(data)
                {
                    for k in keysArray
                    {
                        if let ik = Int(k) // Array index
                        {
                            if
                                let value = intermediateValue[ik]
                            {
                                intermediateValue = value
                            }
                            else
                            {
                                return nil
                            }
                        }
                        else // Key
                        {
                            if
                                let value = intermediateValue[k]
                            {
                                intermediateValue = value
                            }
                            else
                            {
                                return nil
                            }
                        }
                    }
                    
                    //===
                    
                    return intermediateValue
                }
            }
            else // Regular parsing
            {
                if
                    let d = data,
                    x = d[key],
                    subJSON = JSON(x)
                {
                    return subJSON
                }
            }
            
            //===
            
            return nil
        }
        
        set(newValue)
        {
            if
                var d = data as? [String:AnyObject]
            {
                d[key] = newValue
            }
        }
    }
    
    public
    subscript(index: Int) -> JSON?
    {
        get
        {
            if
                let array = data as? [AnyObject] where array.count > index
            {
                return JSON(array[index])
            }
            else
            {
                return nil
            }
        }
        
        // TODO: add "set" method implementation?
    }
}

//=== MARK: - Helpers

extension JSON
{
    public
    var collection: [JSON]?
    {
        if
            let a = data as? [AnyObject]
        {
            return a.map{ JSON($0)! }
        }
        else
        {
            return nil
        }
    }
    
    public
    var debugDescription: String
    {
        return data!.debugDescription
    }
    
    public
    func dateFormat(format: String) -> Self
    {
        jsonDateFormat = format
        
        //===
        
        return self
    }
}
