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

#include "platformhelperios.h"
#include <QDebug>
#include <QUuid>
#include <QScreen>
#include <QApplication>
#include <QtWebView>

PlatformHelperIOS::PlatformHelperIOS(QObject *parent) : PlatformHelper(parent)
{
    QtWebView::initialize();

    QScreen *screen = qApp->primaryScreen();
    screen->setOrientationUpdateMask(Qt::PortraitOrientation | Qt::LandscapeOrientation | Qt::InvertedPortraitOrientation | Qt::InvertedLandscapeOrientation);
    QObject::connect(screen, &QScreen::orientationChanged, qApp, [this](Qt::ScreenOrientation) {
        setBottomPanelColor(bottomPanelColor());
    });
}

void PlatformHelperIOS::hideSplashScreen()
{
    // Nothing to be done
}

QString PlatformHelperIOS::machineHostname() const
{
    return QSysInfo::machineHostName();
}

QString PlatformHelperIOS::device() const
{
    return deviceModel();
}

QString PlatformHelperIOS::deviceSerial() const
{
    // There is no way on iOS to get to a persistent serial number of the device.
    // We're not interested tracking users or the actual serials anyways but we want
    // something that is persistent across app installations. So let's generate a UUID
    // ourselves and store that in the keychain.
    QString deviceId = const_cast<PlatformHelperIOS*>(this)->readKeyChainEntry("io.guh.nymea-app", "deviceId");
    qDebug() << "read keychain value:" << deviceId;
    if (deviceId.isEmpty()) {
        deviceId = QUuid::createUuid().toString();
        const_cast<PlatformHelperIOS*>(this)->writeKeyChainEntry("io.guh.nymea-app", "deviceId", deviceId);
    }
    qDebug() << "Returning device ID" << deviceId;
    return deviceId;
}

QString PlatformHelperIOS::deviceModel() const
{
    return QSysInfo::prettyProductName();
}

QString PlatformHelperIOS::deviceManufacturer() const
{
    return QString("iPhone");
}

void PlatformHelperIOS::vibrate(PlatformHelper::HapticsFeedback feedbackType)
{
    switch (feedbackType) {
    case HapticsFeedbackSelection:
        generateSelectionFeedback();
        break;
    case HapticsFeedbackImpact:
        generateImpactFeedback();
        break;
    case HapticsFeedbackNotification:
        generateNotificationFeedback();
        break;
    }
}

void PlatformHelperIOS::setTopPanelColor(const QColor &color)
{
    PlatformHelper::setTopPanelColor(color);
    setTopPanelColorInternal(color);
}

void PlatformHelperIOS::setBottomPanelColor(const QColor &color)
{
    PlatformHelper::setBottomPanelColor(color);

    // In landscape, ignore settings and keep it to black. On notched devices it'll look crap otherwise
    if (qApp->primaryScreen()->orientation() == Qt::LandscapeOrientation || qApp->primaryScreen()->orientation() == Qt::InvertedLandscapeOrientation) {
        setBottomPanelColorInternal(QColor("black"));
    } else {
        setBottomPanelColorInternal(color);
    }

}

