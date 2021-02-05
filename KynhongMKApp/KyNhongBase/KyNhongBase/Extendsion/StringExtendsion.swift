//
//  StringExtendsion.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/10/20.
//

import Foundation

import UIKit

enum AmountActionType: String {
    case asc = "+"
    case des = "-"
}

extension String {
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func subString(from: Int, to: Int) -> String {
        var temp = ""
        let characters = self.map { "\($0)" }
        if from >= 0 && from < characters.count && to >= 0 && to <= characters.count {
            for i in from..<to {
                temp.append(characters[i])
            }
        } else {
            temp = self
        }
        return temp
    }
    
    var amount: Int {
        let value = self.replacingOccurrences(of: ".", with: "")
        return Int(value) ?? 0
    }
    
    func date(with format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func attributed(with attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
        
    func toASCIIString() -> String {
        var str = self.replacingOccurrences(of: "đ", with: "d")
        str = str.replacingOccurrences(of: "Đ", with: "D")
        str = str.replacingOccurrences(of: "Œ", with: "OE")
        str = str.replacingOccurrences(of: "œ", with: "oe")
        let str2Data = str.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        return String(bytes: str2Data!, encoding: String.Encoding.ascii)!
    }
    
    func toImage() -> UIImage? {
        if let url = URL(string: self) {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
    
    func isOnlyDecimal() -> Bool {
        return CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func subString(from index: Int, to character: Character) -> String {
        var temp = ""
        let characters = self.map { $0 }
        if index < characters.count {
            for i in index..<characters.count {
                let c = characters[i]
                if c == character {
                    break
                }
                temp.append(c)
            }
        }
        return temp
    }
    
    func subString(from character: Character, to index: Int) -> String {
        var temp = ""
        let characters = self.map { $0 }
        let endIndex = min(index, characters.count)
        var charIndex: Int = -1
        for i in 0..<characters.count {
            let c = characters[i]
            if c == character {
                charIndex = i
                break
            }
        }
        if charIndex >= 0 && charIndex < endIndex {
            for i in (charIndex + 1)..<endIndex {
                let c = characters[i]
                temp.append(c)
            }
        }

        return temp
    }
}
