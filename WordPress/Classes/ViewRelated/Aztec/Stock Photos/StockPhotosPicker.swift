import WPMediaPicker

protocol StockPhotosPickerDelegate: AnyObject {
    func stockPhotosPicker(_ picker: StockPhotosPicker, didFinishPicking assets: [StockPhotosMedia])
}

/// Presents the Stock Photos main interface
final class StockPhotosPicker: NSObject {
    private let dataSource = StockPhotosDataSource(service: StockPhotosServiceMock())
    weak var delegate: StockPhotosPickerDelegate?

    func presentPicker(origin: UIViewController, blog: Blog) {
        let options = WPMediaPickerOptions()
        options.showMostRecentFirst = true
        options.filter = [.all]
        options.allowCaptureOfMedia = false
        options.showSearchBar = true

        let picker = WPNavigationMediaPickerViewController(options: options)
        picker.delegate = self
        picker.startOnGroupSelector = false
        picker.showGroupSelector = false
        picker.dataSource = dataSource

        origin.present(picker, animated: true)
    }
}

extension StockPhotosPicker: WPMediaPickerViewControllerDelegate {
    func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
        guard let stockPhotosMedia = assets as? [StockPhotosMedia] else {
            assertionFailure("assets should be of type `[StockPhotosMedia]`")
            return
        }
        delegate?.stockPhotosPicker(self, didFinishPicking: stockPhotosMedia)
        picker.dismiss(animated: true, completion: nil)
    }

    func emptyView(forMediaPickerController picker: WPMediaPickerViewController) -> UIView? {
        let searchHint = StockPhotosPlaceholder()

        return searchHint
    }

    func mediaPickerControllerDidCancel(_ picker: WPMediaPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
