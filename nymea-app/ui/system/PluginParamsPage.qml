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

import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import "../components"
import "../delegates"
import Nymea 1.0

SettingsPageBase {
    id: root
    property var plugin: null

    header: NymeaHeader {
        text: plugin.name
        backButtonVisible: true
        onBackPressed: pageStack.pop()

        HeaderButton {
            imageSource: "qrc:/icons/tick.svg"
            onClicked: {
                pluginConfigManager.savePluginConfig()
            }
        }
    }

    Connections {
        target: engine.thingManager
        onSavePluginConfigReply: {
            if (thingError === Thing.ThingErrorNoError) {
                pageStack.pop();
            } else {
                console.warn("Error saving plugin params:", thingError)
                var dialog = errorDialog.createObject(root, {error: thingError});
                dialog.open();
            }
        }
    }

    PluginConfigManager {
        id: pluginConfigManager
        engine: _engine
        plugin: root.plugin
    }

    SettingsPageSectionHeader {
        text: qsTr("Settings")
    }

    Repeater {
        model: pluginConfigManager.params

        delegate: ParamDelegate {
            Layout.fillWidth: true
            paramType: root.plugin.paramTypes.getParamType(model.id)
            param: pluginConfigManager.params.getParam(model.id)
        }
    }

    Component {
        id: errorDialog
        ErrorDialog { }
    }
}
