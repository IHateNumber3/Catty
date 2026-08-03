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

import MobileCoreServices
import UniformTypeIdentifiers

extension MyProjectsViewController {

    // Explicit "Import" entry point, doing the same thing as the "Open with Pocket Code"
    // file-open flow (AppDelegate.application(_:open:options:)), just triggerable directly
    // from inside the app instead of only from Files/another app's share sheet.
    @objc
    func importProjectAction() {
        var documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            let catrobatType = UTType(filenameExtension: "catrobat") ?? UTType.zip
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [catrobatType, UTType.zip], asCopy: true)
        } else {
            documentPicker = UIDocumentPickerViewController(documentTypes: ["public.zip-archive", "public.data"], in: .import)
        }

        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true)
    }
}

extension MyProjectsViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)

        guard let url = urls.first else { return }

        guard let project = ProjectManager.shared.addProjectFromFile(url: url) else {
            Util.alert(text: kLocalizedUnableToLoadProject)
            return
        }

        self.tableView.reloadData()
        self.openProject(project)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
