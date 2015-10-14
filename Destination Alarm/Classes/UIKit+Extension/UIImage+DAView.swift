/// MARK: - UIImage+DAView
extension UIImage {

    /// MARK: - class method

    /**
     * create UIImage from UIView
     * @param view UIView
     * @return UIImage
     **/
    class func imageFromView(view: UIView) -> UIImage {
        let scale = UIScreen.mainScreen().scale

        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, scale)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return image
    }

}
