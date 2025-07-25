/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* Copyright 2013 - 2020, nymea GmbH
* Contact: contact@nymea.io
*
* This file is part of nymea.
* This project including source code and documentation is protected by
* copyright law, and remains the property of nymea GmbH. All rights, including
* reproduction, publication, editing and translation, are reserved. The use of
* this project is subject to the terms of a license agreement to be concluded
* with nymea GmbH in accordance with the terms of use of nymea GmbH, available
* under https://nymea.io/license
*
* GNU General Public License Usage
* Alternatively, this project may be redistributed and/or modified under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, GNU version 3. This project is distributed in the hope that it
* will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
* of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this project. If not, see <https://www.gnu.org/licenses/>.
*
* For any further details and any questions please contact us under
* contact@nymea.io or see our FAQ/Licensing Information on
* https://nymea.io/license/faq
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Nymea 1.0
import "../components"

Page {
    header: NymeaHeader {
        text: qsTr("Application logs")
        backButtonVisible: true
        onBackPressed: pageStack.pop()
        HeaderButton {
            imageSource: "qrc:/icons/state-out.svg"
            onClicked: {
                var exportedFile = AppLogController.exportLogs()
                PlatformHelper.shareFile(exportedFile)
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true

        ScrollBar.vertical: ScrollBar {}

        model: LogMessages {

        }

        delegate: Label {
            width: listView.width
            maximumLineCount: 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: model.text
            color: {
                switch (model.level) {
                case AppLogController.LogLevelCritical:
                    return Style.red;
                case AppLogController.LogLevelWarning:
                    return Style.orange;
                case AppLogController.LogLevelInfo:
                    return Style.foregroundColor;
                case AppLogController.LogLevelDebug:
                    return Qt.tint(Style.foregroundColor, Qt.rgba(Style.backgroundColor.r, Style.backgroundColor.g, Style.backgroundColor.b, .4))

                }
            }
            font: Style.smallFont
        }
    }
}
