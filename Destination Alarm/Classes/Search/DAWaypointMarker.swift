/// MARK: - DAWaypointMarker
class DAWaypointMarker: GMSMarker {

    /// MARK: - initialization

    convenience init(position: CLLocationCoordinate2D) {
        self.init()

        // icon
        let view = UIView(frame: CGRectMake(0, 0, 20.0, 20.0))
        let image = IonIcons.imageWithIcon(
            ion_pinpoint,
            size: 20.0,
            color: UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        )
        let imageViews = [ UIImageView(image: image), UIImageView(image: image), UIImageView(image: image), UIImageView(image: image), UIImageView(image: image), ]
        for var i = 0; i < imageViews.count; i++ {
            let imageView = imageViews[i]
            view.addSubview(imageView)
            imageView.center = CGPointMake(view.center.x - 1.0 + CGFloat(i/2), view.center.y - 1.0 + CGFloat(i%2))
        }
        self.icon = UIImage.imageFromView(view)

        // settings
        self.position = position
        self.groundAnchor = CGPointMake(0.5, 0.5)
        self.rotation = 90.0
        self.draggable = true
    }


}

