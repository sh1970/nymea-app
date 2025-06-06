/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* Copyright 2013 - 2022, nymea GmbH
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
import QtQuick.Layouts 1.2
import "../components"
import "../delegates"
import Nymea 1.0

Page {
    id: root
    // Needs to be set and filled in with thingId and eventTypeId
    property var eventDescriptor: null

    readonly property Thing thing: eventDescriptor && eventDescriptor.thingId ? engine.thingManager.things.getThing(eventDescriptor.thingId) : null
    readonly property var iface: eventDescriptor && eventDescriptor.interfaceName ? Interfaces.findByName(eventDescriptor.interfaceName) : null
    readonly property var stateType: thing ? thing.thingClass.stateTypes.getStateType(eventDescriptor.eventTypeId)
                                            : iface ? iface.eventTypes.findByName(eventDescriptor.interfaceEvent) : null

    signal backPressed();
    signal completed();

    header: NymeaHeader {
        text: "Options"
        onBackPressed: root.backPressed();
    }

    ColumnLayout {
        anchors.fill: parent
        ColumnLayout {
            Layout.fillWidth: true
            property alias paramType: paramDescriptorDelegate.paramType
            property alias value: paramDescriptorDelegate.value
            property alias considerParam: paramCheckBox.checked
            property alias operatorType: paramDescriptorDelegate.operatorType
            CheckBox {
                id: paramCheckBox
                text: qsTr("Only consider state change if")
                Layout.fillWidth: true
                Layout.leftMargin: app.margins
                Layout.rightMargin: app.margins
            }

            ParamDescriptorDelegate {
                id: paramDescriptorDelegate
                enabled: paramCheckBox.checked
                Layout.fillWidth: true
                stateType: root.stateType
                value: stateType.defaultValue
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        Button {
            text: "OK"
            Layout.fillWidth: true
            Layout.margins: app.margins
            onClicked: {
                root.eventDescriptor.paramDescriptors.clear();
                if (paramDelegate.considerParam) {
                    if (root.thing) {
                        root.eventDescriptor.paramDescriptors.setParamDescriptor(root.stateType.id, paramDescriptorDelegate.value, paramDescriptorDelegate.operatorType)
                    } else if (root.iface) {
                        root.eventDescriptor.paramDescriptors.setParamDescriptorByName(root.stateType.name, paramDescriptorDelegate.value, paramDescriptorDelegate.operatorType)
                    }
                }
                root.completed()
            }
        }
    }
}
