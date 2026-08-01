/**
 *  Copyright (C) 2010-2024 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

extension LooksTableViewController {

    // The Catroweb media library API is discontinued (share.catrob.at shut down,
    // https://catrobat.org/share/). The media library now only exists as a plain
    // web page, not something the app can browse/download from natively. Open it
    // as a web screen instead of the old native picker.
    @objc
    func showBackgroundsMediaLibrary() {
        openMediaLibraryWebPage()
    }

    @objc
    func showLooksMediaLibrary() {
        openMediaLibraryWebPage()
    }

    private func openMediaLibraryWebPage() {
        let webVC = (self.storyboard?.instantiateViewController(withIdentifier: "HelpWebViewController") as? HelpWebViewController) ?? HelpWebViewController()
        webVC.url = URL(string: "https://share.catrobat.org/app/media-library/")
        webVC.pageTitle = kLocalizedMediaLibrary
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    private func showImportAlert(itemName: String) {
        let alertTitle = kLocalizedMediaLibraryImportFailedTitle
        let alertMessage = "\(kLocalizedMediaLibraryImportFailedMessage) \(itemName)"
        let buttonTitle = kLocalizedOK

        let alertController = UIAlertController.init(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(title: buttonTitle, style: .default, handler: nil)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LooksTableViewController: MediaLibraryViewControllerImportDelegate {
    func mediaLibraryViewController(_ mediaLibraryViewController: MediaLibraryViewController, didPickItemsForImport items: [MediaItem]) {
        for item in items {
            guard let itemName = item.name else { continue }
            guard let data = item.cachedData else { self.showImportAlert(itemName: itemName); continue }

            if let image = UIImage(data: data) {
                self.addMediaLibraryLoadedImage(image, withName: item.name)
                continue
            }
        }
    }
}
