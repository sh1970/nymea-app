import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import "qrc:/ui/components"
import "qrc:/ui/customviews"
import Nymea 1.0
import Nymea.AirConditioning 1.0
import QtCharts 2.3

NymeaToolTip {
    id: root
    width: layout.implicitWidth + Style.smallMargins * 2
    height: layout.implicitHeight + Style.smallMargins * 2

    property Thing thing: null
    property NewLogEntry entry: null
    property string valueName: ""
    property alias iconSource: icon.name
    property alias color: rect.color
    property ValueAxis axis: null
    property int unit: Types.UnitNone

    readonly property var value: entry.values[valueName]
    readonly property int realY: entry ? Math.min(Math.max(mouseArea.height - (root.value * mouseArea.height / axis.max) - height / 2 /*- Style.margins*/, 0), mouseArea.height - height) : 0
    property int fixedY: 0
    y: fixedY // Animated

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Style.smallMargins

        ColorIcon {
            id: icon
            size: Style.smallIconSize
            color: root.color
            visible: name != ""
        }

        Rectangle {
            id: rect
            width: Style.extraSmallFont.pixelSize
            height: width
            visible: !icon.visible
        }
        Label {
            text: "%1: %2%3".arg(thing.name).arg(entry ? round(Types.toUiValue(root.value, unit)) : "-").arg(Types.toUiUnit(unit))
            Layout.fillWidth: true
            font: Style.extraSmallFont
            elide: Text.ElideMiddle
            function round(value) {
                return Math.round(value * 100) / 100
            }
        }
    }
}
