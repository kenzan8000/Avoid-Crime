import Foundation


/// MARK: - LOG

/**
 * display log
 * @param body log
 */
func DALOG(str: String) {
#if DEBUG
    println("////////// DA log\n" + str + "\n\n")
#endif
}

/**
 * return class name
 * @param classType classType
 * @return class name
 */
func DANSStringFromClass(classType:AnyClass) -> String {
    let classString = NSStringFromClass(classType.self)
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
}


/// MARK: - API
