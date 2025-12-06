import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    private var images = [UIImageView]()
    private var didLayout = false

    // Amount of the next/previous page to show on each side
    private let peekAmount: CGFloat = 40

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false  // IMPORTANT: allow peeking

        // Create the image views only once
        for x in 0...2 {
            let imageView = UIImageView(image: UIImage(named: "icon\(x).png"))
            imageView.contentMode = .scaleAspectFit
            images.append(imageView)
            scrollView.addSubview(imageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !didLayout else { return }
        didLayout = true

        let scrollWidth = scrollView.frame.width
        let scrollHeight = scrollView.frame.height

        // Make each page smaller than the scroll view width
        let pageWidth = scrollWidth - (peekAmount * 2)
        let pageHeight = scrollHeight

        for (index, imgView) in images.enumerated() {
            let xPos = CGFloat(index) * pageWidth + peekAmount * CGFloat(index + 1)

            imgView.frame = CGRect(
                x: xPos + (pageWidth - 150) / 2,
                y: (pageHeight - 150) / 2,
                width: 150,
                height: 150
            )
        }

        // Correct content size
        scrollView.contentSize = CGSize(
            width: CGFloat(images.count) * (pageWidth + peekAmount),
            height: pageHeight
        )
    }

    // Optional: snapping effect to nearest page
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pageWidth = scrollView.frame.width - (peekAmount * 2)
        let rawPage = targetContentOffset.pointee.x / (pageWidth + peekAmount)
        let page = round(rawPage)
        let newOffset = page * (pageWidth + peekAmount)
        targetContentOffset.pointee.x = newOffset
    }
}
